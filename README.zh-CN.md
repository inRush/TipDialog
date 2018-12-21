# TipDialog

Flutter 提示框

| 加载提示框 | 成功提示框 | 失败提示框 |
| --- | --- | --- |
|  ![WechatIMG9](http://qiniu.inrush.cn/2018-08-17-WechatIMG9.jpeg) | ![WechatIMG8](http://qiniu.inrush.cn/2018-08-17-WechatIMG8.jpeg)| ![WechatIMG6](http://qiniu.inrush.cn/2018-08-17-WechatIMG6.jpeg) |


| 信息提示框 | 只有图标的提示框 | 只有文本的提示框  |
| --- | --- | --- |
| ![WechatIMG7](http://qiniu.inrush.cn/2018-08-17-WechatIMG7.jpeg)| ![WechatIMG5](http://qiniu.inrush.cn/2018-08-17-WechatIMG5.jpeg)| ![WechatIMG4](http://qiniu.inrush.cn/2018-08-17-WechatIMG4.jpeg)|


| 自定义图标提示框 | 自定义提示框 |
| --- | --- |
| ![WechatIMG3](http://qiniu.inrush.cn/2018-08-17-WechatIMG3.jpeg)| ![WechatIMG2](http://qiniu.inrush.cn/2018-08-17-WechatIMG2.jpeg)|



## 1. 依赖
添加下面的内容到 pubspec.yaml 文件中:

``` dart
dependencies:
  tip_dialog: ^1.1.2
```

## 2. 安装
在命令行中使用以下的Flutter命令获取依赖包
```
$ flutter packages get
```

## 3. 导入

```dart
import 'package:loading_view/loading_view.dart';
```
## 4. 使用
#### 可用的属性

```dart
[ TipDialogContainer ]
@required this.child,
String defaultTip,
TipDialogType defaultType: TipDialogType.NOTHING,
/// 自动消失的时间
this.duration: const Duration(seconds: 3),
/// 在一开始创建的时候,是否立刻显示出来
this.show: false,
/// 是否能点击提示框外部
this.outSideTouchable: false,
/// 遮罩层不透明度
this.maskAlpha: 0.3
```

#### 全局使用
``` dart
/// 全局使用 [TipDialogContainer]
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  /// 将该控件放到你应用的根节点上
  @override
  Widget build(BuildContext context) {
    return new TipDialogContainer(
        defaultType: TipDialogType.LOADING,
        defaultTip: "Loading",
        child: new MaterialApp(
          title: 'TipDialog Demo',
          theme: new ThemeData(),
          home: new MyHomePage(title: 'TipDialog Demo Home Page'),
        ));
  }
}

/// 使用 [TipDialogConnector] 获取 [TipDialogController]
/// 除了能用Controller控制以外,你还可以使用 [GlobalKey] 去控制显示和消失
/// In addition to using controller, you can also use [GlobalKey] to control show or dismiss
new TipDialogConnector(
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
)
```
>在全局使用自定义控件的使用,可能会出现一些错误
>比如使用Text或者Icon的时候,会出现下面的错误.

***No Directionality widget found.***

>这个错误只要在Text或者Icon上设置TextDirection的属性就可以了,具体的细节请到示例中查看.

## 5. 默认可用提示框类型
```
enum TipDialogType { NOTHING, LOADING, SUCCESS, FAIL, INFO }

NONTHING: no icon
LOADING: have a loading icon
SUCCESS: have a success icon
FAIL: have a fail icon
INFO: have a info icon
```
## 6. State 和 TipDialogController 中的方法

```dart
/// tipDialog: 需要进行显示的提示框
/// 默认显示的提示框是通过[TipDialogContainer]来进行设置的
///
/// isLoading: 这个变量决定了显示出来的提示框是否会自动消失,其默认值是在[TipDialogContainer]中设置的
/// 当提示框的type是TipDialogType.LOADING的时候,isLoading的值会自动设置成true,否则其他情况默认设置为false
/// 这个值为true的时候,显示出来的提示框不会自动消失,除非调用dismiss方法
/// 如果这个值是false,那么提示框会在一定时间内消失,这个值是在新建[TipDialogContainer]的时候设置的.
void show({Widget tipDialog, bool isLoading: false});

/// 隐藏提示框
void dismiss();
```

>更多细节请参考示例中的代码.
