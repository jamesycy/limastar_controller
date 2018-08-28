import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/util/helper.dart';
import 'package:limastar_controller/screen/edit_helper/EditHelperScreen.dart';

class HelperDetailScreen extends StatelessWidget {
  final _fs = Firestore.instance;
  final Helper helper;

  HelperDetailScreen({ Key key, @required this.helper }) : super(key:key);

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Helper Detail"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                final route = MaterialPageRoute(builder: (BuildContext context) => EditHelperScreen(helper: helper));
                Navigator.of(context).push(route);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _fs.collection("helpers").document(this.helper.id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null || snapshot.data.exists == false) {
              return Center(child: Text("Helper Not Found"));
            }

            final doc = Helper.fromSnapshot(snapshot.data);
            final category = doc.category;

            return Container(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: doc.avatar.isNotEmpty ? NetworkImage(doc.avatar) : null,
                      backgroundColor: doc.avatar.isNotEmpty ? null : Colors.black26,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0)),

                    Card(
                      elevation: 5.0,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Helper Info", style: TextStyle(fontSize: 16.0)),
                          ),
                          ListTile(title: Text("Name"), subtitle: Text(doc.name)),
                          ListTile(title: Text("Nationality"), subtitle: Text(doc.nationality)),
                          ListTile(title: Text("Experience"), subtitle: Text(doc.experience)),
                          ListTile(title: Text("Availability"), subtitle: Text(doc.available ? "Available" : "Not Available"))
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 12.0)),

                    Card(
                      elevation: 5.0,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Helper Categories", style: TextStyle(fontSize: 15.0)),
                          ),
                          ListTile(title: Text("Baby"), trailing: Text(category['baby'] ? "Yes" : "No")),
                          ListTile(title: Text("Children"), trailing: Text(category['children'] ? "Yes" : "No")),
                          ListTile(title: Text("Elderly"), trailing: Text(category['elderly'] ? "Yes" : "No")),
                          ListTile(title: Text("MainLand"), trailing: Text(category['mainland'] ? "Yes" : "No")),
                          ListTile(title: Text("Pets"), trailing: Text(category['pets'] ? "Yes" : "No")),
                          ListTile(title: Text("Cooking"), trailing: Text(category['cooking'] ? "Yes" : "No")),
                          ListTile(title: Text("Cleaning"), trailing: Text(category['cleaning'] ? "Yes" : "No")),
                        ],
                      )
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 12.0)),

                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text("Remove Helper"),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext alertContext) => AlertDialog(
                              title: Text("Warning"),
                              content: Text("Are you sure to reomve this helper ?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Yes, I'm sure"),
                                  textColor: Colors.red,
                                  onPressed: () async {
                                    await _fs.collection("helpers").document(helper.id).delete();
                                    Navigator.of(alertContext).pop();
                                    Navigator.of(context).pop();
                                  }
                                ),
                                FlatButton(
                                  child: Text("No"),
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(alertContext).pop();
                                  }
                                )
                              ],
                            )
                          );
                        },
                      )
                    ),

                    Padding(padding: EdgeInsets.only(bottom: 12.0))

                  ]
                )
              )
            );

          }
        ),
      );
    }
}