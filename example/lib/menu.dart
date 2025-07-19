import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class ContextMenuItemWidget extends PopupMenuItem<void> implements PreferredSizeWidget {

  ContextMenuItemWidget({
    Key? key,
    required String text,
    required VoidCallback onTap,
  }) : super(
    key: key,
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
    if(controller.contextMenuDelegate != null && !kIsAndroid && !kIsIOS){
      controller.menuController.open(position: anchors.secondaryAnchor);
      return;
    }
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

class ContextMenuDelegateImpl implements ContextMenuDelegate{
  @override
  List<Widget> buildMenuItems({required CodeLineEditingController controller, required BuildContext context}) {
    return [
      Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(children: [

        _buildRightMenuItem(context:context, text: 'Cut', onPressed: () {controller.cut();}),
        _buildRightMenuItem(context:context, text: 'Copy', onPressed: () {controller.copy();}),
        _buildRightMenuItem(context:context, text: 'Paste', onPressed: (){ controller.paste();}),
        _buildSubMenu(context: context, text: 'Sub Menu',onPressed: (){}, menuChildren: [_buildRightMenuItem(context:context, text: 'Select All', onPressed: (){ controller.selectAll();})])

      ],),
    )
    ];
  }

  Widget _buildRightMenuItem({
    required BuildContext context,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }){
    final Color textColor = Theme.of(context).brightness == Brightness.light ? const Color.fromRGBO(0, 0, 0, 0.85) : const Color.fromRGBO(255, 255, 255, 0.85);
    return MenuItemButton(
      style: enabled ? null : Theme.of(context).menuButtonTheme.style?.copyWith(foregroundColor: WidgetStatePropertyAll(textColor.withOpacity(0.5))),
      onPressed: enabled ? onPressed : null,
      child: SizedBox(
        height: 24,
        // width: 160,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            strutStyle: const StrutStyle(
              fontSize: 11,
              leading: 0,
              height: 1.1,
              // 1.1更居中
              forceStrutHeight: true, // 关键属性 强制改为文字高度
            ),
            overflow: TextOverflow.ellipsis,
          ),),
      ),
    );
  }

  Widget _buildSubMenu({
    required BuildContext context,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    required List<Widget> menuChildren,
  }) {
    return SubmenuButton(
      style: Theme.of(context).menuButtonTheme.style?.copyWith(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.only(left: 0.0, right: 10.0),
          )),
      menuChildren: enabled ? menuChildren : [],
      child: Text(text),
    );
  }

}