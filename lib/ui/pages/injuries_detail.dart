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



class _ViewModelState {
  final String injuryNameTitle;
  List<InjurySnapshot?> injurySnapshots;


  _ViewModelState({
    required this.injuryNameTitle,
    required this.injurySnapshots,
  });


  _ViewModelState copyWith({
    String? injuryNameTitle,
    var injurySnapshots,
  }) {
    return _ViewModelState(
      injuryNameTitle: injuryNameTitle ?? this.injuryNameTitle,
      injurySnapshots: injurySnapshots ?? this.injurySnapshots,

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

  var _state = _ViewModelState(injuryNameTitle: '', injurySnapshots: []);
  _ViewModelState get state => _state;

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

  void _updateState() {
    final Injury injury = _injuryService.injury!;

    _state = _state.copyWith(
      injuryNameTitle: injury.type,
      injurySnapshots: injury.injurySnapshot,
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
                  SizedBox(height: 25),
                  _AddInjurySnapshotWidget(),
                  SizedBox(height: 15),
                  _InjurySnapshotsListWidget(),
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
          final results = data.results;
          viewModel.loadValue();
          injurySnapshot = viewModel.state.injurySnapshots;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: injurySnapshot.length,
              itemBuilder: (context, index) =>
                  GestureDetector(
                      onTap: () => viewModel.onInjurySnapshotImageTap(injurySnapshot[index]?.id),
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
                                        injurySnapshot[index]),
                                    fit: BoxFit.fill,
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
                                      Text(injurySnapshot[index]?.id
                                          .toString() ?? "Null"),
                                      Text('${S
                                          .of(context)
                                          .LastChange}: ${S
                                          .of(context)
                                          .NoInformation}')
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