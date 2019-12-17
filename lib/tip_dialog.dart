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
      {this.duration: const Duration(seconds: 2), this.maskAlpha: 0.3});

  final Duration duration;
  final double maskAlpha;

  @override
  State<StatefulWidget> createState() {
    TipDialogContainerState state = TipDialogContainerState();
    TipDialogHelper._init(state);
    return state;
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
    List<Widget> widgets = [];
    if (_show) {
      widgets.add(_buildMaskLayer());
      widgets.add(new ScaleTransition(
        scale: _scaleAnimation,
        child: new FadeTransition(
          opacity: _animationController,
          child: _tipDialog,
        ),
      ));
      return new Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: widgets,
        ),
      );
    }
    return SizedBox.shrink();
  }
}

class TipDialogHelper {
  static TipDialogContainerState _tipDialog;

  static _init(TipDialogContainerState state) {
    _tipDialog = state;
  }

  static void show({@required Widget tipDialog, bool isAutoDismiss: true}) {
    _tipDialog.show(tipDialog: tipDialog, isAutoDismiss: isAutoDismiss);
  }

  static void dismiss() {
    _tipDialog.dismiss();
  }

  static void info(String tip) {
    show(tipDialog: TipDialog(type: TipDialogType.INFO, tip: tip));
  }

  static void fail(String errMsg) {
    show(tipDialog: TipDialog(type: TipDialogType.FAIL, tip: errMsg));
  }

  static void success(String success) {
    show(tipDialog: TipDialog(type: TipDialogType.SUCCESS, tip: success));
  }

  static void loading(String loadingTip) {
    show(
        tipDialog: TipDialog(type: TipDialogType.LOADING, tip: loadingTip),
        isAutoDismiss: false);
  }
}
