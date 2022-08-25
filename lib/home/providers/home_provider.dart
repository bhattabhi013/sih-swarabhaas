import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
// import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class HomePageProvider extends ChangeNotifier {
  bool _isCaptioning = false;
  late double _uploadingPercentage = 0.0;
  bool _isHindi = false;
  late String _fileUrl;
  bool _showDownload = false;

  toggleIsHindi() {
    _isHindi = !_isHindi;
  }

  getIsHindi() {
    return _isHindi;
  }

  void setIsCaptioning(bool val) {
    _isCaptioning = val;
    notifyListeners();
  }

  bool getIsCaptioning() {
    print("_isCaptioning" + _isCaptioning.toString());
    return _isCaptioning;
  }

  void setUploadPercent(double percent) {
    _uploadingPercentage = percent;
    notifyListeners();
  }

  bool getShowDownload() {
    return _showDownload;
  }

  set_showDownload(bool val) {
    _showDownload = val;
    notifyListeners();
  }

  double getUploadingPercent() {
    print("_uploadingPercentage" + _uploadingPercentage.toString());
    return _uploadingPercentage;
  }

  final cloudinary = CloudinaryPublic('mait', 'rcbgzwxf', cache: false);

  Future<String?> sendVideo(XFile video, String val) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(video.path,
            resourceType: CloudinaryResourceType.Video),
        onProgress: (count, total) => {setUploadPercent(count / total)},
      );
      // if (toggleValue == 0) {
      //   _isHindi = false;
      // } else {
      //   _isHindi = true;
      // }
      print("resp" + response.secureUrl);
      _fileUrl = response.secureUrl;
      var body1 = {"file_url": response.secureUrl, "target_lang": val};
      final uri = Uri.parse("http://20.244.27.133/video");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final apiResponse =
          await http.post(uri, headers: headers, body: json.encode(body1));

      if (apiResponse.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(apiResponse.body) as Map<String, dynamic>;
        print(" resp: " + jsonResponse.toString());
      } else {
        print('Request failed with status: ${apiResponse.statusCode}.');
      }
      setIsCaptioning(false);
      Future.delayed(Duration(seconds: 50), () {
        set_showDownload(true);
      });
      setUploadPercent(0.0);
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
  }

  void receiveVideo() async {
    var queryParameters = {
      "secure_url": _fileUrl,
      // "is_hindi": getIsHindi().toString()
    };
    final uri = Uri.http('http://20.244.27.133', '/video', queryParameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final apiResponse = await http.get(uri, headers: headers);
    if (apiResponse.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(apiResponse.body) as Map<String, dynamic>;
      String path = jsonResponse['secure_url'].toString();
      print(path);
      GallerySaver.saveVideo(path).then((value) => print(value));
    } else {
      print('Request failed with status: ${apiResponse.statusCode}.');
    }
  }

  void toggleButton() {
    // remove set state from animated button and add provider
  }
}
