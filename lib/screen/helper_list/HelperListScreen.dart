import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/screen/add_helper/AddHelperScreen.dart';

class HelperListScreen extends StatelessWidget {
  final _fs = Firestore.instance;
  final String tripid;

  HelperListScreen({ Key key, @required this.tripid }) : super(key:key);

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Trip Helpers"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final route = MaterialPageRoute(builder: (BuildContext context) => AddHelperScreen(tripid: tripid));
                Navigator.of(context).push(route);
              }
            )
          ],
        ),
        body: StreamBuilder(
          stream: _fs.collection("helpers").where("tripid", isEqualTo: tripid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
            if (query.data == null) {
              return Center(child: Text("Loading Trip Helpers...", style: TextStyle(fontSize: 16.0, color: Colors.black54)));
            }

            if (query.data.documents.length <= 0) {
              return Center(child: Text("This trip has no helpers", style: TextStyle(fontSize: 16.0, color: Colors.black54)));
            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                itemCount: query.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final doc = query.data.documents[index];
                  
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${doc.data['name']} - ${doc.data['nationality']}'),
                    subtitle: Text(doc.data['experience']),
                    trailing: (doc.data['available'] as bool) ? Icon(Icons.done, color: Colors.green) : Icon(Icons.close, color: Colors.red)
                  );
                }
              )
            );
          },
        )
      );
    }
}