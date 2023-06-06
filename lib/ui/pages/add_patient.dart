import 'package:flutter/material.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';

import '../../domain/data_providers/reg_provider.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../helper/inputConstants.dart';
import '../navigation/main_navigation.dart';
enum _ViewModelAddButtonState { canSubmit, addProcess, disable }

class _ViewModelState {
  String addErrorTitle = '';
  String fname = "";
  String mname = "";
  String lname = "";
  String age = "";
  String gender = "";
  String address = "";
  String phoneNumber = "";
  String medicalHistoryID = "";
  bool isAddInProcess = false;

  _ViewModelAddButtonState get authButtonState {
    if (isAddInProcess) {
      return _ViewModelAddButtonState.addProcess;
    } else if (fname.isNotEmpty && mname.isNotEmpty && lname.isNotEmpty && age.isNotEmpty && gender.isNotEmpty && gender.isNotEmpty && phoneNumber.isNotEmpty ) {
      return _ViewModelAddButtonState.canSubmit;
    } else {
      return _ViewModelAddButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _regService = RegService();

  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  void changeFName(String value) {
    if (_state.fname == value) return;
    _state.fname = value;
    notifyListeners();
  }

  void changeMName(String value) {
    if (_state.mname == value) return;
    _state.mname = value;
    notifyListeners();
  }

  void changeLName(String value) {
    if (_state.lname == value) return;
    _state.lname = value;
    notifyListeners();
  }


  void changeAge(String value) {
    if (_state.age == value) return;
    _state.age = value;
    notifyListeners();
  }

  void changeGender(String value) {
    if (_state.gender == value) return;
    _state.gender = value;
    notifyListeners();
  }

  void changeAddress(String value) {
    if (_state.address == value) return;
    _state.address = value;
    notifyListeners();
  }

  void changePhoneNumber(String value) {
    if (_state.phoneNumber == value) return;
    _state.phoneNumber = value;
    notifyListeners();
  }

  String? validateOnEmpty(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return S
          .of(context).FieldCannotBeEmpty;
    }
    return null;
  }
  Future<void> onAddButtonPressed(BuildContext context) async {
    final fname = _state.fname;
    final mname = _state.mname;
    final lname = _state.lname;
    final age = _state.age;
    final gender = _state.gender;
    final address = _state.address;
    final phoneNumber = _state.phoneNumber;

    if (fname.isEmpty || mname.isEmpty || lname.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty || phoneNumber.isEmpty) return;
    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    try {
      await _regService.registerPatient(fname, mname, lname, age, gender, phoneNumber, null);
      _state.isAddInProcess = false;
      //якийсь месджбокс мб
      notifyListeners();
      MainNavigation.showLoader(context);

    } catch (exeption) {
      print(exeption);
      _state.addErrorTitle =
          S.of(context).ServiceError;
      _state.isAddInProcess = false;
      notifyListeners();
    }
  }
}

class AddPatientWidget extends StatelessWidget {
  const AddPatientWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const AddPatientWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ErrorTitleWidget(),
              SizedBox(height: 10),
              _FNameWidget(),
              SizedBox(height: 10),
              _MNameWidget(),
              SizedBox(height: 10),
              _LNameWidget(),
              SizedBox(height: 10),
              _AgeWidget(),
              SizedBox(height: 10),
              _GenderWidget(),
              SizedBox(height: 10),
              _AddressWidget(),
              SizedBox(height: 10),
              _PhoneNumberWidget(),
              SizedBox(height: 10),
              RegButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FNameWidget extends StatelessWidget {
  const _FNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextFormField(
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S
              .of(context).FieldCannotBeEmpty;
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .FName,
          fillColor: inputColor),
      onChanged: model.changeFName,
    );
  }
}

class _MNameWidget extends StatelessWidget {
  const _MNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .MName,
          fillColor: inputColor),
      onChanged: model.changeMName,
    );
  }
}

class _LNameWidget extends StatelessWidget {
  const _LNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .LName,
          fillColor: inputColor),
      onChanged: model.changeLName,
    );
  }
}


class _AgeWidget extends StatelessWidget {
  const _AgeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
        labelText:S
            .of(context)
            .Age,
        border: const OutlineInputBorder(),
      ),
      onChanged: model.changeAge,
    );
  }
}

class _GenderWidget extends StatelessWidget {
  const _GenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
        labelText: S
            .of(context)
            .Gender,
        border: const OutlineInputBorder(),
      ),
      onChanged: model.changeGender,
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
        labelText: S
            .of(context)
            .Address,
        border: const OutlineInputBorder(),
      ),
      onChanged: model.changeAddress,
    );
  }
}

class _PhoneNumberWidget extends StatelessWidget {
  const _PhoneNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
        labelText: S
            .of(context)
            .TelephoneNumber,
        border: const OutlineInputBorder(),
      ),
      onChanged: model.changePhoneNumber,
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
    final authButtonState = context.select((_ViewModel value) => value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAddButtonState.canSubmit
        ? model.onAddButtonPressed
        : null;

    final child = authButtonState == _ViewModelAddButtonState.addProcess
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