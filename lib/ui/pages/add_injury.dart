import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:medapp/ui/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../helper/inputConstants.dart';
import '../navigation/main_navigation.dart';
import '../widgets/CustomAppBar.dart';
enum _ViewModelAddButtonState { canSubmit, addProcess, disable }

class _ViewModelState {
  String addErrorTitle = '';

  String type = "";
  String location = "";
  String severity = "";
  DateTime dateTimeOfInjury = DateTime.now();
  String cause = "";
  List<String> additionalSymptoms = [];
  bool isAddInProcess = false;

  String dateFormat ="yyyy-mm-dd";
  TextEditingController dataController = TextEditingController();

  _ViewModelAddButtonState get addButtonState {
    if (isAddInProcess) {
      return _ViewModelAddButtonState.addProcess;
    } else if (type.isNotEmpty) {
      return _ViewModelAddButtonState.canSubmit;
    } else {
      return _ViewModelAddButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final ObjectId id;
  final _regService = RegService();

  final _state = _ViewModelState();

  _ViewModel(this.id);
  _ViewModelState get state => _state;


  void changeType(String value) {
    if (_state.type == value) return;
    _state.type = value;
    notifyListeners();
  }

  void changeLocation(String value) {
    if (_state.location == value) return;
    _state.location = value;
    notifyListeners();
  }

  void changeSeverity(String value) {
    if (_state.severity == value) return;
    _state.severity = value;
    notifyListeners();
  }


  void changeCause(String value) {
    if (_state.cause == value) return;
    _state.cause = value;
    notifyListeners();
  }
  void changeTimeOfInjury(String value) {
    if (_state.cause == value) return;
    _state.cause = value;
    notifyListeners();
  }



  Future<void> onAddButtonPressed(BuildContext context) async {
    final type = _state.type;
    final location = _state.location;
    final severity = _state.severity;
    final timeOfInjury = _state.dateTimeOfInjury;
    final cause = _state.cause;
  //  if (name.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty || phoneNumber.isEmpty) return;
    //print(name +"\n"+ age+"\n"+  gender+"\n"+  address+"\n"+  phoneNumber);
    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    try {

      await _regService.addCurrentInjury(type, location, severity, timeOfInjury, cause, id);
      _state.isAddInProcess = false;
      //якийсь месджбокс мб
      notifyListeners();
      Navigator.of(context).pop();

    } catch (exeption) {
      print(exeption);
      _state.addErrorTitle =
          S.of(context).ServiceError;
      _state.isAddInProcess = false;
      notifyListeners();
    }
  }
}

class AddInjuryWidget extends StatelessWidget {
  const AddInjuryWidget({Key? key}) : super(key: key);

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(id),
      child: const AddInjuryWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: S.of(context).AddRecord),
      body: const SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                _ErrorTitleWidget(),
                SizedBox(height: 10),
                _TypeWidget(),
                SizedBox(height: 10),
                _LocationWidget(),
                SizedBox(height: 10),
                _SeverityWidget(),
                SizedBox(height: 10),
                _TimeWidget(),
                SizedBox(height: 10),
                _CauseWidget(),
                SizedBox(height: 10),
                RegButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _TypeWidget extends StatelessWidget {
  const _TypeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeType,
      hintText: S.of(context).Type,
    );
  }
}

class _LocationWidget extends StatelessWidget {
  const _LocationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeLocation,
      hintText: S.of(context).Location,
    );
  }
}

class _SeverityWidget extends StatelessWidget {
  const _SeverityWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeSeverity,
      hintText: S.of(context).Severity,
    );
  }
}

class _TimeWidget extends StatelessWidget {
  const _TimeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeTimeOfInjury,
      hintText: S.of(context).Time,
    );
  }
}

class _CauseWidget extends StatelessWidget {
  const _CauseWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeCause,
      hintText: S.of(context).Cause,
    );
  }
}


class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
    context.select((_ViewModel value) => value.state.addErrorTitle);
    return Text(authErrorTitle);
  }
}

class RegButtonWidget extends StatelessWidget {
  const RegButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final model = context.read<_ViewModel>();
    final addButtonState = context.select((_ViewModel value) =>
    value.state.addButtonState);

    final onPressed = addButtonState == _ViewModelAddButtonState.canSubmit
        ? model.onAddButtonPressed
        : null;

    final child = addButtonState == _ViewModelAddButtonState.addProcess
        ? const CircularProgressIndicator()
        : Text(S
        .of(context)
        .Add);
    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}