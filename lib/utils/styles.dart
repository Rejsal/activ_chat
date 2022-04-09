import 'package:flutter/material.dart';

const Color kPrimary = Color(0xff171717);

const TextStyle kAppTitleStyle = TextStyle(
    fontFamily: 'Muli',
    fontSize: 36,
    color: Colors.white,
    fontWeight: FontWeight.w700);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
  hintStyle: TextStyle(color: Colors.white54),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white60, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.white70),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
