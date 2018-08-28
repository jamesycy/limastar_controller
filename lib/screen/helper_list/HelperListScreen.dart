import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/util/helper.dart';
import 'package:limastar_controller/screen/add_helper/AddHelperScreen.dart';
import 'package:limastar_controller/screen/helper_detail/HelperDetailScreen.dart';

class HelperListScreen extends StatelessWidget {
  final _fs = Firestore.instance;
  final String tripid;

  HelperListScreen({ Key key, @required this.tripid }) : super(key:key);

  Widget _showAvatar(Helper helper) {
    return helper.avatar.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(helper.avatar)) : Icon(Icons.person);
  }

  void _navigateToCreate(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) => AddHelperScreen(tripid: tripid));
    Navigator.of(context).push(route);
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 1.0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () { _navigateToCreate(context); },
        ),
        appBar: AppBar(
          title: Text("Trip Helpers"),
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
              child: ListView.builder(
                itemCount: query.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final doc = Helper.fromSnapshot(query.data.documents[index]);
                  
                  return ListTile(         
                    leading: _showAvatar(doc),
                    title: Text('${doc.name}'),
                    subtitle: Text(doc.experience),
                    trailing: doc.available ? Icon(Icons.done, color: Colors.green) : Icon(Icons.close, color: Colors.red),
                    onTap: () {
                      final route = MaterialPageRoute(builder: (BuildContext context) => HelperDetailScreen(helper: doc));
                      Navigator.of(context).push(route);
                    },
                  );
                }
              )
            );
          },
        )
      );
    }
}