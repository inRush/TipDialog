library tip_dialog;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_view/loading_view.dart';

enum TipDialogType { NOTHING, LOADING, SUCCESS, FAIL, INFO }

class TipDialogIcon extends StatelessWidget {
  TipDialogIcon(this.type, {this.color: Colors.white});

  final TipDialogType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TipDialogType.SUCCESS:
        return new ImageIcon(
          AssetImage("packages/tip_dialog/images/icon_notify_done.png"),
          size: 35.0,
          color: color,
        );
      case TipDialogType.FAIL:
        return new ImageIcon(
          AssetImage("packages/tip_dialog/images/icon_notify_error.png"),
          size: 35.0,
          color: color,
        );
      case TipDialogType.INFO:
        return new ImageIcon(
          AssetImage("packages/tip_dialog/images/icon_notify_info.png"),
          size: 35.0,
          color: color,
        );
      case TipDialogType.LOADING:
        return new LoadingView(
          35.0,
          color: color,
        );
      default:
        throw new Exception(
            "this type $type is not in TipDialogType: NOTHING, LOADING, SUCCESS, FAIL, INFO");
    }
  }
}

class TipDialog extends StatelessWidget {
  TipDialog({Key key, TipDialogType type: TipDialogType.NOTHING, this.tip})
      : assert(type != null),
        icon = type == TipDialogType.NOTHING ? null : new TipDialogIcon(type),
        bodyBuilder = null,
        color = const Color(0xbb000000),
        super(key: key);

  TipDialog.customIcon({Key key, this.icon, this.tip})
      : assert(icon != null || tip != null),
        bodyBuilder = null,
        color = const Color(0xbb000000),
        super(key: key);

  TipDialog.builder(
      {Key key, this.bodyBuilder, this.color: const Color(0xbb000000)})
      : assert(bodyBuilder != null),
        tip = null,
        icon = null,
        super(key: key);

  final String tip;
  final Widget icon;
  final WidgetBuilder bodyBuilder;
  final Color color;

  Widget _buildBody() {
    List<Widget> childs = [];
    if (icon != null) {
      childs.add(new Padding(
        padding: tip == null
            ? const EdgeInsets.all(20.0)
            : const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child: icon,
      ));
    }
    if (tip != null) {
      childs.add(new Padding(
        padding: icon == null
            ? const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0)
            : const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
        child: new Text(
          tip,
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.white, fontSize: 15.0),
          textDirection: TextDirection.ltr,
        ),
      ));
    }
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: childs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(15.0),
      child: new Container(
        constraints: icon == null || tip == null
            ? new BoxConstraints(minHeight: 50.0, minWidth: 100.0)
            : new BoxConstraints(minHeight: 90.0, minWidth: 120.0),
        color: color,
        child: bodyBuilder == null ? _buildBody() : bodyBuilder(context),
      ),
    );
  }
}

class TipDialogContainer extends StatefulWidget {
  TipDialogContainer(
      {Key key,
      @required this.child,
      this.duration: const Duration(seconds: 2),
      this.maskAlpha: 0.3})
      : super(key: key);

  final Widget child;
  final Duration duration;
  final double maskAlpha;

  @override
  State<StatefulWidget> createState() {
    return new TipDialogContainerState();
  }
}

class TipDialogContainerState extends State<TipDialogContainer>
    with TickerProviderStateMixin {
  Timer _timer;
  bool _show;
  AnimationController _animationController;
  Animation _scaleAnimation;
  VoidCallback _animationListener;
  bool _prepareDismiss = false;
  Widget _tipDialog;

  /// if true, the dialog will not automatically disappear
  /// otherwise, the dialog will automatically disappear after the [Duration] set by [TipDialogContainer]
  bool _isAutoDismiss;

  bool get isShow => _show;

  void dismiss() {
    setState(() {
      if (_animationController.isAnimating) {
        _show = false;
        _animationController.stop(canceled: true);
      } else {
        _prepareDismiss = true;
        _animationController.reverse();
      }
    });
  }

  /// tipDialog: Need to display the widget
  /// (default uses the dialog set by [TipDialogContainer])
  ///
  /// isLoading: decide whether to disappear automatically
  /// (default uses the value set by [TipDialogContainer],
  /// set type = TipDialogType.LOADING, the value will be true, otherwise will be false.)
  void show({@required Widget tipDialog, bool isAutoDismiss: true}) {
    assert(tipDialog != null);
    _tipDialog = tipDialog;
    // when tip dialog equal null, isLoading must inherit the origin value
    _isAutoDismiss = isAutoDismiss;
    setState(() {
      _start();
      _show = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _show = false;
    _animationController = new AnimationController(
        value: 0.0, duration: new Duration(milliseconds: 200), vsync: this);
    _animationListener = () {
      if (_animationController.value == 0.0 && _prepareDismiss) {
        setState(() {
          _show = false;
          _prepareDismiss = false;
        });
      }
    };
    _animationController.addListener(_animationListener);
    _scaleAnimation =
        new Tween(begin: 0.95, end: 1.0).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_show) {
      _start();
    }
  }

  void _start() {
    _animationController.forward(from: 0.0);
    if (_isAutoDismiss) {
      if (_timer != null) {
        _timer.cancel();
        if (_show) {
          dismiss();
        }
        _timer = null;
      }
      _timer = new Timer(widget.duration, () {
        dismiss();
        _timer = null;
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      if (_show) {
        dismiss();
      }
    }
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildMaskLayer() {
    return new LayoutBuilder(builder: (context, size) {
      return new FadeTransition(
        opacity: _animationController,
        child: new Container(
          width: size.maxWidth,
          height: size.maxHeight,
          color: Colors.black.withAlpha(widget.maskAlpha * 255 ~/ 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [widget.child];
    if (_show) {
      widgets.add(_buildMaskLayer());
      widgets.add(new ScaleTransition(
        scale: _scaleAnimation,
        child: new FadeTransition(
          opacity: _animationController,
          child: _tipDialog,
        ),
      ));
    }

    return new _TipDialogProvider(
        controller: new TipDialogController(
            showCallback: show, dismissCallback: dismiss),
        child: new Stack(
          alignment: Alignment.center,
          children: widgets,
        ));
  }
}

typedef void ShowTipDialogCallback(
    {@required Widget tipDialog, bool isAutoDismiss});
typedef void DismissTipDialogCallback();

class TipDialogController {
  final ShowTipDialogCallback showCallback;
  final DismissTipDialogCallback dismissCallback;

  TipDialogController(
      {Key key,
      ShowTipDialogCallback showCallback,
      DismissTipDialogCallback dismissCallback})
      : showCallback = showCallback,
        dismissCallback = dismissCallback;

  show({@required Widget tipDialog, bool isAutoDismiss: true}) {
    showCallback(tipDialog: tipDialog, isAutoDismiss: isAutoDismiss);
  }

  dismiss() {
    dismissCallback();
  }
}

class _TipDialogProvider extends InheritedWidget {
  final TipDialogController controller;

  _TipDialogProvider(
      {Key key, @required this.controller, @required Widget child})
      : assert(controller != null),
        assert(child != null),
        super(key: key, child: child);

  static TipDialogController of(BuildContext context) {
    final _TipDialogProvider scope =
        context.inheritFromWidgetOfExactType(_TipDialogProvider);
    return scope?.controller;
  }

  @override
  bool updateShouldNotify(_TipDialogProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}

typedef Widget TipDialogBuilder(
    BuildContext context, TipDialogController controller);

@deprecated
class TipDialogConnector extends StatelessWidget {
  final TipDialogBuilder builder;

  TipDialogConnector({this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, _TipDialogProvider.of(context));
  }
}

class TipDialogHelper {
  static TipDialogController _controller;


  static void _checkController(BuildContext context) {
    if (_controller == null) {
      _controller = _TipDialogProvider.of(context);
    }
    if (_controller == null) {
      throw Exception(
          "[TipDialogController] is not found in this widget tree, please set TipDialogContainer on this widget tree top");
    }
  }

  static void show(BuildContext context,
      {@required Widget tipDialog, bool isAutoDismiss: true}) {
    _checkController(context);
    _controller.show(tipDialog: tipDialog, isAutoDismiss: isAutoDismiss);
  }

  static void dismiss(BuildContext context) {
    _checkController(context);
    _controller.dismiss();
  }

  static void info(BuildContext context, String tip) {
    show(context, tipDialog: TipDialog(type: TipDialogType.INFO, tip: tip));
  }

  static void fail(BuildContext context, String errMsg) {
    show(context, tipDialog: TipDialog(type: TipDialogType.FAIL, tip: errMsg));
  }

  static void success(BuildContext context, String success) {
    show(context,
        tipDialog: TipDialog(type: TipDialogType.SUCCESS, tip: success));
  }

  static void loading(BuildContext context, String loadingTip) {
    show(context,
        tipDialog: TipDialog(type: TipDialogType.LOADING, tip: loadingTip),
        isAutoDismiss: false);
  }
}
