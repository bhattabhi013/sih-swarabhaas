import 'dart:convert';
import 'dart:io';
import 'dart:js';
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
  String? _fileUrl;
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

      print("resp" + response.secureUrl);
      var headers = {
        'accept': 'application/json',
        'content-type': 'application/x-www-form-urlencoded',
      };
      _fileUrl = response.secureUrl;
      var params = {
        'file_url': response.secureUrl,
        'target_lang': val,
      };
      var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

      var url = Uri.parse('http://20.244.27.133/video?$query');
      var apiResponse = await http.post(url, headers: headers);
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

  void receiveVideo(String lang) async {
    var headers = {
      'accept': 'application/json',
    };

    var params = {
      'secure_url': _fileUrl,
      'target_lang': lang,
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse('http://20.244.27.133/video?$query');
    var apiResponse = await http.get(url, headers: headers);
    if (apiResponse.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(apiResponse.body) as Map<String, dynamic>;
      String path = jsonResponse['secure_url'].toString();
      print(path);
      GallerySaver.saveVideo(path).then((value) => {
            if (value != null && value) {showSnack(context)}
          });
    } else {
      print('Request failed with status: ${apiResponse.statusCode}.');
    }
  }

  void showSnack(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void toggleButton() {
    // remove set state from animated button and add provider
  }
}
