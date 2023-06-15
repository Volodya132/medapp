import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:medapp/ui/widgets/WorkWithDate.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';
import '../helper/theme.dart';
import '../widgets/AccountInfoWidget.dart';
import '../widgets/CustomSwitch.dart';



class _ViewModelState {
  final String patientNameTitle;
  final DateTime? birthday;
  final String address;
  final String telephoneNumber;
  var injuries;
  String dateFormat ="yyyy-mm-dd";
  int currentState = 0;


  _ViewModelState({
    required this.patientNameTitle,
    required this.injuries,
    this.birthday,
    required this.telephoneNumber,
    required this.address,
  });


  _ViewModelState copyWith({
    String? patientNameTitle,
    var injuries,
    DateTime? birthday,
    String? telephoneNumber,
    String? address,
  }) {
    return _ViewModelState(
      patientNameTitle: patientNameTitle ?? this.patientNameTitle,
      injuries: injuries ?? this.injuries,
      birthday: birthday ?? this.birthday,
      telephoneNumber: telephoneNumber ?? this.telephoneNumber,
      address: address ?? this.address,
    );
  }


}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final ObjectId id;
  final _patientService = PatientService();

  var _state = _ViewModelState(patientNameTitle: '', injuries: [],  telephoneNumber: '', address: '');
  _ViewModelState get state => _state;

  void loadValue() async {
    await _patientService.initilalize(id);
    _updateState();

  }

  _ViewModel(this.context, this.id) {
    loadValue();
  }

  void setDataFormat(String formatOfDate) {
    _state.dateFormat = formatOfDate;
  }
  Future<void> onAddInjuryButtonPressed() async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/addInjury', arguments: id);
  }

  Future<void> onInjuryTap(id) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail', arguments: id);
  }
  Future<void> onBackTap() async {
    Navigator.of(context).pop();
  }

  Future<void> changeState(index) async {
    state.currentState = index;
    notifyListeners();
  }
  String? getLastChange(Injury injury) {

    DateTime? result = injury.getLastChange();
    if(result != null) {
      return WorkWithDate.fromDateToString(result, S.of(context).FormatOfDate);
    }
    return null;
  }

  void _updateState() {
    final Patient patient = _patientService.patient!;
    _state = _state.copyWith(
      patientNameTitle: "${patient.lname} ${patient.fname} ${patient.mname} ",
      injuries: patient.currentInjuries,
      birthday: patient.birthday,
      address: patient.address,
      telephoneNumber: patient.phoneNumber
    );
    notifyListeners();
  }

  Future<void> removeInjureFromPatient(injureId)async {

    _patientService.deleteInjure(injureId);
  }

  void _showAlertDialog(BuildContext context, injureID) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(S.of(context).Attention),
        content: Text(S.of(context).DoYouReallyWantToDeleteTheInjuryRecord),
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
              removeInjureFromPatient(injureID);
              _updateState();
              Navigator.pop(context);

            },
            child: Text(S.of(context).Delete),
          ),
        ],
      ),
    );
  }
  Future<void>  onInjureLongPress(id, BuildContext context)async {
    _showAlertDialog(context, id);
  }

}

class PatientDetail extends StatelessWidget {
  const PatientDetail({Key? key}) : super(key: key);

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, id),
      child: const PatientDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentState = context.select((_ViewModel vm) =>
    vm.state.currentState);
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
                    toolbarHeight: 80,
                    expandedHeight: 150,
                    pinned: true,
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
                    bottom: const PreferredSize(
                        preferredSize: Size.zero,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              children: const [
                                _WelcomeWidget()
                              ],
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
                          child: Padding(
                            padding:  EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                _Swicher(),
                                SizedBox(height: 15),
                                currentState == 0
                                    ? _InjuriesInfo()
                                :_InformationAboutPatient(),

                              ],
                            ),
                          ))),
                ])
        ),
      ),
    );
  }
}



class _Swicher extends StatelessWidget {
  const _Swicher({super.key});

  @override
  Widget build(BuildContext context) {
    var currentState = context.select((_ViewModel vm) =>
    vm.state.currentState);
    final viewModel = context.read<_ViewModel>();
    return Container(
      child: CustomSwitch(
        currentState: currentState,
        labels: [S.of(context).Injuries,S.of(context).Information],
        onChanged: viewModel.changeState

      ),
    );
  }
}

class _InjuriesInfo extends StatelessWidget {
  const _InjuriesInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
        children: [
          _AddPatientWidget(),
          SizedBox(height: 15),
          _InjuriesListWidget(),
          SizedBox(height: 10),
        ]
    );
  }
}

class _InformationAboutPatient extends StatelessWidget {
  const _InformationAboutPatient({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
        children: [
          _TelephoneNumber(),
          SizedBox(height: 15),
          _Address(),
          SizedBox(height: 15),
          _BirthdayWidget()
        ]
    );
  }
}




class _TelephoneNumber extends StatelessWidget {
  const _TelephoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var telephoneNumber = context.select((_ViewModel vm) =>
    vm.state.telephoneNumber);
    telephoneNumber = telephoneNumber.isEmpty ? S
        .of(context)
        .NoInformation : telephoneNumber;
    return AccountInfoWidget(title: S
        .of(context)
        .TelephoneNumber, textInfo: telephoneNumber);
  }
}

class _Address extends StatelessWidget {
  const _Address({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var address = context.select((_ViewModel vm) =>
    vm.state.address);
    address = address.isEmpty ? S
        .of(context)
        .NoInformation : address;
    return AccountInfoWidget(title: S
        .of(context)
        .Address, textInfo: address);
  }
}

class _BirthdayWidget extends StatelessWidget {
  const _BirthdayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    DateTime? birthday = context.select((_ViewModel vm) =>
    vm.state.birthday);
    viewModel.setDataFormat(S.of(context).FormatOfDate);

    if(birthday == null) {
      return AccountInfoWidget(title: S
        .of(context)
        .Birthday, textInfo: S.of(context).NoInformation);
    }


    return AccountInfoWidget(title: S
        .of(context)
        .Birthday, textInfo:  WorkWithDate.fromDateToString(birthday, S.of(context).FormatOfDate));
  }
}




class _BackWidget extends StatelessWidget {
  const _BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return IconButton(onPressed: viewModel.onBackTap, icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,));

  }
}

class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) =>
    vm.state.patientNameTitle);
    return
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34
          ),
        ),
      );
  }

}

class _AddPatientWidget extends StatelessWidget {
  const _AddPatientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return CustomButton(
        onPressed: viewModel.onAddInjuryButtonPressed,
        text: S.of(context).AddInjury,
        icon: Icons.add);
  }
}


class _InjuriesListWidget extends StatelessWidget {
  const _InjuriesListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var injuries = context.select((_ViewModel vm) => vm.state.injuries);
    final viewModel = context.read<_ViewModel>();
    return StreamBuilder<RealmResultsChanges<Injury>>(
        stream: RealmService.getInjuriesChanges(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) return Container();
          //final results = data.results;
          viewModel.loadValue();
          injuries = viewModel.state.injuries;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: injuries.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                    child:
                    ListTile(
                      title: Text(injuries[index]?.type ?? "No label",
                        style:
                        const TextStyle(
                           // fontWeight: FontWeight.bold,
                            //fontSize: 22,
                        ),
                      ),
                      subtitle: Text('${S
                          .of(context)
                          .LastChange}: ${viewModel.getLastChange(injuries[index]) ?? S.of(context)
                          .NoInformation}'),
                      onTap: () => viewModel.onInjuryTap(injuries[index]?.id),
                      onLongPress: () => viewModel.onInjureLongPress(injuries[index]?.id, context),
                    ),
                  ));
        }
    );
  }
}