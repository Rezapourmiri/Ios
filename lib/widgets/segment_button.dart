import 'package:flutter/material.dart';
import 'package:optima_soft/helpers/colors.dart';
import 'package:optima_soft/helpers/platform_helper.dart';

class SegmentButton extends StatefulWidget {
  final String title;
  final bool isSelected;

  const SegmentButton(this.title, {Key? key, this.isSelected = false})
      : super(key: key);

  @override
  _SegmentButtonState createState() => _SegmentButtonState();
}

class _SegmentButtonState extends State<SegmentButton> {
  bool? _isSelected;

  bool get isButtonSelected => _isSelected ?? widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButtonSelection,
      child: Padding(
        padding: EdgeInsets.only(right: PlatformHelper.screenWidth * 0.006),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: isButtonSelected ? BornaBackGroundColor : Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          height: PlatformHelper.screenWidth * 0.045,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: PlatformHelper.screenWidth * 0.015),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleButtonSelection() {
    setState(() {
      _isSelected = !isButtonSelected;
    });
  }
}
