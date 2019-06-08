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
  tip_dialog: ^2.0.0
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
/// 自动消失的时间
this.duration: const Duration(seconds: 3),
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
        child: new MaterialApp(
          title: 'TipDialog Demo',
          theme: new ThemeData(),
          home: new MyHomePage(title: 'TipDialog Demo Home Page'),
        ));
  }
}

/// 使用 [TipDialogConnector] 获取 [TipDialogController]
new TipDialogConnector(
  builder: (context, tipController) {
    return new ListView(children: <Widget>[
      _buildItem("Loading Type Tip Dialog", () async {
        tipController.show(
           tipDialog: new TipDialog(type: TipDialogType.LOADING, tip: "Loading"),
           isAutoDismiss: false);
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
///
/// isAutoDismiss: 这个变量决定了显示出来的提示框是否会自动消失,默认为 true
/// 这个值为false的时候,显示出来的提示框不会自动消失,除非调用dismiss方法
/// 如果这个值是true,那么提示框会在一定时间内消失,这个值是在新建[TipDialogContainer]的时候设置的.
void show({@required Widget tipDialog, bool isAutoDismiss: true});

/// 隐藏提示框
void dismiss();
```

>更多细节请参考示例中的代码.

## 7. 版本记录

## [2.0.1]

* 修复dismiss逻辑Bug
* 升级 android build gradle 到 5.1.1

### [2.0.0] 

* 设置默认自动消失时间为2s
* 删除 [TipDialogContainer] 部分参数
    -- show
    -- outSideTouchable
    -- defaultTip
    -- defaultType
* 改变show方法的isLoading为isAutoDismiss
* 强制显示遮罩层

### [1.1.2] - (MODIFY)

* 修复无限调用 dismiss 方法的 bug
* 修复 isLoading 无效的问题

### [1.1.1] - (MODIFY)

* 修复全局使用时出现的错误

### [1.1.0] - (FUNCTION CHANGE)

* 添加全局支持

### [1.0.1] - (MODIFY).

* 修复 loading view 的版本 bug
* 设置默认loading时间

### [1.0.0] - first release.

* 释放版本
