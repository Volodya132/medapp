import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/services/injurySnapshot_service.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../helper/inputConstants.dart';
import '../navigation/main_navigation.dart';
import 'package:http/http.dart' as http;

import '../widgets/CustomAppBar.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/WorkWithDate.dart';
enum _ViewModelAddButtonState { canSubmit, addProcess, disable }

class _ViewModelState {
  String addErrorTitle = '';
  List<String> imagePaths = [];

  bool isAddInProcess = false;


  _ViewModelAddButtonState get authButtonState {
    if (isAddInProcess) {
      return _ViewModelAddButtonState.addProcess;
    } else if (imagePaths.isNotEmpty) {
      return _ViewModelAddButtonState.canSubmit;
    } else {
      return _ViewModelAddButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final ObjectId snapshotID;
  final ObjectId injuryID;
  final _injurySnapshotService = InjurySnapshotService();
  final _state = _ViewModelState();

  _ViewModel(this.snapshotID, this.injuryID);
  _ViewModelState get state => _state;




  Future<void> onAddButtonPressed(BuildContext context) async {

    final imagePaths = _state.imagePaths;
    //  if (name.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty || phoneNumber.isEmpty) return;

    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    try {
      _injurySnapshotService.addPhotos(imagePaths, injuryID, snapshotID );

      _state.isAddInProcess = false;
      //якийсь месджбокс мб


      Navigator.of(context).pop();
      notifyListeners();

    } catch (exeption) {
      print(exeption);
      _state.addErrorTitle =
          S.of(context).ServiceError;
      _state.isAddInProcess = false;
      notifyListeners();
    }
  }

  Future<void> onPickImagesButtonPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for(String? file in result.paths) {
        if(file != null) {
          _state.imagePaths.add(file);
        }
      }
      //_state.imagePaths = paths;

    } else {
      // User canceled the picker
    }
    notifyListeners();
  }


}

class InjurySnapshotDetailAddPhotosPage extends StatelessWidget {
  const InjurySnapshotDetailAddPhotosPage({Key? key}) : super(key: key);

  static Widget create(snapshotID, injuryID) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(snapshotID, injuryID),
      child: const InjurySnapshotDetailAddPhotosPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: S
            .of(context)
            .AddRecord),
        body:
        const SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ErrorTitleWidget(),
                  SizedBox(height: 10),
                  _ImagesWidget(),
                  SizedBox(height: 10),
                  _PickImagesButtonWidget(),
                  SizedBox(height: 10),
                  _AddButtonWidget(),
                ],
              ),
            ),
          ),
        ));
  }
}







class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
    context.select((_ViewModel value) => value.state.addErrorTitle);
    return Text(authErrorTitle);
  }
}

class _AddButtonWidget extends StatelessWidget {
  const _AddButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState = context.select((_ViewModel value) =>
    value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAddButtonState.canSubmit
        ? model.onAddButtonPressed
        : null;

    final child = authButtonState == _ViewModelAddButtonState.addProcess
        ? const CircularProgressIndicator()
        : Text(S
        .of(context)
        .Add);
    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}

class _ImagesWidget extends StatelessWidget {
  const _ImagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePathsLen = context.select((_ViewModel value) =>
    value.state.imagePaths.length);
    final imagePaths = context.select((_ViewModel value) =>
    value.state.imagePaths);
    return imagePaths.isEmpty
        ? Container()
        : SizedBox(
        height: 100,
        child: ListView.builder(

          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) =>
              Card( //                           <-- Card widget
                  child: Image.file(File(imagePaths[index]))
              ),
        ));
  }
}

class _PickImagesButtonWidget extends StatelessWidget {
  const _PickImagesButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    return ElevatedButton(
      onPressed: model.onPickImagesButtonPressed,
      child: Text("${S
          .of(context)
          .Add} image"),
    );
  }
}