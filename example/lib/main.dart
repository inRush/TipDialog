import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tip_dialog/tip_dialog.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<TipDialogContainerState> _tipDialogKey = new GlobalKey();

  Widget _buildItem(String name, VoidCallback callback) {
    return new GestureDetector(
      onTap: callback,
      child: new ListTile(
        title: new Text(name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        elevation: 0.5,
      ),
      body: new TipDialogContainer(
        key: _tipDialogKey,
        type: TipDialogType.LOADING,
        tip: "Loading",
        child: new ListView(children: <Widget>[
          _buildItem("Loading Type Tip Dialog", () async {
            _tipDialogKey.currentState.show();
            await new Future.delayed(new Duration(seconds: 3));
            _tipDialogKey.currentState.dismiss();
          }),
          new Divider(),
          _buildItem("Success Type Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog(
              type: TipDialogType.SUCCESS,
              tip: "Loaded Successfully",
            ));
          }),
          new Divider(),
          _buildItem("Fail Type Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog(
              type: TipDialogType.FAIL,
              tip: "Load Failed ",
            ));
          }),
          new Divider(),
          _buildItem("Info Type Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog(
              type: TipDialogType.INFO,
              tip: "Do Not Repeat",
            ));
          }),
          new Divider(),
          _buildItem("Only Icon Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog(
              type: TipDialogType.SUCCESS,
            ));
          }),
          new Divider(),
          _buildItem("Only text Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog(
              type: TipDialogType.NOTHING,
              tip: "Do Not Repeat",
            ));
          }),
          new Divider(),
          _buildItem("Custom Icon Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog.customIcon(
              icon: new Icon(
                Icons.file_download,
                color: Colors.white,
                size: 30.0,
              ),
              tip: "Download",
            ));
          }),
          new Divider(),
          _buildItem("Custom Body Tip Dialog", () async {
            _tipDialogKey.currentState.show(
                tipDialog: new TipDialog.builder(
              bodyBuilder: (context) {
                return new Container(
                  width: 120.0,
                  height: 90.0,
                  alignment: Alignment.center,
                  child: new Text(
                    "Custom",
                    style: new TextStyle(color: Colors.white),
                  ),
                );
              },
              color: Colors.blue.withAlpha(150),
            ));
          }),
          new Divider(),
        ]),
      ),
    );
  }
}
