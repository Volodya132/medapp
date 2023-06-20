import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/SyncService.dart';
import 'package:medapp/domain/services/injurySnapshot_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/widgets/WorkWithDate.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';
import '../widgets/AccountInfoWidget.dart';
import '../widgets/CusomButton.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomSwitch.dart';



class _ViewModelState {
  final DateTime? dateTime;
  final List<String> images;
  final String area;
  final String description;
  final String? severity;

  int currentState = 0;


  _ViewModelState({
    required this.dateTime,
    required this.images,
    required this.area,
    required this.description,
    required this.severity,
  });


  _ViewModelState copyWith({
    var dateTime,
    var images,
    var area,
    var description,
    var severity,
  }) {
    return _ViewModelState(
      dateTime: dateTime ?? this.dateTime,
      images: images ?? this.images,
      area: area ?? this.area,
      description: description ?? this.description,
      severity: severity ?? this.severity,
    );
  }

  String? getLastChange(int index) {

    return null;
  }


}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final ObjectId snapshotID;
  final ObjectId injuryID;
  final _injurySnapshot = InjurySnapshotService();

  var _state = _ViewModelState(dateTime: null, images: [], area: '', description: '', severity: '', );
  _ViewModelState get state => _state;

  Future<void> onAddPhotoButtonPressed() async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail/injurySnapshotDetail/addPhoto', arguments: [snapshotID, injuryID]);
  }
  void loadValue() async {
    await _injurySnapshot.initilalize(snapshotID);
    _updateState();
  }

  Future<void> changeState(index) async {
    state.currentState = index;
    print(state.currentState);
    notifyListeners();
  }
  _ViewModel(this.context, this.snapshotID, this.injuryID) {
    loadValue();
  }

  Future<void> onInjurySnapshotImageTap(photo) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail/injurySnapshotDetail/injurySnapshotPaintMask', arguments: photo);
  }

  void _updateState() {
    final injurySnapshot = _injurySnapshot.injurySnapshot;
    _state = _state.copyWith(
      dateTime: injurySnapshot?.datetime,
      images: injurySnapshot?.imageLocalPaths,
      area: injurySnapshot?.area.toString(),
      description: injurySnapshot?.description,
      severity: injurySnapshot?.severity,
    );
    notifyListeners();
  }

  Future<void> removePhotoInjurySnapshot(photo)async {
    _injurySnapshot.deletePhotoFromInjurySnapshot(photo);
  }

  void _showAlertDialog(BuildContext context, photo)async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(S
                .of(context)
                .Attention),
            content: Text(S
                .of(context)
                .DoYouWantToDeleteThePhoto),
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
                  removePhotoInjurySnapshot(photo);
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

  onInjurySnapShotLongPress(photo, BuildContext context)async {

    _showAlertDialog(context, photo);
  }
}


class InjurySnapshotDetailPage extends StatelessWidget {
  const InjurySnapshotDetailPage({Key? key}) : super(key: key);

  static Widget create(snapshotID, injuryID) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, snapshotID, injuryID),
      child: const InjurySnapshotDetailPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime = context.select((_ViewModel vm) =>
    vm.state.dateTime);
    var title = S.of(context).NoInformation;
    if(dateTime != null) title = WorkWithDate.fromDateToString(dateTime, S.of(context).FormatOfDateTime);
    var currentState = context.select((_ViewModel vm) => vm.state.currentState);
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body:  SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  _Swicher(),
                  SizedBox(height: 15),
                  currentState == 0 ? _PhotosWidgets() : _InformationWidgets(),
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
    var currentState = context.select((_ViewModel vm) => vm.state.currentState);
    final viewModel = context.read<_ViewModel>();
    return Container(
      child: CustomSwitch(
          currentState: currentState,
          labels: [S.of(context).Photos, S.of(context).Information],
          onChanged: viewModel.changeState),
    );
  }
}

class _PhotosWidgets extends StatelessWidget {
  const _PhotosWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      _AddInjurySnapshotWidget(),
      SizedBox(height: 20),
      _InjureSnapshotListWidget(),
    ]);
  }
}

class _InformationWidgets extends StatelessWidget {
  const _InformationWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      _SeverityInfoWidget(),
      SizedBox(height: 15),
      _AreaInfoWidget(),
      SizedBox(height: 15),
      _DescriptionInfoWidget(),
      SizedBox(height: 15),

    ]);
  }
}
class _SeverityInfoWidget extends StatelessWidget {
  const _SeverityInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injurySeverity =
    context.select((_ViewModel vm) => vm.state.severity);
    injurySeverity =
    injurySeverity == null || injurySeverity.isEmpty ? S.of(context).NoInformation : injurySeverity;
    return AccountInfoWidget(
        title: S.of(context).Severity, textInfo: injurySeverity);
  }
}

class _AreaInfoWidget extends StatelessWidget {
  const _AreaInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var info =
    context.select((_ViewModel vm) => vm.state.area);
    info =
    info == null || info.isEmpty ? S.of(context).NoInformation : info;
    return AccountInfoWidget(
        title: S.of(context).Severity, textInfo: info);
  }
}

class _DescriptionInfoWidget extends StatelessWidget {
  const _DescriptionInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var info =
    context.select((_ViewModel vm) => vm.state.description);
    info =
    info == null || info.isEmpty ? S.of(context).NoInformation : info;
    return AccountInfoWidget(
        title: S.of(context).Severity, textInfo: info);
  }
}

class _AddInjurySnapshotWidget extends StatelessWidget {
  const _AddInjurySnapshotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return CustomButton(
        onPressed: viewModel.onAddPhotoButtonPressed,
        text: S.of(context).AddAPhoto,
        icon: Icons.add);
  }
}



class _InjureSnapshotListWidget extends StatelessWidget {
  const _InjureSnapshotListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = context.select((_ViewModel vm) => vm.state.images);
    final viewModel = context.read<_ViewModel>();

    return StreamBuilder<RealmResultsChanges<InjurySnapshot>>(
        stream: RealmService.getInjurySnapshotChanges(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) return Container();
          viewModel.loadValue();
          final results = data.results.query('_id == oid(${viewModel.snapshotID})');
          if(results.isEmpty) return const CircularProgressIndicator();
          SyncService.sync();
          images =results.first.imageLocalPaths;

          return ListView.builder(
              reverse: true,
              //scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                      child:
                      GestureDetector(
                          onLongPress: () => viewModel.onInjurySnapShotLongPress(images[index], context),
                          onTap: () => viewModel.onInjurySnapshotImageTap(images[index]),
                          child: Image.file(File(images[index])),
                      )
                  ));
        }

    );
  }
}