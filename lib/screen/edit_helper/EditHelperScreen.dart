import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:limastar_controller/util/helper.dart';

class EditHelperScreen extends StatefulWidget {
  final Helper helper;

  EditHelperScreen({ Key key, @required this.helper }) : super(key:key);

  @override
    _EditHelperScreen createState() => _EditHelperScreen();
}

class _EditHelperScreen extends State<EditHelperScreen> {
  final _fs = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  final categories = ["Baby", "Children", "Elderly", "Mainland", "Cooking", "Cleaning", "Pets"];

  TextEditingController _name;
  TextEditingController _experience;
  String _nationality;
  var _avatar;
  bool _available;
  Map<dynamic, dynamic> _category;

  void initState() {
    _name = TextEditingController(text: widget.helper.name);
    _experience = TextEditingController(text: widget.helper.experience);
    _nationality = widget.helper.nationality;
    _avatar = widget.helper.avatar;
    _available = widget.helper.available;
    _category = widget.helper.category;
  }

  void _saveChanges() async {
    final result = _verifyInput();
    if (result == true) {
      _avatar is File ? await _uploadAvatar() : null;
      
      await _fs.collection("helpers").document(widget.helper.id).updateData({
        "name": _name.text,
        "experience": _experience.text,
        "nationality": _nationality,
        "avatar": _avatar,
        "available": _available,
        "category": _category
      });

      Navigator.of(context).pop();
    }
  }

  Future<String> _uploadAvatar() async {
    final upload = _storage.ref().child('avatar/${widget.helper.tripid}/${widget.helper.id}').putFile(_avatar);
    final url = (await upload.future).downloadUrl.toString();
    setState(() { _avatar = url; });
    return url;
  }

  bool _verifyInput() {
    if (_name.text.isNotEmpty && _experience.text.isNotEmpty) {
      return true;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(title: Text("Error"), content: Text("Missing Name and Experience"))
    );
    return false;
  }

  void _bottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(title: Text("Filipino"), onTap: () {
            setState(() {
              _nationality = "Filipino";
            });
            Navigator.of(context).pop();
          }),
          ListTile(title: Text("Indonesian"), onTap: () {
            setState(() {
              _nationality = "Indonesian";
            });
            Navigator.of(context).pop();
          })
        ],
      )
    ); 
  }

  void _showImagePicker() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      setState(() {
        _avatar = file;
      });
    });
  }

  void _setCategory(String field, bool value) {
    setState(() {
      _category[field] = value;
    });
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Edit Helper")
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveChanges,
          backgroundColor: Colors.amber[400],
          foregroundColor: Colors.indigo[700],
          child: Icon(Icons.save)
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              
              FlatButton(
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 55.0,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _avatar is String ? NetworkImage(_avatar) : FileImage(_avatar),
                ),
                onPressed: _showImagePicker,
              ),

              Card(
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text("Helper Info", style: TextStyle(fontSize: 15.0)),
                      TextField(controller: _name, decoration: InputDecoration(labelText: "Name")),
                      TextField(controller: _experience, decoration: InputDecoration(labelText: "Experience")),
                      ListTile(
                        title: Text("Nationality"),
                        trailing: FlatButton(
                          textColor: Colors.blue[300],
                          child: Text(_nationality),
                          onPressed: () { _bottomSheet(); },
                        )
                      ),
                      ListTile(
                        title: Text("Status"),
                        trailing: Switch(
                          value: _available,
                          onChanged: (value) { setState(() { _available = value; }); },
                        )
                      )
                    ],
                  )
                ),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),

              Card(
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text("Helper Category", style: TextStyle(fontSize: 15.0)),
                      CheckboxListTile(
                        title: Text("Baby"),
                        value: _category['baby'],
                        onChanged: (value) { _setCategory("baby", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Children"),
                        value: _category['children'],
                        onChanged: (value) { _setCategory("children", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Elderly"),
                        value: _category['elderly'],
                        onChanged: (value) { _setCategory("elderly", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Mainland"),
                        value: _category['mainland'],
                        onChanged: (value) { _setCategory("mainland", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Cooking"),
                        value: _category['cooking'],
                        onChanged: (value) { _setCategory("cooking", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Cleaning"),
                        value: _category['cleaning'],
                        onChanged: (value) { _setCategory("cleaning", value); }
                      ),
                      CheckboxListTile(
                        title: Text("Pets"),
                        value: _category['pets'],
                        onChanged: (value) { _setCategory("pets", value); } 
                      )
                    ],
                  )
                )
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 15.0))

            ],
          )
        )
      );
    }

}