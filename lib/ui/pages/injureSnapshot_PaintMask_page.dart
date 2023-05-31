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



class _ViewModelState {
  var painterController;
  _ViewModelState(painterController) {
    painterController.clearContent();
  }



}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final String photo;

  final _state = _ViewModelState( PainterController()
    ..setPenType(PenType.pencil)
    ..setStrokeColor(Colors.orange)
    ..setMinStrokeWidth(3)
    ..setMaxStrokeWidth(10)
    ..setBlurSigma(0.0)
    ..setBlendMode(ui.BlendMode.srcOver)
    ..clearContent());

  _ViewModelState get state => _state;

  _ViewModel(this.context, this.photo) {
  }


  @override
  void dispose() {
    super.dispose();
  }
  void _updateState() {
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
                children:  [
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


class _PainterWidget extends StatefulWidget {
  var painterController;
   _PainterWidget({
    Key? key,
  }) : super(key: key);


  @override
  State<_PainterWidget> createState() => _PainterWidgetState();


}

class _PainterWidgetState extends State<_PainterWidget> {

  @override
  void initState() {
    super.initState();
    widget.painterController = PainterController()
      ..setPenType(PenType.pencil)
      ..setStrokeColor(Colors.black)
      ..setMinStrokeWidth(3)
      ..setMaxStrokeWidth(10)
      ..setBlurSigma(0.0)
      ..setBlendMode(ui.BlendMode.srcOver);
    widget.painterController.clearContent();

  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    //final painterController = context.select((_ViewModel vm) => vm.state.painterController);

    return Container(
      child: Painter(

          controller: widget.painterController,
          //backgroundColor: Colors.green.withOpacity(0.4),
          //size: const Size(300, 300),
          child: Image.file(File(viewModel.photo))

      ),
    );

  }
}

