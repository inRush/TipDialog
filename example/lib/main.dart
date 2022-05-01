import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tip_dialog/tip_dialog.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TipDialog Demo',
      theme: new ThemeData(),
      home: Stack(
        children: <Widget>[
          MyHomePage('TipDialog Demo Home Page'),
          TipDialogContainer(
              duration: const Duration(seconds: 2),
              outsideTouchable: true,
              onOutsideTouch: (Widget tipDialog) {
                if (tipDialog is TipDialog &&
                    tipDialog.type == TipDialogType.LOADING) {
                  TipDialogHelper.dismiss();
                }
              })
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title,{Key? key}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        body: new ListView(children: <Widget>[
          _buildItem("Loading Type Tip Dialog", () async {
            TipDialogHelper.loading("Loading");
            await new Future.delayed(new Duration(seconds: 5));
            TipDialogHelper.dismiss();
          }),
          new Divider(),
          _buildItem("Success Type Tip Dialog", () async {
            TipDialogHelper.success("Loaded Successfully");
          }),
          new Divider(),
          _buildItem("Fail Type Tip Dialog", () async {
            TipDialogHelper.fail("Load Failed");
          }),
          new Divider(),
          _buildItem("Info Type Tip Dialog", () async {
            TipDialogHelper.info("Do Not Repeat");
          }),
          new Divider(),
          _buildItem("Only Icon Tip Dialog", () async {
            TipDialogHelper.show(new TipDialog(
              type: TipDialogType.SUCCESS,
            ));
          }),
          new Divider(),
          _buildItem("Only text Tip Dialog", () async {
            TipDialogHelper.show(new TipDialog(
              type: TipDialogType.NOTHING,
              tip: "Do Not Repeat",
            ));
          }),
          new Divider(),
          _buildItem("Custom Icon Tip Dialog", () async {
            TipDialogHelper.show(new TipDialog.customIcon(
              icon: new Icon(
                Icons.file_download,
                color: Colors.white,
                size: 30.0,
                textDirection: TextDirection.ltr,
              ),
              tip: "Download",
            ));
          }),
          new Divider(),
          _buildItem("Custom Body Tip Dialog", () async {
            TipDialogHelper.show(new TipDialog.builder(
              bodyBuilder: (context) {
                return new Container(
                  width: 120.0,
                  height: 90.0,
                  alignment: Alignment.center,
                  child: new Text(
                    "Custom",
                    style: new TextStyle(color: Colors.white),

                    /// if TipDialogContainer are outside of MaterialApp,
                    /// here is a must to set
                    textDirection: TextDirection.ltr,
                  ),
                );
              },
              color: Colors.blue.withAlpha(150),
            ));
          }),
          new Divider(),
        ]));
  }
}
