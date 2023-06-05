
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/doctor.dart';
import 'package:medapp/domain/services/dropMenu_service.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';
import 'package:realm/realm.dart';

import '../../domain/data_providers/reg_provider.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../helper/inputConstants.dart';
import '../navigation/main_navigation.dart';
enum _ViewModelRegButtonState { canSubmit, regProcess, disable }

class _ViewModelState {
  String regErrorTitle = '';
  String login = '';
  String password = '';
  String repPassword = '';
  String email  = '';
  String fname = '';
  String mname = '';
  String lname = '';
  String gender = '';




  DateTime birthday = DateTime.now();
  bool isRegInProcess = false;
  String dateFormat ="yyyy-mm-dd";
  final formKey = GlobalKey<FormState>();

  TextEditingController dataController = TextEditingController();
  _ViewModelRegButtonState get authButtonState {
    if (isRegInProcess) {
      return _ViewModelRegButtonState.regProcess;
    } else if (login.isNotEmpty &&
        password.isNotEmpty &&
        fname.isNotEmpty  &&
        mname.isNotEmpty  &&
        lname.isNotEmpty  &&
        gender.isNotEmpty) {
      return _ViewModelRegButtonState.canSubmit;
    } else {
      return _ViewModelRegButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _regService = RegService();

  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  void changeLogin(String value) {
    if (_state.login == value) return;
    _state.login = value;
    notifyListeners();
  }

  void changePassword(String value) {
    if (_state.password == value) return;
    _state.password = value;
    notifyListeners();
  }

  void changeRepeatPassword(String value) {
    if (_state.repPassword == value) return;
    _state.repPassword = value;
    notifyListeners();
  }

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

  void changelName(String value) {
    if (_state.lname == value) return;
    _state.lname = value;
    notifyListeners();
  }

  void changeGender(String? value) {
    if (_state.gender == value || value is! String) return;
    _state.gender = value;
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

  void setDataFormat(String format) {
    _state.dateFormat = format;
  }


  Future<void> onRegButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;
    final fname = _state.fname;
    final mname = _state.mname;
    final lname = _state.lname;
    final gender = _state.gender;
    final email = _state.email;
    final birthday = _state.birthday;

    _state.regErrorTitle = '';
    _state.isRegInProcess = true;
    notifyListeners();

    if (_state.formKey.currentState == null) {
      _state.regErrorTitle =
          S.of(context).ServiceError;
      _state.isRegInProcess = false;
      notifyListeners();
      return;
    }
    else if(!_state.formKey.currentState!.validate()){
      _state.regErrorTitle =  S.of(context).InputError;
      _state.isRegInProcess = false;
      notifyListeners();
      return;
    }
    try {
      await _regService.registerDoctor(Doctor(ObjectId(), birtday: birthday, fName: fname, mName: mname, lName: lname, gender: gender, email: email, login: login, password: password));
      _state.isRegInProcess = false;
      //якийсь месджбокс мб
      notifyListeners();
      MainNavigation.showLoader(context);
    } on RegProviderIncorrectLoginDataError {
      _state.regErrorTitle =  S.of(context).WrongAnswerOrPassword;
      _state.isRegInProcess = false;
      notifyListeners();
    } catch (exeption) {

      _state.regErrorTitle =
          S.of(context).ServiceError;
      _state.isRegInProcess = false;
      notifyListeners();
    }
  }
}

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const RegisterWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key =
    context.select((_ViewModel value) => value.state.formKey);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _ErrorTitleWidget(),
                const SizedBox(height: 10),
                const _lNameWidget(),
                const SizedBox(height: 10),
                const _fNameWidget(),
                const SizedBox(height: 10),
                const _mNameWidget(),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Flexible(child: _GenderWidget()),
                    Flexible(child: _DatePickWidget()),
                  ],
                ),
                const SizedBox(height: 10),
                const _LoginWidget(),
                const SizedBox(height: 10),
                const  _PasswordWidget(),
                const SizedBox(height: 10),
                const  _RepeatWidget(),
                const SizedBox(height: 10),
                const RegButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class _LoginWidget extends StatelessWidget {
  const _LoginWidget({Key? key}) : super(key: key);
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
              .Login,
          fillColor: inputColor),
      onChanged: model.changeLogin,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({Key? key}) : super(key: key);

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
          prefixIcon: const Icon(Icons.lock_outline),
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Password,
          fillColor: inputColor),
      onChanged: model.changePassword,
    );
  }
}

class _RepeatWidget extends StatelessWidget {
  const _RepeatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final password =
    context.select((_ViewModel value) => value.state.password);

    return TextFormField(
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S
              .of(context).FieldCannotBeEmpty;
        }
        print("password: ${password}\nvalue:${value}");
        if(password != value) {

          return S
              .of(context).PasswordsDoNotMatch;
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline),
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .RepeatPassword,
          fillColor: inputColor),
      onChanged: model.changeRepeatPassword,
    );
  }
}

class _fNameWidget extends StatelessWidget {
  const _fNameWidget({Key? key}) : super(key: key);

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
          enabledBorder:enabledBorder,
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

class _mNameWidget extends StatelessWidget {
  const _mNameWidget({Key? key}) : super(key: key);

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
          enabledBorder:enabledBorder,
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


class _lNameWidget extends StatelessWidget {
  const _lNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextFormField(
      validator: (value) {
        print(value);
        if (value == null || value.isEmpty || value == '123') {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .LName,
          fillColor: inputColor),
      onChanged: model.changelName
    );
  }
}

class _GenderWidget extends StatelessWidget {
  const _GenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return DropdownButtonFormField(
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S
              .of(context).FieldCannotBeEmpty;
        }
        return null;
      },
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

class _DatePickWidget extends StatelessWidget {
  const _DatePickWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final dataController =
    context.select((_ViewModel value) => value.state.dataController);
    model.setDataFormat(S.of(context).FormatOfDate);
    return TextFormField(
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S
              .of(context).FieldCannotBeEmpty;
        }
        return null;
      },
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


class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
    context.select((_ViewModel value) => value.state.regErrorTitle);
    return Text(authErrorTitle);
  }
}

class RegButtonWidget extends StatelessWidget {
  const RegButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState =
    context.select((_ViewModel value) => value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelRegButtonState.canSubmit
        ? model.onRegButtonPressed
        : null;

    final child = authButtonState == _ViewModelRegButtonState.regProcess
        ? const CircularProgressIndicator()
        :  Text(S
        .of(context)
        .Registraion);
    return ElevatedButton(
      onPressed: onPressed == null ? null : () => onPressed.call(context),
      child: child,
    );
  }
}