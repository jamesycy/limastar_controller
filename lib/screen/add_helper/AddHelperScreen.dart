import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddHelperScreen extends StatefulWidget {
  final String tripid;

  AddHelperScreen({ Key key, @required this.tripid }) : super(key : key);

  @override
    _AddHelperScreen createState() => _AddHelperScreen();
}

class _AddHelperScreen extends State<AddHelperScreen> {
  final _fs = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  final _isLoading = false;

  var _avatar;
  var _name = TextEditingController();
  var _nationality = "Filipino";
  final _experience = TextEditingController();
  final _category = {
    "baby": false,
    "children": false,
    "elderly": false,
    "mainland": false,
    "cooking": false,
    "cleaning": false,
    "pets": false
  };
  var _available = true;

  Widget _actionSheet() {
    return RaisedButton(
      child: Text(_nationality),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(title: Text("Filipino"), onTap: () {
                  setState(() {
                    _nationality = "Filipino";
                    Navigator.of(context).pop();
                  });
                }),
                ListTile(title: Text("Indonesian"), onTap: () {
                  setState(() {
                    _nationality = "Indonesian";
                    Navigator.of(context).pop();
                  });
                })
              ],
            );
          }
        );
      }
    );
  }

  _uploadAvatar(String helperid) async {
    final upload = _storage.ref().child('avatar/${widget.tripid}/${helperid}').putFile(_avatar);
    final downloadUrl = (await upload.future).downloadUrl;
    await _fs.collection("helpers").document(helperid).updateData({
      "avatar": downloadUrl.toString()
    });
    Navigator.of(context).pop();
  }

  _saveHelper() {
    _fs.collection("helpers").add({
      "name": _name.text,
      "nationality": _nationality,
      "experience": _experience.text,
      "available": _available,
      "category": _category,
      "tripid": widget.tripid,
    }).then((result) {
      _uploadAvatar(result.documentID);
    }).catchError((error) {
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error.toString()),
        actions: <Widget>[
          FlatButton(child: Text("Dismiss"), onPressed: () { Navigator.of(context).pop(); })
        ]
      ));
    });
  }

  bool _verifyInput() {
    if (_name.text.isNotEmpty && _available != null && _category != null) {
      return true;
    }
    return false;
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add Helper")
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FlatButton(
                  color: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600.0, maxHeight: 600.0).then((file) {
                        setState(() {
                          _avatar = file;
                        });
                      });
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: _avatar != null ? Colors.transparent : Colors.black54,
                    backgroundImage: _avatar != null ? FileImage(_avatar) : null,
                    radius: 45.0,
                  )
                ),

                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text("Helper Info", style: TextStyle(fontSize: 16.0)),
                        TextFormField(controller: _name, decoration: InputDecoration(labelText: "Helper Name")),
                        TextFormField(controller: _experience, decoration: InputDecoration(labelText: "Helper Experience")),
                        ListTile(title: Text("Helper Nationality"), trailing: _actionSheet()),
                        ListTile(
                          title: Text("Helper Status"),
                          trailing: Switch(value: _available, onChanged: (value) {
                            setState(() {
                              _available = value;
                            });
                          })
                        ),
                      ],
                    )
                  ),
                ),

                Padding(padding: EdgeInsets.all(10.0)),

                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text("Helper Category", style: TextStyle(fontSize: 16.0)),
                        CheckboxListTile(
                          title: Text("Baby"),
                          value: _category["baby"],
                          onChanged: (value) { setState(() { _category["baby"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Children"),
                          value: _category["children"],
                          onChanged: (value) { setState(() { _category["children"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Elderly"),
                          value: _category["elderly"],
                          onChanged: (value) { setState(() { _category["elderly"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Mainland"),
                          value: _category["mainland"],
                          onChanged: (value) { setState(() { _category["mainland"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Cooking"),
                          value: _category["cooking"],
                          onChanged: (value) { setState(() { _category["cooking"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Cleaning"),
                          value: _category["cleaning"],
                          onChanged: (value) { setState(() { _category["cleaning"] = value; }); },
                        ),
                        CheckboxListTile(
                          title: Text("Pets"),
                          value: _category["pets"],
                          onChanged: (value) { setState(() { _category["pets"] = value; }); },
                        ),
                      ],
                    )
                  )
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 18.0))

              ]
            )
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_isLoading == false) {
              final result = _verifyInput();
              result ? _saveHelper() : showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Some fields is missing"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Dismiss"),
                      onPressed: () { Navigator.of(context).pop(); }
                    )
                  ],
                )
              );
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black87,
        ),
      );
    }
}