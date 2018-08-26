import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limastar_controller/screen/add_trip/AddTripScreen.dart';
import 'package:limastar_controller/screen/trip_detail/TripDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fs = Firestore.instance;

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Trips"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print("Settings");
              // final route = MaterialPageRoute(builder: (BuildContext context) => SettingsScreen());
              // Navigator.of(context).push(route);
            }
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final route = MaterialPageRoute(builder: (BuildContext context) => AddTripScreen());
                Navigator.of(context).push(route);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _fs.collection("trips").orderBy("created_at", descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> result) {
            final snapshot = result.data;

            if (snapshot == null) return Center(child: Text("Loading Trips..."));

            if (snapshot.documents.length <= 0) {
              return Center(
                child: Text("No Trips Saved Yet",  style: TextStyle(color: Colors.black54, fontSize: 18.0))
              );
            }

            return ListView.builder(
              itemCount: snapshot.documents.length,
              itemBuilder: (BuildContext context, int index) {
                final doc = snapshot.documents[index];
                return ListTile(
                  leading: Icon(Icons.flight_takeoff),
                  trailing: Text((doc.data["helpers"] as List<dynamic>).length.toString()),
                  title: Text(doc.data["title"]),
                  subtitle: Text(doc.data["created_at"]),
                  onTap: () {
                    final route = MaterialPageRoute(builder: (BuildContext context) => TripDetailScreen(tripid: doc.documentID));
                    Navigator.of(context).push(route);
                  }
                );
              }
            );
          }
        )
      );
    }
}