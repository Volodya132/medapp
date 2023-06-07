import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/domain/services/doctor_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/ui/helper/inputConstants.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:medapp/ui/widgets/CustomAppBar.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';

import '../../domain/data_providers/doctor_data_provider.dart';
import '../../generated/l10n.dart';
import '../helper/Validate.dart';
import '../helper/buttonConstants.dart';
import '../navigation/main_navigation.dart';
import '../widgets/CustomTextField.dart';
enum _ViewModelChangeButtonState { canSubmit, changeProcess, disable }

class _ViewModelState {
  String oldPassword = '';
  String newPassword = '';
  String repeatNewPassword = '';
  bool isChangeInProcess = false;

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureRepeatNewPassword = true;

  String changeErrorTitle = '';

  final formKey = GlobalKey<FormState>();

  _ViewModelChangeButtonState get changeButtonState {
    if (isChangeInProcess) {
      return _ViewModelChangeButtonState.changeProcess;
    } else if (oldPassword.isNotEmpty && newPassword.isNotEmpty && repeatNewPassword.isNotEmpty ) {
      return _ViewModelChangeButtonState.canSubmit;
    } else {
      return _ViewModelChangeButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _doctorService = DoctorService();

  final _state = _ViewModelState();

  _ViewModelState get state => _state;

  _ViewModel() {
    RealmService.updateSubscriptions();
  }
  void changeOldPassword(String value) {
    if (_state.oldPassword == value) return;
    _state.oldPassword = value;
    notifyListeners();
  }

  void changeNewPassword(String value) {
    if (_state.newPassword == value) return;
    _state.newPassword = value;
    notifyListeners();
  }

  void changeRepeatNewPassword(String value) {
    if (_state.repeatNewPassword == value) return;
    _state.repeatNewPassword = value;
    notifyListeners();
  }


  void onOldPasswordIconPressed() async {
    _state.obscureOldPassword = !_state.obscureOldPassword;
    notifyListeners();
  }

  void onNewPasswordIconPressed() async {
    _state.obscureNewPassword = !_state.obscureNewPassword;
    notifyListeners();
  }

  void onRepeatNewPasswordIconPressed() async {
    _state.obscureRepeatNewPassword = !_state.obscureRepeatNewPassword;
    notifyListeners();
  }

  Future<void> oChangeButtonPressed(BuildContext context) async {
    final oldPassword = _state.oldPassword;
    final newPassword = _state.newPassword;
    final repeatNewPassword= _state.repeatNewPassword;

    _state.changeErrorTitle = '';
    _state.isChangeInProcess = true;
    notifyListeners();
    if (_state.formKey.currentState == null) {
      _state.changeErrorTitle =
          S.of(context).ServiceError;
      _state.isChangeInProcess = false;
      notifyListeners();
      return;
    }
    else if(!_state.formKey.currentState!.validate()){
      _state.changeErrorTitle =  S.of(context).InputError;
      _state.isChangeInProcess = false;
      notifyListeners();
      return;
    }
    if(!(await _doctorService.isDoctorPassword(oldPassword))) {
      _state.changeErrorTitle = S.of(context).IncorrectOldPassword;
      _state.isChangeInProcess = false;
      notifyListeners();
      return;
    }
    try {
      await _doctorService.changePassword(oldPassword, newPassword);
      _state.isChangeInProcess = false;
      //якийсь месджбокс мб
      notifyListeners();
      MainNavigation.showLoader(context);
    } on DoctorDataProviderError {
      _state.changeErrorTitle =  S.of(context).ServiceError;
      _state.isChangeInProcess = false;
      notifyListeners();
    } on InvalidOldPassword {
      _state.changeErrorTitle =  S.of(context).IncorrectOldPassword;
      _state.isChangeInProcess = false;
      notifyListeners();
    } catch (exeption) {

      _state.changeErrorTitle =
          S.of(context).ServiceError;
      _state.isChangeInProcess = false;
      notifyListeners();
    }

    _state.isChangeInProcess = false;
  }


}


class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const ChangePassword(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key =
    context.select((_ViewModel value) => value.state.formKey);
    return Scaffold(
      appBar:CustomAppBar(title: S.of(context).PasswordChange),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _ErrorTitleWidget(),
                  SizedBox(height: 10),
                  _OldPasswordWidget(),
                  SizedBox(height: 10),
                  _NewPasswordWidget(),
                  SizedBox(height: 10),
                  _RepeatNewPasswordWidget(),
                  SizedBox(height: 10),
                  _ChangePasswordButtonWidget()

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _OldPasswordWidget extends StatelessWidget {
  const _OldPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final obscurePassword =
    context.select((_ViewModel value) => value.state.obscureOldPassword);
    IconData icon = obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined;
    return InputWidget(
      icon: icon,
      onIconPressed: model.onOldPasswordIconPressed,
      obscureText: obscurePassword,
      hintText: S.of(context).OldPassword,
      onChanged: model.changeOldPassword,
    );
  }
}


class _NewPasswordWidget extends StatelessWidget {
  const _NewPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final obscurePassword =
    context.select((_ViewModel value) => value.state.obscureNewPassword);
    IconData icon = obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined;
    return InputWidget(
      validator: (String? value) {
        return passwordValidator(context, value);
      },
      icon: icon,
      onIconPressed: model.onNewPasswordIconPressed,
      obscureText: obscurePassword,
      hintText: S.of(context).NewPassword,
      onChanged: model.changeNewPassword,
    );
  }
}

class _RepeatNewPasswordWidget extends StatelessWidget {
  const _RepeatNewPasswordWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final obscurePassword =
    context.select((_ViewModel value) => value.state.obscureRepeatNewPassword);
    IconData icon = obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined;
    final password =  context.select((_ViewModel value) => value.state.newPassword);
    return InputWidget(
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S
              .of(context).FieldCannotBeEmpty;
        }
        if(password != value) {

          return S
              .of(context).PasswordsDoNotMatch;
        }
        return null;
      },
      icon: icon,
      onIconPressed: model.onRepeatNewPasswordIconPressed,
      obscureText: obscurePassword,
      hintText: S.of(context).RepeatPassword,
      onChanged: model.changeRepeatNewPassword,
    );
  }
}


class _ChangePasswordButtonWidget extends StatelessWidget {
  const _ChangePasswordButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final regButtonState =
    context.select((_ViewModel value) => value.state.changeButtonState);

    final onPressed = regButtonState == _ViewModelChangeButtonState.canSubmit
        ? model.oChangeButtonPressed
        : null;

    final child = regButtonState == _ViewModelChangeButtonState.changeProcess
        ? const CircularProgressIndicator()
        :  null;
    return CustomButton(
      //style:  styleForCommonButton,
      onPressed: onPressed == null ? null : () => onPressed.call(context),
      text: S.of(context).ChangePassword,
      child: child,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changeErrorTitle =
    context.select((_ViewModel value) => value.state.changeErrorTitle);
    return Text(changeErrorTitle);
  }
}