import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHelperScreen extends StatefulWidget {
  final String tripid;

  AddHelperScreen({ Key key, @required this.tripid }) : super(key : key);

  @override
    _AddHelperScreen createState() => _AddHelperScreen();
}

class _AddHelperScreen extends State<AddHelperScreen> {
  final _fs = Firestore.instance;

  final _name = TextEditingController();
  final _nationality = TextEditingController();
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

  _saveHelper() {
    _fs.collection("helpers").add({
      "name": _name.text,
      "nationality": _nationality.text,
      "experience": _experience.text,
      "available": _available,
      "category": _category,
      "tripid": widget.tripid
    }).then((_) {
      Navigator.of(context).pop();
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
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text("Helper Info"),
                        TextFormField(controller: _name, decoration: InputDecoration(labelText: "Helper Name")),
                        TextFormField(controller: _nationality, decoration: InputDecoration(labelText: "Helper Nationality")),
                        TextFormField(controller: _experience, decoration: InputDecoration(labelText: "Helper Experience")),
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
                        Text("Helper Category"),
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

                Padding(padding: EdgeInsets.all(12.0)),

                RaisedButton(
                  child: Text("Save Helper"),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    _saveHelper();
                  }
                )
              ]
            )
          )
        )
      );
    }
}