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
      String tip,
      TipDialogType type: TipDialogType.NOTHING,
      this.duration: const Duration(seconds: 3),
      this.show: false,
      this.outSideTouchable: false,
      this.maskAlpha: 0.3})
      : tipDialog = new TipDialog(
          type: type,
          tip: tip,
        ),
        isLoading = type == TipDialogType.LOADING,
        super(key: key);

  final Widget child;
  final Widget tipDialog;
  final Duration duration;
  final bool isLoading;
  final bool show;
  final bool outSideTouchable;
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
  bool _isLoading;

  bool get isShow => _show;

  void dismiss() {
    setState(() {
      _prepareDismiss = true;
      _animationController.reverse();
    });
  }

  /// tipDialog: Need to display the widget
  /// (default uses the dialog set by [TipDialogContainer])
  ///
  /// isLoading: decide whether to disappear automatically
  /// (default uses the value set by [TipDialogContainer],
  /// set type = TipDialogType.LOADING, the value will be true, otherwise will be false.)
  void show({Widget tipDialog, bool isLoading: false}) {
    _tipDialog = tipDialog ?? widget.tipDialog;
    _isLoading = isLoading ?? widget.isLoading;
    setState(() {
      _start();
      _show = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _show = widget.show;
    _animationController = new AnimationController(
        value: 0.0, duration: new Duration(milliseconds: 100), vsync: this);
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
    if (!_isLoading) {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      _timer = new Timer.periodic(widget.duration, (timer) {
        dismiss();
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
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
      if (!widget.outSideTouchable) {
        widgets.add(_buildMaskLayer());
      }
      widgets.add(new ScaleTransition(
        scale: _scaleAnimation,
        child: new FadeTransition(
          opacity: _animationController,
          child: _tipDialog,
        ),
      ));
    }
    return new Stack(
      alignment: Alignment.center,
      children: widgets,
    );
  }
}
