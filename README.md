# dAIgnose

A cross-platform mobile application for symptom-based health diagnosis using Flutter and TensorFlow Lite.

## Overview

dAIgnose allows users to upload images of visible symptoms (skin, oral, and nail) and receive fast, privacy-preserving on-device diagnoses.
The app aims to reduce unnecessary hospital visits and support healthcare professionals by providing preliminary diagnostic insights.

## Features

* Multi-role system: Patient, Doctor, Hospital and Admin dashboards.
* On-device diagnosis using TensorFlow Lite for faster and more secure processing.
* Firebase Authentication for user login and registration.
* Cloud Firestore for secure and scalable data storage.
* Cross-platform support for Android and iOS using Flutter.

## Workflow

1. User logs in through Firebase Authentication.
2. Patient uploads an image of the symptom.
3. TensorFlow Lite model processes the image on the device.
4. Diagnosis result and confidence score are displayed to the user.

## Technologies Used

* Flutter for UI and cross-platform development
* TensorFlow Lite for on-device image classification
* Firebase Authentication & Firestore for backend services

## Model Integration

Place your TensorFlow Lite model (examplemodel.tflite) under assets/ and declare it in pubspec.yaml:

```yaml

assets:
  - assets/examplemodel.tflite

```

## Future Work

* Expand dataset for higher accuracy
* Implement multimodal diagnosis

## License

This project is licensed under the MIT License.
