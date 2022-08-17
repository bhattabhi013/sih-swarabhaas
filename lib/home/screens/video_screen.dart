import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:swarabhaas/home/providers/home_provider.dart';
import 'package:swarabhaas/home/widgets/toggle_button.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isVideoAvailable = false;
  late XFile _video;
  int _toggleValue = 0;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context, listen: true);
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: mediaquery.size.height * 0.1),
          Container(
            height: mediaquery.size.width * 0.6,
            width: mediaquery.size.width * 0.9,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 3),
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                const Text(
                  'Upload any video you want the transcription of.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Open-Sauce-Sans',
                    fontSize: 18.0,
                    color: Color.fromARGB(221, 56, 56, 56),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: mediaquery.size.height * 0.05),
                InkWell(
                  onTap: () => getVideoFromDevice(homeProvider),
                  child: SvgPicture.asset(
                    'assets/images/gridicons_video.svg',
                    height: mediaquery.size.width * 0.2,
                    width: mediaquery.size.width * 0.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: mediaquery.size.height * 0.05),
          Container(
            // color: Colors.amberAccent,
            height: mediaquery.size.height * 0.05,
            width: mediaquery.size.height * 0.3,
            child: const Text(
              '*Please select the language you want to convert the video in.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Open-Sauce-Sans',
                fontSize: 15.0,
                color: Colors.black87,
              ),
            ),
          ),
          AnimatedToggle(
            values: ['English', 'Hindi'],
            onToggleCallback: (value) {
              setState(() {
                _toggleValue = value;
              });
            },
            buttonColor: Color.fromARGB(255, 251, 84, 7),
            backgroundColor: Color.fromARGB(255, 209, 209, 214),
            textColor: const Color(0xFFFFFFFF),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              homeProvider.getShowDownload()
                  ? Container(
                      width: 235.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: Colors.blueAccent,
                      ),
                      child: Center(
                          child: TextButton.icon(
                        onPressed: () => getVideo(homeProvider),
                        icon: const Icon(Icons.cloud_download_outlined,
                            color: Colors.white),
                        label: const Text(
                          ' Download',
                          style: TextStyle(
                            fontFamily: 'Open-Sauce-Sans',
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      )),
                    )
                  : Center(),
              SizedBox(height: mediaquery.size.height * 0.01),
              _isVideoAvailable
                  ? !homeProvider.getIsCaptioning()
                      ? Container(
                          width: 235.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Colors.blueAccent,
                          ),
                          child: Center(
                              child: TextButton.icon(
                            onPressed: () => sendVideo(homeProvider),
                            icon: const Icon(Icons.cloud_upload_outlined,
                                color: Colors.white),
                            label: const Text(
                              ' Upload',
                              style: TextStyle(
                                fontFamily: 'Open-Sauce-Sans',
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          )),
                        )
                      : Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 5.0,
                            percent:
                                homeProvider.getUploadingPercent().toDouble(),
                            center: Text(
                                (homeProvider.getUploadingPercent() * 100)
                                    .toStringAsFixed(2)),
                            progressColor: Colors.green,
                          ),
                        )
                  : Center(),
            ],
          ),
        ],
      ),
    );
  }

  getVideoFromDevice(HomePageProvider homeProvider) async {
    //final ImagePicker _picker = ImagePicker();
    File? video;
    final XFile? pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: Duration(seconds: 300));
    if (pickedVideo != null) {
      _video = pickedVideo;
    }
    setState(() {
      _isVideoAvailable = true;
    });
  }

  sendVideo(HomePageProvider homeProvider) {
    homeProvider.setIsCaptioning(true);
    homeProvider.sendVideo(_video, _toggleValue);
    //homeProvider.receiveVideo();
  }

  getVideo(HomePageProvider homeProvider) {
    homeProvider.receiveVideo();
  }
}
