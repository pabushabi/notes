import 'package:flutter/material.dart';
import 'dart:convert';

class Note {
  int id;
  String title;
  String content;
  DateTime dateCreated;
  DateTime dateEdited;
  Color noteColor;
  int isArchived = 0;

  Note(this.id, this.title, this.content, this.dateCreated, this.dateEdited,
      this.noteColor);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode(content),
      'dateCreated': epochFromDate(dateCreated),
      'dateEdited': epochFromDate(dateEdited),
      'noteColor': noteColor.value,
      'isArchived': isArchived
    };
    if (forUpdate) {
      data['id'] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  void archiveNote() {
    isArchived = 1;
  }

  @override toString() {
    return {
      'id': id,
      'title': title,
      'content': content ,
      'dateCreated': epochFromDate( dateCreated ),
      'dateEdited': epochFromDate( dateEdited ),
      'noteColor': noteColor.toString(),
      'isArchived':isArchived
    }.toString();
  }

}