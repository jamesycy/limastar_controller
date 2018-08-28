import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Helper {
  String id;
  String name;
  String nationality;
  String experience;
  String tripid;
  String avatar;
  bool available;
  Map<dynamic, dynamic> category;

  Helper.fromSnapshot(DocumentSnapshot snapshot) :
    this.id = snapshot.documentID,
    this.name = snapshot.data['name'],
    this.nationality = snapshot.data['nationality'],
    this.experience = snapshot.data['experience'],
    this.tripid = snapshot.data['tripid'],
    this.avatar = snapshot.data['avatar'],
    this.available = snapshot.data['available'],
    this.category = snapshot.data['category'];

  Helper.fromJson(Map<String, dynamic> json, String helperid) :
    this.id = helperid,
    this.name = json['name'],
    this.nationality = json['nationality'],
    this.experience = json['experience'],
    this.tripid = json['tripid'],
    this.avatar = json['avatar'],
    this.available = json['available'],
    this.category = json['category'];

  Map<String, dynamic> toJson() => {
    "name": this.name,
    "nationality": this.nationality,
    "experience": this.experience,
    "tripid": this.tripid,
    "avatar": this.avatar,
    "available": this.available,
    "category": this.category
  };

}