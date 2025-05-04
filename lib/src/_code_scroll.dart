part of 're_editor.dart';

const double _kScrollbarThickness = 8;

class _CodeScrollable extends StatelessWidget {
  const _CodeScrollable({
    required this.axisDirection,
    required this.viewportBuilder,
    this.controller,
    this.scrollbarBuilder,
  });
  final AxisDirection axisDirection;
  final ScrollController? controller;
  final ViewportBuilder viewportBuilder;
  final CodeScrollbarBuilder? scrollbarBuilder;

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      excludeFromSemantics: true,
      controller: controller,
      scrollBehavior: _ScrollBehavior(scrollbarBuilder),
      viewportBuilder: viewportBuilder,
      axisDirection: axisDirection,
      physics: const ClampingScrollPhysics(),
    );
  }
}

class _ScrollBehavior extends MaterialScrollBehavior {
  _ScrollBehavior(this.scrollbarBuilder) : physics = _ScrollPhysics();
  final _ScrollPhysics physics;
  final CodeScrollbarBuilder? scrollbarBuilder;

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final Widget? scrollbar = scrollbarBuilder?.call(context, child, details);
    if (scrollbar != null) {
      return scrollbar;
    }
    final ScrollbarOrientation? orientation;
    if (details.direction == AxisDirection.down) {
      orientation = ScrollbarOrientation.right;
    } else if (details.direction == AxisDirection.right) {
      orientation = ScrollbarOrientation.bottom;
    } else {
      orientation = null;
    }
    if (kIsAndroid || kIsIOS) {
      return Scrollbar(
        controller: details.controller,
        scrollbarOrientation: orientation,
        thumbVisibility: details.direction == AxisDirection.down,
        child: child,
      );
    }

    return _RawScrollbar(
      physics: physics,
      controller: details.controller ?? ScrollController(),
      scrollbarOrientation: orientation,
      thumbVisibility: details.direction == AxisDirection.down,
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return physics;
  }
}

class _RawScrollbar extends RawScrollbar {
  const _RawScrollbar({
    required this.physics,
    required super.child,
    required ScrollController super.controller,
    required bool super.thumbVisibility,
    super.scrollbarOrientation,
  }) : super(
         thickness: _kScrollbarThickness,
         radius: const Radius.circular(10),
         crossAxisMargin: 2,
       );
  final _ScrollPhysics physics;

  @override
  RawScrollbarState<_RawScrollbar> createState() => _RawScrollbarState();
}

class _RawScrollbarState extends RawScrollbarState<_RawScrollbar> {
  Offset? downPosition;
  double? downOffset;

  @override
  void handleThumbPressStart(ui.Offset localPosition) {
    downPosition = localPosition;
    downOffset = widget.controller!.offset;
    super.handleThumbPressStart(localPosition);
  }

  @override
  void handleThumbPressUpdate(Offset localPosition) {
    if (getScrollbarDirection() == Axis.vertical) {
      widget.physics.setScrollPosition(
        downOffset! +
            scrollbarPainter.getTrackToScroll(
              localPosition.dy - downPosition!.dy,
            ),
      );
    }
    super.handleThumbPressUpdate(localPosition);
  }
}

// ignore: must-be-immutable
class _ScrollPhysics extends ScrollPhysics {
  double? _position;

  void setScrollPosition(double position) {
    _position = position;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (_position == null) {
      return super.applyBoundaryConditions(position, value);
    }

    return value - _position!;
  }
}
