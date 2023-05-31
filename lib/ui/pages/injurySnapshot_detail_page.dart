import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/injurySnapshot_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';



class _ViewModelState {
  final String dateTime;
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
  final ObjectId id;
  final _injurySnapshot = InjurySnapshotService();

  var _state = _ViewModelState(dateTime: '', images: [], area: '', description: '', severity: '', );
  _ViewModelState get state => _state;

  void loadValue() async {
    await _injurySnapshot.initilalize(id);
    _updateState();
  }

  _ViewModel(this.context, this.id) {
    loadValue();
  }

  Future<void> onInjurySnapshotImageTap(photo) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail/injurySnapshotDetail/injurySnapshotPaintMask', arguments: photo);
  }

  void _updateState() {
    final injurySnapshot = _injurySnapshot.injurySnapshot;
    _state = _state.copyWith(
      dateTime: injurySnapshot?.datetime.toString(),
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

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, id),
      child: const InjurySnapshotDetailPage(),
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
                children: const [
                  _WelcomeWidget(),
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


class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final title = "${S.of(context).Hello} ${context.select((_ViewModel vm) => vm.state.dateTime)}";
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