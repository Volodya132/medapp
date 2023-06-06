import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/ui/helper/inputConstants.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';

import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../navigation/main_navigation.dart';
enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {
  String authErrorTitle = '';
  String login = '';
  String password = '';
  bool isAuthInProcess = false;

  bool obscurePassword = true;
  _ViewModelAuthButtonState get authButtonState {
    if (isAuthInProcess) {
      return _ViewModelAuthButtonState.authProcess;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return _ViewModelAuthButtonState.canSubmit;
    } else {
      return _ViewModelAuthButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final _state = _ViewModelState();
  _ViewModelState get state => _state;
  _ViewModel() {
    RealmService.updateSubscriptions();
  }
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

  Future<void> onRegisterPressed(BuildContext context) async {
    Navigator.of(context).pushNamed("/auth/register");

  }
  void onPasswordIconPressed() async {
    _state.obscurePassword = !_state.obscurePassword;
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;

    if (login.isEmpty || password.isEmpty) return;

    _state.authErrorTitle = '';
    _state.isAuthInProcess = true;
    notifyListeners();

    try {
      await _authService.login(login, password);
      _state.isAuthInProcess = false;
      notifyListeners();
      MainNavigation.showLoader(context);
    } on AuthProviderIncorrectLoginDataError {
      _state.authErrorTitle =  S.of(context).ThereIsNoUserWithTheEnteredLogin;
      _state.isAuthInProcess = false;
      notifyListeners();
    } on AuthProviderIncorrectPasswordDataError {
      _state.authErrorTitle =  S.of(context).ThePasswordEnteredIsIncorrect;
      _state.isAuthInProcess = false;
      notifyListeners();
    } catch (exeption) {
      print(exeption);
      _state.authErrorTitle =
          S.of(context).ThePasswordEnteredIsIncorrect;
      _state.isAuthInProcess = false;
      notifyListeners();
    }
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _WelcomeWidget(),
                SizedBox(height: 10),
                _ErrorTitleWidget(),
                SizedBox(height: 10),
                _LoginWidget(),
                SizedBox(height: 10),
                _PasswordWidget(),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: _ForgotPasswordTitle(),
                ),
                SizedBox(height: 10),
                AuthButtonWidget(),
                SizedBox(height: 10),
                RegWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final title = S
        .of(context)
        .WelcomeBack;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context).SubtitleOnLoginScreen,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
        ),
      ],
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
          prefixIcon: const Icon(Icons.mail),
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
    final obscurePassword =
    context.select((_ViewModel value) => value.state.obscurePassword);
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: model.onPasswordIconPressed,
            icon: obscurePassword ? const Icon(Icons.lock_outline) :  const Icon(Icons.lock_open_outlined),),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Password,
          fillColor: inputColor),
      onChanged: model.changePassword,
      obscureText: obscurePassword,

    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
    context.select((_ViewModel value) => value.state.authErrorTitle);
    return Text(authErrorTitle);
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState =
    context.select((_ViewModel value) => value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAuthButtonState.canSubmit
        ? model.onAuthButtonPressed
        : null;

    final child = authButtonState == _ViewModelAuthButtonState.authProcess
        ? const CircularProgressIndicator()
        :  Text(S
        .of(context)
        .LogIn);
    return ElevatedButton(
      //style:  styleForCommonButton,
      onPressed: onPressed == null ? null : () => onPressed.call(context),
      child: child,
    );
  }
}

class RegWidget extends StatelessWidget {
  const RegWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return GestureDetector(
        onTap: () => viewModel.onRegisterPressed(context),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Text("${S.of(context).DontHaveAcc} "),
              Text(S.of(context).SingUp)
            ]));
  }
}


class _ForgotPasswordTitle extends StatelessWidget {
  const _ForgotPasswordTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(S.of(context).ForgotPassword,
      textAlign: TextAlign.end,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey),
    );
  }
}