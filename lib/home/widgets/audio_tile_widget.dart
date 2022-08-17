import 'package:flutter/material.dart';

class AudioTileWidget extends StatelessWidget {
  AudioTileWidget(
      {required this.imgPath,
      required this.name,
      required this.iconName,
      required this.time});
  String imgPath;
  String name;
  IconData iconName;
  String time;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Image.asset(
          imgPath,
          height: mediaquery.size.height * 0.1,
          width: mediaquery.size.width * 0.1,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Open-Sauce-Sans',
            fontSize: 20.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(iconName, size: 15, color: Colors.blueAccent),
              ),
              TextSpan(
                text: time,
                style: const TextStyle(
                  fontFamily: 'Open-Sauce-Sans',
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.call_outlined,
          color: Color.fromARGB(255, 42, 165, 106),
        ),
      ),
    );
  }
}
