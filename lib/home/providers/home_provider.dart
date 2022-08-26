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

  Future<String?> sendVideo(XFile video, String val, BuildContext ctx) async {
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
      // Navigator.of(ctx).pop();
      Future.delayed(Duration(seconds: 30), () {
        //_fetchData(ctx);
        set_showDownload(true);
      });
      setUploadPercent(0.0);
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
  }

  void receiveVideo(String lang, BuildContext context) async {
    //_fetchData(context);
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
    Navigator.of(context).pop();
    if (apiResponse.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(apiResponse.body) as Map<String, dynamic>;
      String path = jsonResponse['secure_url'].toString();
      print(path);
      GallerySaver.saveVideo(path).then((value) => {
            if (value != null && value)
              {
                showSnack(
                    context, "Video downloaded successfully", Colors.green)
              }
            else
              {showSnack(context, "OOPS! Try again", Colors.red)}
          });
    } else {
      print('Request failed with status: ${apiResponse.statusCode}.');
    }
  }

  void showSnack(BuildContext context, String text, Color color) {
    const snackBar = SnackBar(
      content: Text('Video downloaded successfully'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void toggleButton() {
    // remove set state from animated button and add provider
  }

  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    await Future.delayed(const Duration(seconds: 3));

    // Close the dialog programmatically
    Navigator.of(context).pop();
  }
}
