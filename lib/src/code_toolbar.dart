part of 're_editor.dart';

typedef ToolbarMenuBuilder =
    Widget Function({
      required BuildContext context,
      required TextSelectionToolbarAnchors anchors,
      required CodeLineEditingController controller,
      required VoidCallback onDismiss,
      required VoidCallback onRefresh,
    });

abstract class SelectionToolbarController {
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
    Rect? renderRect,
  });

  void hide(BuildContext context);
}

abstract class MobileSelectionToolbarController
    implements SelectionToolbarController {
  factory MobileSelectionToolbarController({
    required ToolbarMenuBuilder builder,
  }) => _MobileSelectionToolbarController(builder: builder);
}
