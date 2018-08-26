import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/screen/edit_trip/EditTripScreen.dart';
import 'package:limastar_controller/screen/helper_list/HelperListScreen.dart';

class TripDetailScreen extends StatelessWidget {
  final _fs = Firestore.instance;
  final String tripid;

  TripDetailScreen({ Key key, @required this.tripid }) : super(key : key);

  AlertDialog _buildAlert(BuildContext alertContext, BuildContext context) {
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure to remove this trip record ?"),
      actions: <Widget>[
        FlatButton(
          color: Colors.redAccent,
          textColor: Colors.white,
          child: Text("Yes, I'm sure"),
          onPressed: () async {
            Navigator.of(alertContext).pop();
            _fs.collection("trips").document(this.tripid).delete();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text("No"),
          onPressed: () {
            Navigator.of(alertContext).pop();
          },
        )

      ],
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Trip Detail"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                final route = MaterialPageRoute(builder: (BuildContext context) => EditTripScreen(tripid: tripid));
                Navigator.of(context).push(route);
              }
            )
          ],
        ),
        body: StreamBuilder(
          stream: _fs.collection("trips").document(this.tripid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Trip not found")
              );
            }

            final data = snapshot.data;

            if (data.data == null) {
              return Center(
                child: Text("Trip Deleted")
              );
            }

            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(leading: Icon(Icons.text_fields), title: Text("Trip Title"), trailing: Text(data.data['title'])),
                  ListTile(leading: Icon(Icons.date_range), title: Text("Trip Date"), trailing: Text(data.data['created_at'])),
                  ListTile(leading: Icon(Icons.share), title: Text("Trip Status"), trailing: Text((data.data['active'] as bool) ? "Active" : "Inactive")),
                  ListTile(leading: Icon(Icons.list), title: Text("Helpers"), trailing: Text(data.data["helpers"].length.toString())),
                  Container(
                    width: double.infinity,                    
                    margin: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("View Helpers", style: TextStyle(fontSize: 16.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        final route = MaterialPageRoute(builder: (BuildContext context) => HelperListScreen(tripid: tripid));
                        Navigator.of(context).push(route);
                      },
                    )
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Delete Trip", style: TextStyle(fontSize: 16.0)),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        showDialog(context: context, builder: (BuildContext alertContext) => _buildAlert(alertContext, context));
                      },
                    )
                  )
                ],
              )
            );
          }
        )
      );
    }
}