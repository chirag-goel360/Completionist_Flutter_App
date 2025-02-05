import 'package:flutter/material.dart';
import 'package:game_trophy_manager/Utilities/colors.dart';
import 'package:share/share.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const BaseAppBar({Key key, this.appBar, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: secondaryColor,
      elevation: 1,
      actions: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {
            Share.share(
                'Completionist: PS4 & Xbox game guide\n Download for FREE and start gaming \nhttps://play.google.com/store/apps/details?id=co.turingcreatives.game_trophy_manager',
                subject: 'Completionist: PS4 & Xbox game guide');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
