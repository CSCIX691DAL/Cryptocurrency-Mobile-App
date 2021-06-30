import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dal_app/Authentication/sign_in_screen.dart';
import 'package:dal_app/Misc.%20Views/FullScreenLoader.dart';
import 'package:dal_app/ProportionalSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  VoidCallback advance;

  ProfileScreen({@required this.advance});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState(advance: advance);
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  VoidCallback advance;

  bool get wantKeepAlive => true;

  _ProfileScreenState({@required this.advance});

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Navigator.pop(context);

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),

        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 120,
                  backgroundImage: _image != null ? FileImage(_image) : null,
                  child: _image == null ? Text("Picture") : null,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Change image"),
                onPressed: () {
                  getImage();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(width: 50,
                child: Text("Name: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(width: 50,
                child: Text("Email: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),

          ],
        ),
      ),
    );


  }
}
