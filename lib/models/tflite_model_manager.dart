import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteModelManager {
  static final TFLiteModelManager _instance = TFLiteModelManager._internal();
  factory TFLiteModelManager() => _instance;
  TFLiteModelManager._internal();

  Interpreter? _interpreter;
  String? _modelLoadedFor;
  List<String>? _labels;

  Future<void> loadModel(String diagnoseType) async {
    if (_modelLoadedFor == diagnoseType && _interpreter != null) return;

    _interpreter?.close();

    final modelPath = switch (diagnoseType) {
      "skin" => "assets/skinmodel.tflite",
      "oral" => "assets/oralmodel.tflite",
      _ => "assets/nailmodel.tflite",
    };

    final labelPath = switch (diagnoseType) {
      "skin" => "assets/skinlabel.txt",
      "oral" => "assets/orallabel.txt",
      _ => "assets/naillabel.txt",
    };

    _interpreter = await Interpreter.fromAsset(modelPath);
    _interpreter!.allocateTensors();
    _modelLoadedFor = diagnoseType;
    _labels = await loadLabels(labelPath);
  }

  Future<List<String>> loadLabels(String filePath) async {
    final rawLabels = await rootBundle.loadString(filePath);
    return rawLabels.split('\n');
  }

  List<String>? get labels => _labels;

  Future<List<double>> runModelOnTensor(
    Float32List tensorData, {
    required int numResults,
  }) async {
    if (_interpreter == null) {
      throw Exception("Interpreter not initialized.");
    }

    var inputList = tensorData.buffer.asFloat32List();

    var input = _reshapeInput(inputList, 224, 224, 3);
    var output = List.generate(1, (_) => List.filled(numResults, 0.0));

    _interpreter!.run(input, output);

    return List<double>.from(output[0]);
  }

  List<List<List<List<double>>>> _reshapeInput(
    Float32List inputList,
    int width,
    int height,
    int channels,
  ) {
    return [
      List.generate(
        height,
        (y) => List.generate(
          width,
          (x) => List.generate(
            channels,
            (c) =>
                inputList[y * width * channels + x * channels + c].toDouble(),
          ),
        ),
      ),
    ];
  }
}
