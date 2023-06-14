import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/services/doctor_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/helper/buttonConstants.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:medapp/ui/widgets/WorkWithDate.dart';
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
  String dateFormat ="yyyy-mm-dd";
  List<ObjectId> patientsIDS = [];


  _ViewModelState({
    required this.doctorNameTitle,
    required this.patients,
    required this.searchingPatients,
    required this.patientsIDS
  });


  _ViewModelState copyWith({
    String? doctorNameTitle,
    var patients,
    String? searchingPatients,
    List<ObjectId>? patientsIDS
  }) {
    return _ViewModelState(
        doctorNameTitle: doctorNameTitle ?? this.doctorNameTitle,
        patients: patients ?? this.patients,
        searchingPatients: searchingPatients ?? this.searchingPatients,
        patientsIDS: patientsIDS ?? this.patientsIDS
    );
  }


}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _doctorService = DoctorService();

  var _state = _ViewModelState(doctorNameTitle: '', patients: [], searchingPatients: '', patientsIDS:[]);
  _ViewModelState get state => _state;

  void loadValue() async {
    await _doctorService.initilalize();
    _updateState();
    _state.dateFormat = S.of(context).FormatOfDate;
  }

  _ViewModel(this.context) {

    loadValue();
  }
  String? getLastChange(Patient patient) {

    DateTime? result = patient.getLastChange();
    if(result != null) {
      return WorkWithDate.fromDateToString(result, state.dateFormat);
    }
    return null;
  }
  Future<void> removePatientFromDoctor(patientId)async {
    _doctorService.deletePatient(patientId);
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

  Future<void> onDoctorAccountClick() async {
    Navigator.of(context).pushNamed('/patients_page/doctor_account');
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  void _showAlertDialog(BuildContext context, patientID) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(S.of(context).Attention),
        content: Text(S.of(context).DoYouWantToDeleteThePatient),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(S.of(context).Cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              removePatientFromDoctor(patientID);
              _updateState();
              Navigator.pop(context);

            },
            child: Text(S.of(context).Delete),
          ),
        ],
      ),
    );
  }

  Future<void> onPatientLongPress(id, BuildContext context) async {
      _showAlertDialog(context, id);
  }
  
  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    MainNavigation.showLoader(context);
  }
  void _updateState() {
    final Doctor? doctor = _doctorService.doctor;
    if(doctor != null) {
      _state = _state.copyWith(
          doctorNameTitle: doctor.fName,
          patients: doctor.patients,
          patientsIDS: doctor.patientsIDs
      );
    }
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                      Flexible(child: _DoctorProfileWidget())
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
    return CustomButton(
        onPressed:  viewModel.onAddPatientButtonPressed,
        text: S.of(context).AddPatient,
        icon: Icons.add) ;
  }
}


class _DoctorProfileWidget extends StatelessWidget {
  const _DoctorProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return   IconButton(
      iconSize: 70,
      icon:  const Icon(Icons.account_circle_outlined),
      onPressed: viewModel.onDoctorAccountClick,
    );
  }
}

class _PatientsListWidget extends StatelessWidget {
  const _PatientsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var patients = context.select((_ViewModel vm) => vm.state.patients);
    var patientsIDS = context.select((_ViewModel vm) => vm.state.patientsIDS);
    var fio = context.select((_ViewModel vm) => vm.state.searchingPatients);
    final viewModel = context.read<_ViewModel>();

    return StreamBuilder<RealmResultsChanges<Patient>>(
        stream: RealmService.getPatientsChanges(fio, patientsIDS) ,
        builder: (context, snapshot) {

          final data = snapshot.data;
          if (data == null) return Container();
          final results = data.results;

          viewModel.loadValue();
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                    child:
                    ListTile(
                      title: Text("${results[index].lname} ${results[index].fname} ${results[index].mname}" ),
                      subtitle: Text('${S
                          .of(context)
                          .LastChange}: ${viewModel.getLastChange(results[index]) ?? S.of(context)
                          .NoInformation}'),
                      onTap: () => viewModel.onPatientClick(patients[index]?.id),
                      onLongPress: () => viewModel.onPatientLongPress(patients[index]?.id, context),
                    ),
                  ));
        }

    );
  }
}