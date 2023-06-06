import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';
import 'package:realm/realm.dart';

import '../../domain/data_providers/reg_provider.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/dropMenu_service.dart';
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
  PhoneNumber phoneNumber = PhoneNumber(phoneNumber: "");
  String medicalHistoryID = "";
  bool isAddInProcess = false;
  DateTime birthday = DateTime.now();

  String dateFormat ="yyyy-mm-dd";
  TextEditingController dataController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  _ViewModelAddButtonState get authButtonState {
    if (isAddInProcess) {
      return _ViewModelAddButtonState.addProcess;
    } else if (fname.isNotEmpty && lname.isNotEmpty) {
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

  void changeGender(String? value) {
    if (_state.gender == value || value is! String) return;
    _state.gender = value;
    notifyListeners();
  }


  void changeAddress(String value) {
    if (_state.address == value) return;
    _state.address = value;
    notifyListeners();
  }

  void changePhoneNumber(PhoneNumber value) {
    if (_state.phoneNumber == value) return;
    _state.phoneNumber = value;
    notifyListeners();
  }

  void pickDate(BuildContext context)async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate:DateTime(1900),
        lastDate: DateTime.now()
    );
    if(pickedDate != null){
      print(pickedDate.toString());
      String formattedDate = DateFormat(_state.dateFormat).format(pickedDate);
      print(formattedDate);
      _state.dataController.text = formattedDate.toString();
      _state.birthday = pickedDate;
    }
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
    final gender = _state.gender;
    final address = _state.address;
    final phoneNumber = _state.phoneNumber.phoneNumber;


    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    if (_state.formKey.currentState == null) {
      _state.addErrorTitle =
          S.of(context).ServiceError;
      _state.isAddInProcess = false;
      notifyListeners();
      return;
    }
    else if(!_state.formKey.currentState!.validate()){
      _state.addErrorTitle =  S.of(context).InputError;
      _state.isAddInProcess = false;
      notifyListeners();
      return;
    }
    
    try {
      await _regService.registerPatient(Patient(ObjectId(), fname: fname, mname: mname, lname: lname, gender: gender, address: address, phoneNumber: phoneNumber));
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

  void setDataFormat(String format) {
    _state.dateFormat = format;
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
    final key =
    context.select((_ViewModel value) => value.state.formKey);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _ErrorTitleWidget(),
                  SizedBox(height: 10),
                  _FNameWidget(),
                  SizedBox(height: 10),
                  _LNameWidget(),
                  SizedBox(height: 10),
                  _MNameWidget(),
                  SizedBox(height: 10),
                  _DatePickWidget(),
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
        return model.validateOnEmpty(value, context);
      },
      decoration: InputDecoration(

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
    return TextFormField(
      decoration: InputDecoration(
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
    return TextFormField(
      validator: (String? value) {
        return model.validateOnEmpty(value, context);
      },
      decoration: InputDecoration(
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

class _DatePickWidget extends StatelessWidget {
  const _DatePickWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final dataController =
    context.select((_ViewModel value) => value.state.dataController);
    model.setDataFormat(S.of(context).FormatOfDate);
    return TextFormField(
      controller: dataController,
      readOnly: true,
      onTap: () => model.pickDate(context),
      decoration: InputDecoration(
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Birthday,
          fillColor: inputColor),
      //onChanged: model.changelName,
    );
  }
}



class _GenderWidget extends StatelessWidget {
  const _GenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();


    return DropdownButtonFormField(
      items: DropMenuService.fromList2DropItems(['Чоловік', 'Жінка']),
      decoration: InputDecoration(
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Gender,
          fillColor: inputColor),
      onChanged: model.changeGender,
      //onChanged: model.changelName,
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Address,
          fillColor: inputColor),
      onChanged: model.changeAddress,
    );
  }
}

class _PhoneNumberWidget extends StatelessWidget {
  const _PhoneNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    final phoneNumber =
    context.select((_ViewModel value) => value.state.phoneNumber);
    return InternationalPhoneNumberInput(
      validator: phoneNumber.phoneNumber == null || phoneNumber.phoneNumber!.isEmpty ?  (value) {
        return null;
      } : null,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      inputDecoration: InputDecoration(
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .TelephoneNumber,
          fillColor: inputColor),
      onInputChanged: model.changePhoneNumber,
      keyboardType:
      const TextInputType.numberWithOptions(signed: true, decimal: true),
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
      onPressed: onPressed == null ? null : () => onPressed.call(context),
      child: child,
    );
  }
}