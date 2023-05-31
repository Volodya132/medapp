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
enum _ViewModelRegButtonState { canSubmit, regProcess, disable }

class _ViewModelState {
  String regErrorTitle = '';
  String login = '';
  String name = '';
  String password = '';
  bool isRegInProcess = false;

  _ViewModelRegButtonState get authButtonState {
    if (isRegInProcess) {
      return _ViewModelRegButtonState.regProcess;
    } else if (login.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
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

  void changeName(String value) {
    if (_state.name == value) return;
    _state.name = value;
    notifyListeners();
  }

  Future<void> onRegButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;
    final name = _state.name;
    if (login.isEmpty || password.isEmpty || name.isEmpty) return;

    _state.regErrorTitle = '';
    _state.isRegInProcess = true;
    notifyListeners();

    try {
      await _regService.registerDoctor(login, password, name);
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ErrorTitleWidget(),
              SizedBox(height: 10),
              _NameWidget(),
              SizedBox(height: 10),
              _LoginWidget(),
              SizedBox(height: 10),
              _PasswordWidget(),
              SizedBox(height: 10),
              RegButtonWidget(),
            ],
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
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder:enabledBorder,
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
    return TextField(
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

class _NameWidget extends StatelessWidget {
  const _NameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder:enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Name,
          fillColor: inputColor),
      onChanged: model.changeName,
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
        : const Text('Реєстрація');
    return ElevatedButton(
      style:  styleForCommonButton,
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}