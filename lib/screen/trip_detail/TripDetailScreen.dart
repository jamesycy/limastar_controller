import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/util/trip.dart';
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
          textColor: Colors.redAccent,
          child: Text("Yes, I'm sure"),
          onPressed: () async {
            Navigator.of(alertContext).pop();
            _fs.collection("trips").document(this.tripid).delete();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Colors.blueAccent,
          child: Text("No"),
          onPressed: () {
            Navigator.of(alertContext).pop();
          },
        )

      ],
    );
  }

  void _navigateToEdit(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) => EditTripScreen(tripid: tripid));
    Navigator.of(context).push(route);
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Trip Detail"),
        ),
        body: StreamBuilder(
          stream: _fs.collection("trips").document(this.tripid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Trip not found")
              );
            }

            if (snapshot.data.data == null) {
              return Center(
                child: Text("Trip Deleted")
              );
            }

            final data = Trip.fromJson(snapshot.data.data, snapshot.data.documentID);

            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(leading: Icon(Icons.text_fields), title: Text("Trip Title"), subtitle: Text(data.title), onLongPress: () { _navigateToEdit(context); }),
                  ListTile(leading: Icon(Icons.date_range), title: Text("Trip Date"), subtitle: Text(data.createdAt), onLongPress: () { _navigateToEdit(context); }),
                  ListTile(leading: Icon(Icons.share), title: Text("Trip Status"), subtitle: Text(data.active ? "Active" : "Inactive"), onLongPress: () { _navigateToEdit(context); }),
                  ListTile(leading: Icon(Icons.list), title: Text("Helpers"), subtitle: Text(data.helpers.toString()),
                    onLongPress: () { _navigateToEdit(context); },
                    onTap: () { 
                      final route = MaterialPageRoute(builder: (BuildContext context) => HelperListScreen(tripid: tripid));
                      Navigator.of(context).push(route);
                    }
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text("Delete Trip", style: TextStyle(fontSize: 17.0)),
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