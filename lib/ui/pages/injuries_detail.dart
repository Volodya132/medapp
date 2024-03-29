import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import '../../domain/services/SyncService.dart';
import '../../domain/services/injury_service.dart';
import '../../domain/services/patient_service.dart';
import '../helper/ImagesFunc.dart';
import '../widgets/AccountInfoWidget.dart';
import '../widgets/CusomButton.dart';
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

  List imagesList = [];
  String dateTimeFormat = "yyyy-mm-dd h:mm a";

  _ViewModelState({
    required this.injuryNameTitle,
    required this.injurySnapshots,
    required this.injuryLocation,
    required this.injurySeverity,
    required this.dateTime,
    required this.cause,
  });

  int currentState = 0;

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
  final ObjectId injuryID;

  final _injuryService = InjuryService();

  var _state = _ViewModelState(
      injuryNameTitle: '',
      injurySnapshots: [],
      injuryLocation: '',
      injurySeverity: '',
      dateTime: null,
      cause: '');
  _ViewModelState get state => _state;

  Future<void> changeState(index) async {
    state.currentState = index;
    print(state.currentState);
    notifyListeners();
  }

  void loadValue() async {
    await _injuryService.initilalize(injuryID);
    _updateState();
  }

  _ViewModel(this.context, this.injuryID) {
    loadValue();
  }

  Future<void> onAddInjurySnapshotButtonPressed() async {
    Navigator.of(context).pushNamed(
        '/patients_page/patientDetail/injuryDetail/addInjurySnapshot',
        arguments: injuryID);
  }

  Future<void> onInjurySnapshotImageTap(snapshotID) async {
    Navigator.of(context).pushNamed(
        '/patients_page/patientDetail/injuryDetail/injurySnapshotDetail',
        arguments: [snapshotID, injuryID]);
  }

  String convertDateTimeToString(DateTime dateTime) {
    return DateFormat(_state.dateTimeFormat).format(dateTime).toString();
  }

  void updateImages(RealmResults<InjurySnapshot> injuriesPhoto)async {
    var tempImage = [];
    for (int i = 0; i < injuriesPhoto.length; i++) {
      if(injuriesPhoto[i].imageLocalPaths.isNotEmpty) {
        tempImage.add(getImageIfExist(injuriesPhoto[i].imageLocalPaths.first));
      }
      else {
        tempImage.add(getImageIfExist(null));
      }
    }
    if (tempImage != state.imagesList) {
      state.imagesList = tempImage;
      notifyListeners();
    }
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

  Future<void> removeInjurySnapshotFromInjury(injurySnapshot)async {
    _injuryService.deleteInjurySnapshot(injurySnapshot);
  }

  void _showAlertDialog(BuildContext context, injurySnapshotID)async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(S
                .of(context)
                .Attention),
            content: Text(S
                .of(context)
                .DoYouWantToDeleteTheNote),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S
                    .of(context)
                    .Cancel),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  removeInjurySnapshotFromInjury(injurySnapshotID);
                  _updateState();
                  Navigator.pop(context);
                  notifyListeners();
                },
                child: Text(S
                    .of(context)
                    .Delete),
              ),
            ],
          ),
    );
  }

  onInjurySnapShotLongPress(id, BuildContext context)async {
    _showAlertDialog(context, id);
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
    final title = context.select((_ViewModel vm) => vm.state.injuryNameTitle);
    var currentState = context.select((_ViewModel vm) => vm.state.currentState);
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _Swicher(),
              SizedBox(height: 25),
              currentState == 0 ? _NotesWidgets() : _InformationWidgets(),
            ],
          ),
        ),
      )),
    );
  }
}

class _Swicher extends StatelessWidget {
  const _Swicher({super.key});

  @override
  Widget build(BuildContext context) {
    var currentState = context.select((_ViewModel vm) => vm.state.currentState);
    final viewModel = context.read<_ViewModel>();
    return Container(
      child: CustomSwitch(
          currentState: currentState,
          labels: [S.of(context).Notes, S.of(context).Information],
          onChanged: viewModel.changeState),
    );
  }
}

class _NotesWidgets extends StatelessWidget {
  const _NotesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      _AddInjurySnapshotWidget(),
      SizedBox(height: 15),
      _InjurySnapshotsListWidget(),
      SizedBox(height: 10),
    ]);
  }
}

class _InformationWidgets extends StatelessWidget {
  const _InformationWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      _LocationInfoWidget(),
      SizedBox(height: 15),
      _SeverityInfoWidget(),
      SizedBox(height: 15),
      _DateTimeInfoWidget(),
      SizedBox(height: 15),
      _CauseInfoWidget()
    ]);
  }
}

class _LocationInfoWidget extends StatelessWidget {
  const _LocationInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var location = context.select((_ViewModel vm) => vm.state.injuryLocation);
    location = location.isEmpty ? S.of(context).NoInformation : location;
    return AccountInfoWidget(title: S.of(context).Location, textInfo: location);
  }
}

class _SeverityInfoWidget extends StatelessWidget {
  const _SeverityInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injurySeverity =
        context.select((_ViewModel vm) => vm.state.injurySeverity);
    injurySeverity =
        injurySeverity.isEmpty ? S.of(context).NoInformation : injurySeverity;
    return AccountInfoWidget(
        title: S.of(context).Severity, textInfo: injurySeverity);
  }
}

class _DateTimeInfoWidget extends StatelessWidget {
  const _DateTimeInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateTime = context.select((_ViewModel vm) => vm.state.dateTime);
    if (dateTime == null) {
      return AccountInfoWidget(
          title: S.of(context).Birthday, textInfo: S.of(context).NoInformation);
    }
    return AccountInfoWidget(
        title: S.of(context).Severity,
        textInfo: WorkWithDate.fromDateToString(
            dateTime, S.of(context).FormatOfDateTime));
  }
}

class _CauseInfoWidget extends StatelessWidget {
  const _CauseInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cause = context.select((_ViewModel vm) => vm.state.cause);
    cause = cause.isEmpty ? S.of(context).NoInformation : cause;
    return AccountInfoWidget(title: S.of(context).Cause, textInfo: cause);
  }
}

class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) => vm.state.injuryNameTitle);
    return Text(
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
    return CustomButton(
        onPressed: viewModel.onAddInjurySnapshotButtonPressed,
        text: S.of(context).Add,
        icon: Icons.add);
  }
}

class _InjurySnapshotsListWidget extends StatelessWidget {
  const _InjurySnapshotsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injurySnapshot =
        context.select((_ViewModel vm) => vm.state.injurySnapshots);
    var updateImages = context.select((_ViewModel vm) => vm.state.imagesList);
    final viewModel = context.read<_ViewModel>();

    return StreamBuilder<RealmResultsChanges<InjurySnapshot>>(
        stream: RealmService.getInjurySnapshotChanges(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          SyncService.sync();
          if (data == null) return const CircularProgressIndicator();
          viewModel.loadValue();
          final queryList = RealmService.makeRealmList(injurySnapshot);
          final results =
              data.results.query("_id in $queryList SORT(datetime DESC)");

          //injurySnapshot = viewModel.state.injurySnapshots;
          var imagesList = [];
          for (int i = 0; i < results.length; i++) {
            imagesList.add(getImageIfExist(results[i].imageLocalPaths.isNotEmpty ? results[i].imageLocalPaths.first : null));
          }

          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () => viewModel.onInjurySnapShotLongPress(results[index].id, context),
                  onTap: () {
                    viewModel.onInjurySnapshotImageTap(results[index].id);
                  },
                  child: Card(
                    //
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10)), //                           <-- Card widget
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: DecorationImage(
                                image: updateImages.length != results.length
                                    ? imagesList[index]
                                    : updateImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 200,
                          ),
                          SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      results[index] == null
                                          ? Container()
                                          : results[index].datetime == null
                                              ? Container()
                                              : Text(WorkWithDate.fromDateToString(
                                                  results[index].datetime!,
                                                  S.of(context).FormatOfDateTime)),
                                      Text(
                                          '${S.of(context).Area}: ${results[index].area}')
                                    ],
                                  ),
                                  IconButton(onPressed: () async{ viewModel.updateImages(results);  }, icon: Icon(Icons.autorenew_rounded),
                                    
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  )));
        });
  }
}

