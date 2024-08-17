import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optima_soft/helpers/platform_helper.dart';
import 'package:optima_soft/modules/on_call_form_screen/on_call_form_bloc.dart';
import 'package:optima_soft/widgets/segment_button.dart';
import 'package:optima_soft/widgets/submit_button.dart';

///
/// On call doctor form to be submitted as patient data.
/// The result should be sent back to pwa.
///
class OnCallFormScreen extends StatefulWidget {
  const OnCallFormScreen({Key? key}) : super(key: key);

  @override
  _OnCallFormScreenState createState() => _OnCallFormScreenState();
}

class _OnCallFormScreenState extends State<OnCallFormScreen> {
  TextStyle get defaultTextStyle => const TextStyle(fontSize: 17);

  late OnCallFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.symmetric(horizontal: PlatformHelper.screenWidth * 0.02),
      width: PlatformHelper.screenWidth * 0.5,
      child: ListView(children: [
        header(),
        Text("Is the patient the right candidate for the procedure?",
            style: defaultTextStyle),
        rightCandidate(),
        const Divider(),
        procedure(),
        searchBox(),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: PlatformHelper.screenHeight * 0.02),
          child: Text("Add preparations", style: defaultTextStyle),
        ),
        labWork(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: PlatformHelper.screenHeight * 0.02),
          child: pictures(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: PlatformHelper.screenHeight * 0.02),
          child: Text("Note for the patient", style: defaultTextStyle),
        ),
        noteBox(),
        SubmitButton("Submit", _bloc.submitButtonPressed),
      ]),
    );
  }

  Widget labWork() {
    return Row(
      children: [
        Text("Lab Work", style: defaultTextStyle),
        Container(
          width: PlatformHelper.screenWidth * 0.01,
        ),
        Expanded(
          child: Row(
            children: const [
              SegmentButton("CDC Panels"),
              SegmentButton("Vitamines"),
              SegmentButton("Lab Work"),
            ],
          ),
        )
      ],
    );
  }

  Widget pictures() {
    return Row(
      children: [
        Text("Pictures", style: defaultTextStyle),
        Container(
          width: PlatformHelper.screenWidth * 0.018,
        ),
        Expanded(
          child: Row(
            children: const [
              SegmentButton("Front"),
              SegmentButton("Left"),
              SegmentButton("Right"),
              SegmentButton("Top"),
            ],
          ),
        )
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: EdgeInsets.only(
          top: PlatformHelper.screenHeight * 0.05,
          bottom: PlatformHelper.screenHeight * 0.03),
      child: const Text(
        "Virtual Consult Questionnaire",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget rightCandidate() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: PlatformHelper.screenHeight * 0.01),
      child: Row(
        children: const [
          SegmentButton("Yes"),
          SegmentButton("No"),
        ],
      ),
    );
  }

  Widget procedure() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: PlatformHelper.screenHeight * 0.02),
      child: Text("What is the procedure?", style: defaultTextStyle),
    );
  }

  Widget searchBox() {
    return Row(
      children: [
        Container(
          height: PlatformHelper.screenHeight * 0.05,
          width: PlatformHelper.screenWidth * 0.3,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: PlatformHelper.screenWidth * 0.006),
                child: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
              ),
              const Text(
                "Search Procedure",
                style: TextStyle(color: Colors.black54),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget noteBox() {
    return Container(
      height: PlatformHelper.screenHeight * 0.15,
      width: PlatformHelper.screenWidth * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
