/*
 *  fcm_enable.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'dart:io';
import 'package:dart_common_utils/dart_common_utils.dart';

void main() {
  step1();
  step2();
  step3();
  step4();
  step5();
}

// Clean project.
void step1() {
  File('ios/Podfile.lock').adaptPath.deleteIfExistsSync();
  Directory('ios/Pods').adaptPath.deleteIfExistsSync(recursive: true);
  Directory('ios/.symlinks').adaptPath.deleteIfExistsSync(recursive: true);
}

// Add dependencies to 'pubspec.yaml' file.
void step2() {
  const filename = 'pubspec.yaml';
  const line1 = 'firebase_core: 3.13.0';
  const line2 = 'firebase_messaging: 15.2.5';
  const line3 = 'flutter_local_notifications: 19.2.0';

  final content = File(filename).adaptPath.readAsStringSync();
  if (!content.contains('#$line1')) System.die('Fsm is already enabled.');

  File(filename).adaptPath.replaceContent('#$line1', line1);
  File(filename).adaptPath.replaceContent('#$line2', line2);
  File(filename).adaptPath.replaceContent('#$line3', line3);
}

// Rename Off and Dummy files.
void step3() {
  const filename = 'lib/services/fcm_service.dart';
  const filenameOff = 'lib/services/fcm_service.off';
  const filenameDummy = 'lib/services/fcm_service.dummy';

  if (!File(filename).adaptPath.existsSync()) {
    System.die('File "$filename" not found.');
  }

  if (!File(filenameOff).adaptPath.existsSync()) {
    System.die('File "$filenameOff" not found.');
  }

  File(filename).adaptPath.renameSync(File(filenameDummy).adaptPath.path);
  File(filenameOff).adaptPath.renameSync(File(filename).adaptPath.path);
}

// Add Push Notifications capability in Xcode.
void step4() {
  const filename = 'ios/Runner/Runner.entitlements';
  const debugFilename = 'ios/Runner/RunnerDebug.entitlements';
  const entitlements = '''<dict>
	<key>aps-environment</key>
	<string>development</string>
</dict>''';

  File(filename).adaptPath.replaceContent('<dict/>', entitlements);
  File(debugFilename).adaptPath.replaceContent('<dict/>', entitlements);
}

// Add firebase to gradle.
void step5() {
  const filename1 = 'android/settings.gradle';
  const filename2 = 'android/app/build.gradle';

  const line1 =
      'id "com.google.gms.google-services" version "4.3.15" apply false';
  const line2 = 'id "com.google.gms.google-services"';

  const line3 =
      "implementation platform('com.google.firebase:firebase-bom:33.1.1')";
  const line4 = "implementation 'com.google.firebase:firebase-analytics'";

  const line5 = "coreLibraryDesugaringEnabled true";
  const line6 =
      "coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.2'";

  File(filename1).adaptPath.replaceContent('//$line1', line1);
  File(filename2).adaptPath.replaceContent('//$line2', line2);
  File(filename2).adaptPath.replaceContent('//$line3', line3);
  File(filename2).adaptPath.replaceContent('//$line4', line4);
  File(filename2).adaptPath.replaceContent('//$line5', line5);
  File(filename2).adaptPath.replaceContent('//$line6', line6);
}
