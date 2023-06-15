import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/injurySnapshot.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/injury_service.dart';
import '../../domain/services/patient_service.dart';
import '../widgets/AccountInfoWidget.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomSwitch.dart';
import '../widgets/WorkWithDate.dart';



class _ViewModelState {
  final String injuryNameTitle;
  final String injuryLocation;
  final String injurySeverity;
  final DateTime? dateTime;
  final String cause;
  List<ObjectId?> injurySnapshots;

  String dateTimeFormat ="yyyy-mm-dd h:mm a";

  _ViewModelState({
    required this.injuryNameTitle,
    required this.injurySnapshots,
    required this.injuryLocation,
    required this.injurySeverity,
    required this.dateTime,
    required this.cause,
  });

  int currentState =0;


  _ViewModelState copyWith({
    String? injuryNameTitle,
    var injurySnapshots,
    String? injuryLocation,
    String? injurySeverity,
    DateTime? dateTime,
    String? cause,

  }) {
    return _ViewModelState(
      injuryNameTitle: injuryNameTitle ?? this.injuryNameTitle,
      injurySnapshots: injurySnapshots ?? this.injurySnapshots,
      injuryLocation: injuryLocation ?? this.injuryLocation,
      injurySeverity: injurySeverity ?? this.injurySeverity,
      dateTime: dateTime ?? this.dateTime,
      cause: cause ?? this.cause,


    );
  }

  String? getLastChange(int index) {


    return null;
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final ObjectId id;

  final _injuryService = InjuryService();

  var _state = _ViewModelState(injuryNameTitle: '', injurySnapshots: [], injuryLocation: '', injurySeverity: '', dateTime: null, cause: '');
  _ViewModelState get state => _state;

  Future<void> changeState(index) async {
    state.currentState = index;
    print( state.currentState);
    notifyListeners();
  }
  void loadValue() async {
    await _injuryService.initilalize(id);
    _updateState();

  }

  _ViewModel(this.context, this.id) {
    loadValue();
  }


  Future<void> onAddInjurySnapshotButtonPressed() async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail/addInjurySnapshot', arguments: id);
  }
  Future<void> onInjurySnapshotImageTap(snapshotID) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail/injurySnapshotDetail', arguments: snapshotID);
  }

  String convertDateTimeToString(DateTime dateTime) {
    return DateFormat(_state.dateTimeFormat).format(dateTime).toString();
  }
  void _updateState() {
    final Injury injury = _injuryService.injury!;

    _state = _state.copyWith(
      injuryNameTitle: injury.type,
      injurySnapshots: injury.injurySnapshotIDs,
      injuryLocation: injury.location,
      injurySeverity: injury.severity,
      dateTime: injury.timeOfInjury,
      cause: injury.cause,
    );
    notifyListeners();
  }
}

class InjuryDetail extends StatelessWidget {
  const InjuryDetail({Key? key}) : super(key: key);

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, id),
      child: const InjuryDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) =>
    vm.state.injuryNameTitle);
    var currentState = context.select((_ViewModel vm) =>
    vm.state.currentState);
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body:  SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  _Swicher(),
                  SizedBox(height: 25),
                  currentState == 0
                      ? _NotesWidgets()
                      : _InformationWidgets(),
                ],
              ),
            ),
          )
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
          labels: [S.of(context).Notes,S.of(context).Information],
          onChanged: viewModel.changeState

      ),
    );
  }
}

class _NotesWidgets extends StatelessWidget {
  const _NotesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
        children: [
          _AddInjurySnapshotWidget(),
          SizedBox(height: 15),
          _InjurySnapshotsListWidget(),
          SizedBox(height: 10),
        ]
    );
  }
}

class _InformationWidgets extends StatelessWidget {
  const _InformationWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
        children: [
          _LocationInfoWidget(),
          SizedBox(height: 15),
          _SeverityInfoWidget(),
          SizedBox(height: 15),
          _DateTimeInfoWidget(),
          SizedBox(height: 15),
          _CauseInfoWidget()

        ]
    );
  }
}

class _LocationInfoWidget extends StatelessWidget {
  const _LocationInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var location = context.select((_ViewModel vm) =>
    vm.state.injuryLocation);
    location = location.isEmpty ? S
        .of(context)
        .NoInformation : location;
    return AccountInfoWidget(title: S
        .of(context)
        .Location, textInfo: location);
  }
}

class _SeverityInfoWidget extends StatelessWidget {
  const _SeverityInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injurySeverity = context.select((_ViewModel vm) =>
    vm.state.injurySeverity);
    injurySeverity = injurySeverity.isEmpty ? S
        .of(context)
        .NoInformation : injurySeverity;
    return AccountInfoWidget(title: S
        .of(context)
        .Severity, textInfo: injurySeverity);
  }
}

class _DateTimeInfoWidget extends StatelessWidget {
  const _DateTimeInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateTime = context.select((_ViewModel vm) =>
    vm.state.dateTime);
    if(dateTime == null) {
      return AccountInfoWidget(title: S
          .of(context)
          .Birthday, textInfo: S.of(context).NoInformation);
    }
    return AccountInfoWidget(title: S
        .of(context)
        .Severity, textInfo:  WorkWithDate.fromDateToString(dateTime, S.of(context).FormatOfDateTime));
  }
}

class _CauseInfoWidget extends StatelessWidget {
  const _CauseInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cause = context.select((_ViewModel vm) =>
    vm.state.cause);
    cause = cause.isEmpty ? S
        .of(context)
        .NoInformation : cause;
    return AccountInfoWidget(title: S
        .of(context)
        .Cause, textInfo: cause);
  }
}
class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) =>
    vm.state.injuryNameTitle);
    return
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
      );
  }

}

class _AddInjurySnapshotWidget extends StatelessWidget {
  const _AddInjurySnapshotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return ElevatedButton(
        style:  ElevatedButton.styleFrom(
          primary: const Color(0xea0f92d9),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // <-- Radius
          ),
        ),
        onPressed: viewModel.onAddInjurySnapshotButtonPressed,
        child: Row (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.add),
            Text(S.of(context).Add),

          ],
        ));
  }
}


class _InjurySnapshotsListWidget extends StatelessWidget {
  const _InjurySnapshotsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injurySnapshot = context.select((_ViewModel vm) =>
    vm.state.injurySnapshots);
    final viewModel = context.read<_ViewModel>();
    return StreamBuilder<RealmResultsChanges<InjurySnapshot>>(
        stream: RealmService.getInjurySnapshotChanges(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) return Container();
          final queryList = RealmService.makeRealmList(injurySnapshot);
          final results = data.results.query("_id in $queryList SORT(datetime DESC)");
          viewModel.loadValue();
          //injurySnapshot = viewModel.state.injurySnapshots;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  GestureDetector(
                      onTap: () =>
                          viewModel.onInjurySnapshotImageTap(
                              results[index].id),
                      child: Card( //
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ), //                           <-- Card widget
                        child:
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: getImageIfExist(
                                        results[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 200,
                              ),
                              SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      results[index] == null
                                          ? Container()
                                          : results[index].datetime ==
                                          null ? Container()
                                          : Text(
                                          WorkWithDate.fromDateToString(results[index].datetime!, S.of(context).FormatOfDateTime)
                                      ),
                                      Text('${S
                                          .of(context)
                                          .Area}: ${results[index].area}')
                                    ],
                                  )
                              )

                            ],
                          ),
                        ),
                      )
                  )
          );
        }

    );
  }
}



ImageProvider<Object> getImageIfExist(InjurySnapshot? injurySnapshot) {
  if(injurySnapshot == null){
    return const AssetImage("assets/images/img.png");
  }
  if(injurySnapshot.imageLocalPaths.isEmpty){
    return const AssetImage("assets/images/img.png");
  }
  var file = File(injurySnapshot.imageLocalPaths[0]);
  if(file.existsSync()) {
    return FileImage(file);
  }
  else {
    return const AssetImage("assets/images/img.png");
  }

}