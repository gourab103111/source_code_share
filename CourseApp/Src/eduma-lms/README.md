# flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


1. Setup môi trường chạy flutter theo documentation https://docs.flutter.dev/get-started/install/macos
2. Cạy lệnh npx pod-install (Nhớ đọc kỹ hướng dẫn ở bước 1 có yêu cầu cài cocoapods)
3. Chạy lệnh "open -a simulator" để mở máy ảo ios
4. Chạy flutter run để build và cài app vào máy ảo

//
flutter pub run build_runner build


-------------------------
Với android add thêm dòng này vào file local.properties trong folder android

flutter.compileSdkVersion=32
flutter.minSdkVersion=21
flutter.targetSdkVersion=32