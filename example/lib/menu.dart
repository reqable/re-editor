import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class ContextMenuItemWidget extends PopupMenuItem<void> implements PreferredSizeWidget {

  ContextMenuItemWidget({
    super.key,
    required String text,
    required VoidCallback onTap,
  }) : super(
    onTap: onTap,
    child: Text(text)
  );

  @override
  Size get preferredSize => const Size(150, 25);

}

class ContextMenuControllerImpl implements SelectionToolbarController {

  const ContextMenuControllerImpl();

  @override
  void hide(BuildContext context) {
  }

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    showMenu(
      context: context,
      position: RelativeRect.fromSize(anchors.primaryAnchor & const Size(150, double.infinity),
        MediaQuery.of(context).size),
      items: [
        ContextMenuItemWidget(
          text: 'Cut',
          onTap: () {
            controller.cut();
          },
        ),
        ContextMenuItemWidget(
          text: 'Copy',
          onTap: () {
            controller.copy();
          },
        ),
        ContextMenuItemWidget(
          text: 'Paste',
          onTap: () {
            controller.paste();
          },
        ),
      ]
    );
  }

}