import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/ui/helper/inputConstants.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:medapp/ui/widgets/CustomAppBar.dart';
import 'package:medapp/ui/widgets/TransparentButton.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';

import '../../domain/entity/doctor.dart';
import '../../domain/services/doctor_service.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../navigation/main_navigation.dart';
import '../widgets/AccountInfoWidget.dart';
enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {
  final String doctorNameTitle;
  String gender;
  String phoneNumber;
  String email;
  String bio;

  _ViewModelState({
    required this.doctorNameTitle,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.bio
  });

  _ViewModelState copyWith({
    String? doctorNameTitle,
    String? gender,
    String? phoneNumber,
    String? email,
    String? bio
  }) {
    return _ViewModelState(
        doctorNameTitle: doctorNameTitle ?? this.doctorNameTitle,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        bio: bio ?? this.bio,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _doctorService = DoctorService();
  final _authService = AuthService();

  var _state = _ViewModelState(doctorNameTitle: '', gender: '', phoneNumber: '', email: '', bio: '');
  _ViewModelState get state => _state;

  Future<void> onChangePasswordClick() async {
    Navigator.of(context).pushNamed('/patients_page/doctor_account/changePassword');
  }

  Future<void> onBackTap() async {
    Navigator.of(context).pop();
  }


  void loadValue() async {
  await _doctorService.initilalize();
  _updateState();
  }

  _ViewModel(this.context) {
  loadValue();
  }

  String getGenderImagePath(String gender) {
    print(gender);
    if(gender == "Чоловік") {
      return "assets/images/manDoctor.png";
    }
    if(gender == "Жінка") {
      return "assets/images/womanDoctor.png";
    }
    return "assets/images/stethoscope.png";

  }
  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    MainNavigation.showLoader(context);
  }

  void _updateState() {
    final Doctor? doctor = _doctorService.doctor;
    if(doctor != null) {
      _state = _state.copyWith(
          doctorNameTitle: "${doctor.lName} ${doctor.fName} ${doctor.mName} ",
          gender: doctor.gender,
          phoneNumber: doctor.number,
          email: doctor.email,
          bio: doctor.BIO

      );
    }
    notifyListeners();
  }

}

class DoctorAccountWidget extends StatelessWidget {
    const DoctorAccountWidget({Key? key}) : super(key: key);

    static Widget create(id) {
    return ChangeNotifierProvider(
    create: (context) => _ViewModel(context),
    child: const DoctorAccountWidget(),
    );
}

@override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF3AB7FF), Color(0xFFA8E7FF), Color(0xFF3AB7FF)])),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: CustomScrollView(
              slivers: [

                SliverAppBar(
                  shadowColor: const Color(0xFF3AB7FF),
                  toolbarHeight: 300,
                  expandedHeight: 300,
                  pinned: false,
                  //backgroundColor: Colors.transparent,
                  leading: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: _BackWidget()),
                  flexibleSpace: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF3AB7FF), Color(0xFFA8E7FF), Color(0xFF3AB7FF)]))
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size.zero,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            child: Column(
                              children: const [
                                _ImageWidget(),
                                _PIPWidget()
                              ],
                            ),
                          ))

                  ),),

                SliverToBoxAdapter(
                    child: Container(

                        constraints:  BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              topLeft: Radius.circular(30.0),
                            )),
                        child: const Padding(
                          padding:  EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              _BIO(),
                              SizedBox(height: 10),
                              _TelephoneNumber(),
                              SizedBox(height: 10),
                              _Email(),
                              SizedBox(height: 10),

                              _ChangePasswordWidget(),
                              SizedBox(height: 10),
                              _ExitButton(),




                            ],
                          ),
                        ))),
              ])
      ),
    ),
  );
}
}

class _ChangePasswordWidget extends StatelessWidget {
  const _ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return   CustomButton(
      onPressed: viewModel.onChangePasswordClick, text: S.of(context).ChangePassword,
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return   TransparentButton(
      onPressed: () => viewModel.onLogoutPressed(context), text: S.of(context).Exit,
    );
  }
}

class _TelephoneNumber extends StatelessWidget {
  const _TelephoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var telephoneNumber = context.select((_ViewModel vm) =>
    vm.state.phoneNumber);
    telephoneNumber = telephoneNumber.isEmpty ? S
        .of(context)
        .NoInformation : telephoneNumber;
    return AccountInfoWidget(title: S
        .of(context)
        .TelephoneNumber, textInfo: telephoneNumber);
  }
}

class _Email extends StatelessWidget {
  const _Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var email = context.select((_ViewModel vm) => vm.state.email);
    email = email.isEmpty ? S
        .of(context)
        .NoInformation : email;
    return AccountInfoWidget(title: S
        .of(context)
        .Email, textInfo: email);
  }
}

class _BIO extends StatelessWidget {
  const _BIO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bio = context.select((_ViewModel vm) => vm.state.bio);
    bio = bio.isEmpty ? S
        .of(context)
        .NoInformation : bio;
    return AccountInfoWidget(title: S
        .of(context)
        .AboutMyself, textInfo: bio);
  }
}




class _BackWidget extends StatelessWidget {
  const _BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return IconButton(onPressed: viewModel.onBackTap,
        icon: const Icon(Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,));
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    var gender = context.select((_ViewModel vm) => vm.state.gender);
    return Center(

      child: Image.asset(
          width: 150,
          viewModel.getGenderImagePath(gender)
      ),
    );
  }
}

class _PIPWidget extends StatelessWidget {
  const _PIPWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) =>
    vm.state.doctorNameTitle);
    return
      Container(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34
          ),
        ),
      );
  }
}
