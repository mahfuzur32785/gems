import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/util/colors.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final IconData leadingIcon;
  final String title;
  // final String form;
  final Color bgColor;
  final Color fontColor;
  final Widget actionWidget;
  final VoidCallback? backFunc;

  const CustomAppbar({
    Key? key,
    this.leadingIcon = Icons.arrow_back_ios,
    this.title = "",
    this.backFunc,
    // this.form = "",
    this.bgColor = MyColors.primaryColor,
    this.fontColor = MyColors.secondaryTextColor,
    this.actionWidget = const SizedBox(
      width: 30,
    ),
  }) : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -9,
      elevation: 0,
      backgroundColor: MyColors.secondaryColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: widget.backFunc ??
            () {
              Navigator.pop(context);
            },
        //     () {
        //   Get.back();
        // },
      ),
      title: Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: widget.fontColor,
          fontSize: 17.sp
        ),
      ),
      centerTitle: true,
      actions: [widget.actionWidget],
    );
  }
}
