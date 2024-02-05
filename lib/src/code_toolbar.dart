part of re_editor;

class ToolbarMenuItem {

  const ToolbarMenuItem({
    required this.title,
    required this.onTap,
    this.refreshToolbarAfterTap = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool refreshToolbarAfterTap;

}

typedef ToolbarMenuBuilder = List<ToolbarMenuItem> Function(BuildContext context, CodeLineEditingController controller);

abstract class SelectionToolbarController {

  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  });

  void hide(BuildContext context);

}

abstract class MobileSelectionToolbarController implements SelectionToolbarController {

  factory MobileSelectionToolbarController({
    required ToolbarMenuBuilder builder
  }) => _MobileSelectionToolbarController(
    builder: builder
  );

}