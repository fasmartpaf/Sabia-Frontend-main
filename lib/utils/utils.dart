import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:device_info/device_info.dart';

String uuid() => Uuid().v4();

Future<Map<String, dynamic>> deviceInfo() async {
  Map<String, dynamic> info = {};
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    info["isMobile"] = true;
    info["androidId"] = androidInfo.androidId;
    info["deviceBrand"] = androidInfo.brand;
    info["deviceModel"] = androidInfo.model;
    info["operatingSystem"] = "Android ${androidInfo.version.release}";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    info["isMobile"] = true;
    info["deviceName"] = iosInfo.name;
    info["deviceModel"] = iosInfo.model;
    info["operatingSystem"] = "${iosInfo.systemName} ${iosInfo.systemVersion}";
    info["sysName"] = iosInfo.utsname.sysname;
    info["sysVersion"] = iosInfo.utsname.version;
    info["sysNodename"] = iosInfo.utsname.nodename;
    info["sysMachine"] = iosInfo.utsname.machine;
    info["sysRelease"] = iosInfo.utsname.release;
  }

  return info;
}

String firstNameOnly(String fullName) {
  if (fullName == null || fullName.isEmpty) return "";
  return fullName.split(" ")[0];
}

Future<bool> tryToOpenUrl(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    }
    return false;
  } catch (e) {
    print("error openning url $url");
    return false;
  }
}
