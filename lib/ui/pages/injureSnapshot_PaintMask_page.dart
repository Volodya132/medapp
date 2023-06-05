import 'dart:io';
import 'dart:ui' as ui;
import 'package:finger_painter/finger_painter.dart';
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
import '../helper/buttonConstants.dart';



class _ViewModelState {
  PainterController painterController;
  _ViewModelState(this.painterController) {
    painterController.clearContent();
  }



}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final String photo;

  final _state = _ViewModelState( PainterController());

  _ViewModelState get state => _state;

  _ViewModel(this.context, this.photo) {
  }


  @override
  void dispose() {
    state.painterController.clearContent();
    super.dispose();
  }
  void _updateState() {
  }

  Future<void> onAddCleanButtonPressed() async {
    state.painterController.clearContent();

  }

}

class InjurySnapshotPaintMaskPage extends StatelessWidget {
  const InjurySnapshotPaintMaskPage({Key? key}) : super(key: key);

  static Widget create(photo) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, photo),
      child: const InjurySnapshotPaintMaskPage(),
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
                children:  const[
                  RegButtonWidget(),
                  _PainterWidget(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class _PainterWidget extends StatelessWidget {
  const _PainterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    final painterController = context.select((_ViewModel vm) => vm.state.painterController);

    return Container(
      child: Painter(

          controller: painterController,
          //size: const Size(300, 300),
          child: Image.file(File(viewModel.photo))

      ),
    );
  }
}

class RegButtonWidget extends StatelessWidget {
  const RegButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    final child = Text('delete');
    return ElevatedButton(
      onPressed: model.onAddCleanButtonPressed,
      child: child,
    );
  }
}