# TipDialog

A Flutter Tip Dialog

| Loading Type Dialog | Success Tye Dialog | Fail Type Dialog |
| --- | --- | --- |
|  ![WechatIMG9](http://qiniu.inrush.me/2018-08-17-WechatIMG9.jpeg) | ![WechatIMG8](http://qiniu.inrush.me/2018-08-17-WechatIMG8.jpeg)| ![WechatIMG6](http://qiniu.inrush.me/2018-08-17-WechatIMG6.jpeg) |


| Info Type Dialog | Only Icon Dialog | Onl Text Dialog  |
| --- | --- | --- |
| ![WechatIMG7](http://qiniu.inrush.me/2018-08-17-WechatIMG7.jpeg)| ![WechatIMG5](http://qiniu.inrush.me/2018-08-17-WechatIMG5.jpeg)| ![WechatIMG4](http://qiniu.inrush.me/2018-08-17-WechatIMG4.jpeg)|


| Custom Icon Dialog | Custom Body Dialog |
| --- | --- |
| ![WechatIMG3](http://qiniu.inrush.me/2018-08-17-WechatIMG3.jpeg)| ![WechatIMG2](http://qiniu.inrush.me/2018-08-17-WechatIMG2.jpeg)|




## Rendering

## 1. Depend on it
Add this to your package's pubspec.yaml file:

``` dart
dependencies:
  tip_dialog: ^1.0.0
```
## 2. Install it
You can install packages from the command line:
with Flutter:

```
$ flutter packages get
```
## 3. Import it
Now in your Dart code, you can use:

```dart
import 'package:loading_view/loading_view.dart';
```
## 4. Use
#### Available attributes

```dart
[ TipDialogContainer ]
@required this.child,
String defaultTip,
TipDialogType defaultType: TipDialogType.NOTHING,
/// automatically disappear time
this.duration: const Duration(seconds: 3),
/// In the beginning, whether to display 
this.show: false,
/// whether show mask layer
this.outSideTouchable: false,
/// mask layer alpha
this.maskAlpha: 0.3
```

``` dart
final GlobalKey<TipDialogContainerState> _tipDialogKey = new GlobalKey();
 
Widget _buildItem(String name, VoidCallback callback) {
    return new GestureDetector(
      onTap: callback,
      child: new ListTile(
        title: new Text(name),
      ),
    );
  }
)
/// This widget can be globally supported
/// Use [TipDialogConnector] to obtain [TipDialogController]
/// In addition to using controller, you can also use [GlobalKey] to control show or dismiss
new TipDialogContainer(
        key: _tipDialogKey,
        defaultType: TipDialogType.LOADING,
        defaultTip: "Loading",
        child:  new TipDialogConnector(
          builder: (context, tipController) {
            return new ListView(children: <Widget>[
              _buildItem("Loading Type Tip Dialog", () async {
                tipController.show();
                await new Future.delayed(new Duration(seconds: 3));
                tipController.dismiss();
              }),
              new Divider(),
              _buildItem("Success Type Tip Dialog", () async {
                tipController.show(
                  tipDialog: new TipDialog(
                  type: TipDialogType.SUCCESS,
                  tip: "Loaded Successfully",
                ));
              }),
            ]);
          },
        ),
      )
```
## 5. Default Dialog Type

```dart
enum TipDialogType { NOTHING, LOADING, SUCCESS, FAIL, INFO }

NONTHING: no icon
LOADING: have a loading icon
SUCCESS: have a success icon
FAIL: have a fail icon
INFO: have a info icon
```
## 6. State And TipDialogController Method

```dart
/// tipDialog: Need to display the widget
/// (default uses the dialog set by [TipDialogContainer])
///
/// isLoading: decide whether to disappear automatically
/// (default uses the value set by [TipDialogContainer],
/// set type = TipDialogType.LOADING, the value will be true, otherwise will be false.)
/// if true, the dialog will not automatically disappear
/// otherwise, the dialog will automatically disappear after the [Duration] set by [TipDialogContainer]
void show({Widget tipDialog, bool isLoading: false});

/// dismiss dialog
void dismiss();
```

> See the example directory for more details.
