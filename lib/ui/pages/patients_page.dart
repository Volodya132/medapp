import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/services/doctor_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/helper/buttonConstants.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/doctor.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/user_service.dart';
import '../navigation/main_navigation.dart';


class _ViewModelState {
  final String doctorNameTitle;
  var patients;
  String searchingPatients;


  _ViewModelState({
    required this.doctorNameTitle,
    required this.patients,
    required this.searchingPatients,
  });


  _ViewModelState copyWith({
    String? doctorNameTitle,
    var patients,
    String? searchingPatients,
  }) {
    return _ViewModelState(
      doctorNameTitle: doctorNameTitle ?? this.doctorNameTitle,
      patients: patients ?? this.patients,
      searchingPatients: searchingPatients ?? this.searchingPatients,
    );
  }

  String? getLastChange(int index) {

    DateTime? result = patients[index].getLastChange();
    if(result != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyy');
      return formatter.format(result);
    }
    return null;
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _doctorService = DoctorService();

  var _state = _ViewModelState(doctorNameTitle: '', patients: [], searchingPatients: '');
  _ViewModelState get state => _state;

  void loadValue() async {
    await _doctorService.initilalize();
    _updateState();
  }

  _ViewModel(this.context) {
    loadValue();
  }

  void changeSearching(String value) {
    if (_state.searchingPatients == value) return;
    _state.searchingPatients = value;
    notifyListeners();
  }

  Future<void> onAddPatientButtonPressed() async {
    Navigator.of(context).pushNamed('/patients_page/addPatient');

  }

  Future<void> onPatientClick(id) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail', arguments: id);
  }
  
  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    MainNavigation.showLoader(context);
  }
  void _updateState() {
    final Doctor doctor = _doctorService.doctor!;
    _state = _state.copyWith(
      doctorNameTitle: doctor.name,
      patients: doctor.patients,
    );
    notifyListeners();
  }
}

class PatientsPage extends StatelessWidget {
  const PatientsPage({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context),
      child: const PatientsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:const [
                      _WelcomeWidget(),
                      _MenuWidget()
                  ],),
                  const SizedBox(height: 20),
                  const _SearchingWidget(),
                  const SizedBox(height: 25),
                  const _PatientsTitle(),
                  const SizedBox(height: 15),
                  const _AddPatientWidget(),
                  const SizedBox(height: 15),
                  const _PatientsListWidget(),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final title = "${S.of(context).Hello} ${context.select((_ViewModel vm) => vm.state.doctorNameTitle)}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children:  [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context).HowDoYouDo,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
        ),
      ],
    );

    }

}

class _SearchingWidget extends StatelessWidget {
  const _SearchingWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 15, color:Color(0xfff1f2f5)),
              borderRadius:  BorderRadius.circular(15.0)
          ),
          focusedBorder:  OutlineInputBorder(
              borderSide: const BorderSide(width: 15, color: Color(0xfff1f2f5)),
              borderRadius:  BorderRadius.circular(15.0)
          ),
          filled: true,
          hintStyle: const TextStyle(color: Color(0xff9a9fa3)),
          hintText: S.of(context).PatientSearchHint,
          fillColor: const Color(0xfff1f2f5)),
      onChanged: model.changeSearching,
    );
  }
}

class _PatientsTitle extends StatelessWidget {
  const _PatientsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(S.of(context).PatientsLbl,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }
}

class _AddPatientWidget extends StatelessWidget {
  const _AddPatientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return ElevatedButton(

      onPressed: viewModel.onAddPatientButtonPressed,
      child: Row (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            const Icon(Icons.add),
            const SizedBox(width: 5),
            Text(S.of(context).AddPatient),

        ],
    ));
  }
}


class _MenuWidget extends StatelessWidget {
  const _MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return FloatingActionButton(
      onPressed: () => viewModel.onLogoutPressed(context),
      child: const Text('Вихід'),
    );
  }
}

class _PatientsListWidget extends StatelessWidget {
  const _PatientsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var patients = context.select((_ViewModel vm) => vm.state.patients);
    final viewModel = context.read<_ViewModel>();

    return StreamBuilder<RealmResultsChanges<Patient>>(
        stream: RealmService.getPatientsChanges() ,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) return Container();
          final results = data.results;
          viewModel.loadValue();
          patients = viewModel.state.patients;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                    child:
                    ListTile(
                      title: Text("${patients[index]?.fname ?? "No fname"} ${patients[index]?.lname ?? "No lname"}"),
                      subtitle: Text('${S
                          .of(context)
                          .LastChange}: ${S
                          .of(context)
                          .NoInformation}'),
                      onTap: () => viewModel.onPatientClick(patients[index]?.id),
                    ),
                  ));
        }

    );
  }
}