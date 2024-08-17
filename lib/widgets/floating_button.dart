import 'package:flutter/material.dart';
import 'package:optima_soft/helpers/platform_helper.dart';

enum FloatingButtonShape { circular, rounded }

class FloatingButton extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback onTap;
  final Color? color;
  final Color? iconColor;
  final bool isShadowEnabled;
  final FloatingButtonShape buttonShape;

  const FloatingButton(this.iconData, this.onTap,
      {this.buttonShape = FloatingButtonShape.rounded,
      this.color,
      this.iconColor,
      this.isShadowEnabled = true,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadow = isShadowEnabled
        ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              offset: const Offset(4, 4),
            )
          ]
        : [];

    BoxDecoration decoration = buttonShape == FloatingButtonShape.circular
        ? BoxDecoration(
            color: color ?? Theme.of(context).backgroundColor,
            shape: BoxShape.circle,
            boxShadow: shadow)
        : BoxDecoration(
            color: color ?? Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: shadow);

    double boxSize = PlatformHelper.screenWidth * 0.11;
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: decoration,
      child: GestureDetector(
          onTap: onTap,
          child: Icon(
            iconData,
            size: boxSize * 0.7,
            color: iconColor ?? Theme.of(context).primaryColor,
          )),
    );
  }
}
