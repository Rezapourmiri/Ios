import 'package:flutter/material.dart';
import 'package:optima_soft/helpers/platform_helper.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTapCallBack;
  const SubmitButton(this.title, this.onTapCallBack, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: onTapCallBack,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: PlatformHelper.screenHeight * 0.01),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            width: PlatformHelper.screenWidth * 0.1,
            height: PlatformHelper.screenWidth * 0.045,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: PlatformHelper.screenWidth * 0.015),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
