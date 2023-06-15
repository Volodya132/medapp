import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/injurySnapshot_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/widgets/WorkWithDate.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';
import '../widgets/CusomButton.dart';
import '../widgets/CustomAppBar.dart';



class _ViewModelState {
  final DateTime? dateTime;
  final List<String> images;
  final String area;
  final String description;
  final String? severity;



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
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  _AddInjurySnapshotWidget(),
                  SizedBox(height: 20),
                  _InjureSnapshotListWidget(),
                ],
              ),
            ),
          )
      ),
    );
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
          final results = data.results;
          viewModel.loadValue();
          images = viewModel.state.images;
          print(images);
          return ListView.builder(
              //scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                      child:
                      GestureDetector(
                          onTap: () => viewModel.onInjurySnapshotImageTap(images[index]),
                          child: Image.file(File(images[index])),
                      )
                  ));
        }

    );
  }
}