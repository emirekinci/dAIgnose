import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/data/disease_data.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/disease_info.dart';
import 'package:grad_project/models/tflite_model_manager.dart';
import 'package:grad_project/screens/patient/diagnose/diagnose_detail.dart';
import 'package:grad_project/services/diagnose_service.dart';
import 'package:grad_project/utils/util.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class DiagnoseUpload extends StatefulWidget {
  final String diagnoseType;

  const DiagnoseUpload({required this.diagnoseType, super.key});

  @override
  State<DiagnoseUpload> createState() => _DiagnoseUploadState();
}

class _DiagnoseUploadState extends State<DiagnoseUpload> {
  File? _image;
  img.Image? _resizedImage;
  String? _detectedDisease;
  final picker = ImagePicker();
  String? titleText;
  int? possibleResultCount;
  String? _diagnoseReliability;
  late String imageBase64;
  bool _isInitialized = false;

  final themeColor = Colors.red;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;

    _isInitialized = true;

    if (widget.diagnoseType == "skin") {
      titleText = AppLocalizations.of(context)!.skin_disease_diagnose;
      possibleResultCount = 10;
      return;
    }

    if (widget.diagnoseType == "nail") {
      titleText = AppLocalizations.of(context)!.nail_disease_diagnose;
      possibleResultCount = 6;
      return;
    }

    if (widget.diagnoseType == "oral") {
      titleText = AppLocalizations.of(context)!.oral_disease_diagnose;
      possibleResultCount = 6;
      return;
    }
  }

  Future<void> getImage(ImageSource source) async {
    var image = await picker.pickImage(source: source);

    if (!mounted || image == null) return;

    final file = File(image.path);
    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);
    imageBase64 = base64Encode(bytes);

    if (!mounted || decodedImage == null) return;

    setState(() {
      _image = file;
      _resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
      _detectedDisease = null;
    });
  }

  Future<Float32List> preprocessImageToTensor(File image) async {
    final bytes = await image.readAsBytes();
    final img.Image imageDecoded = img.decodeImage(bytes)!;

    final img.Image resizedImage = img.copyResize(
      imageDecoded,
      width: 224,
      height: 224,
    );

    final tensorData = imageToByteListFloat32(resizedImage, 224);

    return tensorData;
  }

  Float32List imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(inputSize * inputSize * 3);
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);

        convertedBytes[pixelIndex++] = (img.getRed(pixel) - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (img.getGreen(pixel) - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (img.getBlue(pixel) - 127.5) / 127.5;
      }
    }
    return convertedBytes;
  }

  Future<void> classifyImage(File image) async {
    if (_resizedImage == null) return;

    Float32List tensorData = await preprocessImageToTensor(image);

    await TFLiteModelManager().loadModel(widget.diagnoseType);
    final labels = TFLiteModelManager().labels;

    if (!mounted) return;

    var output = await TFLiteModelManager().runModelOnTensor(
      tensorData,
      numResults: possibleResultCount!,
    );

    if (!mounted) return;

    final result = getTopResult(output, labels!);
    final patientId = FirebaseAuth.instance.currentUser!.uid;

    if (!await DiagnoseService().isDuplicateDiagnose(patientId, imageBase64)) {
      if (!mounted) return;

      try {
        await DiagnoseService().addDiagnose(
          patientId,
          imageBase64,
          result?['label'],
          result?['confidence'] * 100,
          widget.diagnoseType,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.info_diagnose_save_failed} $e",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (!mounted) return;

    setState(() {
      _detectedDisease = result?['label'];
      _diagnoseReliability =
          "${(result?['confidence'] * 100).toStringAsFixed(2)}%";
    });
  }

  Map<String, dynamic>? getTopResult(List<double> output, List<String> labels) {
    if (output.isEmpty || labels.isEmpty) return null;

    double maxProb = output[0];
    int maxIndex = 0;

    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxProb) {
        maxProb = output[i];
        maxIndex = i;
      }
    }

    return {'label': labels[maxIndex], 'confidence': maxProb};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 60.0),
                Text(
                  titleText!,
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 7.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 260,
                      height: 260.0,
                      child:
                          _image == null
                              ? SizedBox(height: 224)
                              : Image.memory(
                                Uint8List.fromList(
                                  img.encodePng(_resizedImage!),
                                ),
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 7.0,
                    color: themeColor,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.white),
                            SizedBox(width: 5.0),
                            Text(
                              _image == null
                                  ? AppLocalizations.of(context)!.pick_image
                                  : AppLocalizations.of(
                                    context,
                                  )!.pick_new_image,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      (_image != null && _detectedDisease == null)
                          ? Material(
                            borderRadius: BorderRadius.circular(20.0),
                            elevation: 7.0,
                            color: themeColor,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () => classifyImage(_image!),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.analytics, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      AppLocalizations.of(context)!.diagnose,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          : SizedBox(),
                ),
                _detectedDisease != null
                    ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                            ),
                            child: Text(
                              "${_detectedDisease!.localizeDiseaseName(context)} - $_diagnoseReliability",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              _image != null
                                  ? Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    elevation: 7.0,
                                    color: themeColor,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width /
                                          2.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => DiagnoseDetail(
                                                      disease: diseaseList.firstWhere(
                                                        (disease) =>
                                                            disease.id ==
                                                            _detectedDisease,
                                                        orElse:
                                                            () => DiseaseInfo(
                                                              id: "0",
                                                              names: {
                                                                'en':
                                                                    AppLocalizations.of(
                                                                      context,
                                                                    )!.unknown,
                                                              },
                                                              descriptions: {
                                                                'en':
                                                                    'Açıklama yok',
                                                              },
                                                              imagePath:
                                                                  'assets/images/default.png',
                                                              category:
                                                                  DiseaseCategory
                                                                      .oral,
                                                            ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.description,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.disease_details,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : SizedBox(),
                        ),
                      ],
                    )
                    : SizedBox(),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
