import 'package:optima_soft/models/on_call_form_model.dart';

class OnCallFormBloc {
  final Function(OnCallFormModel onCallFormModel) onFormSubmitted;

  OnCallFormBloc(this.onFormSubmitted);

  void submitButtonPressed() {}
}
