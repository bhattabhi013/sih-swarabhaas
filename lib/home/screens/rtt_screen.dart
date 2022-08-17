import 'package:flutter/material.dart';

class RttScreenPage extends StatelessWidget {
  static const routeName = '/rtt-page';
  const RttScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.call_end_outlined,
                  color: Colors.red,
                  size: 30,
                )),
            Expanded(
                flex: 20,
                child: Text(
                  'Gauransh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Open-Sauce-Sans',
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ],
        ),
        backgroundColor: Color.fromARGB(255, 230, 230, 233),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
              child: Image.asset('assets/Frame 8.png'),
              margin: EdgeInsets.fromLTRB(180, 2, 0, 20),
              // color: Colors.yellow,
              height: 35,
              width: 230),
          Container(
              child: Image.asset(
                'assets/Frame 9.png',
                height: 110,
              ),
              margin: EdgeInsets.fromLTRB(8, 0, 80, 20),
              // color: Colors.yellow,
              // padding: EdgeInsets.all(0),
              height: 50,
              width: 500),
          Container(
              child: Image.asset('assets/Frame 10.png'),
              margin: EdgeInsets.fromLTRB(175, 0, 0, 20),
              // color: Colors.yellow,
              height: 35,
              width: 230),
          Container(
            child: Image.asset(
              'assets/Frame 11.png',
              height: 100,
            ),
            margin: EdgeInsets.fromLTRB(10, 2, 80, 20),
            // color: Colors.yellow,
            height: 50,
            // width: 100
          ),
          Container(
            child: Image.asset('assets/Frame 12.png'),
            margin: EdgeInsets.fromLTRB(245, 1, 2, 20),
            // color: Colors.yellow,
            height: 35,
            width: 230,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 70,
                child: Container(
                  // color: Colors.yellow,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(10, 210, 0, 10),
                  child: TextField(
                      style: TextStyle(
                        fontFamily: 'Open-Sauce-Sans',
                        fontSize: 19.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 0.0),
                          hintText: "Message",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 45.0),
                              borderRadius: BorderRadius.circular(25.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 32.0),
                              borderRadius: BorderRadius.circular(25.0)))),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                    // color: Colors.yellow,
                    margin: EdgeInsets.fromLTRB(2, 210, 0, 10),
                    child: Image.asset('assets/Group 20.png')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
