import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../helper/inputConstants.dart';
import '../navigation/main_navigation.dart';
import 'package:http/http.dart' as http;
enum _ViewModelAddButtonState { canSubmit, addProcess, disable }

class _ViewModelState {
  String addErrorTitle = '';
  String timeOfInjury = "";
  String area = "";
  String description = "";
  String severity = "";
  List<String> imagePaths = [];

  bool isAddInProcess = false;

  _ViewModelAddButtonState get authButtonState {
    if (isAddInProcess) {
      return _ViewModelAddButtonState.addProcess;
    } else if (area.isNotEmpty) {
      return _ViewModelAddButtonState.canSubmit;
    } else {
      return _ViewModelAddButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final ObjectId id;
  final _regService = RegService();
  final _state = _ViewModelState();

  _ViewModel(this.id);
  _ViewModelState get state => _state;


  void changeTimeOfInjury(String value) {
    if (_state.timeOfInjury == value) return;
    _state.timeOfInjury = value;
    notifyListeners();
  }

  void changeArea(String value) {
    if (_state.area == value) return;
    _state.area = value;
    notifyListeners();
  }

  void changeDescription(String value) {
    if (_state.description == value) return;
    _state.description = value;
    notifyListeners();
  }
  void changeSeverity(String value) {
    if (_state.severity == value) return;
    _state.severity = value;
    notifyListeners();
  }




  Future<void> onAddButtonPressed(BuildContext context) async {
    final timeOfInjury = _state.timeOfInjury;
    final area = _state.area;
    final description = _state.description;
    final severity = _state.severity;
    final imagePaths = _state.imagePaths;
    //  if (name.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty || phoneNumber.isEmpty) return;
    print(timeOfInjury +"\n"+ area+"\n"+  description+"\n"+  severity+"\n");
    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    try {
      _regService.addInjurySnapshot(timeOfInjury, imagePaths, area, description, severity, id);


      _state.isAddInProcess = false;
      //якийсь месджбокс мб
      notifyListeners();
      Navigator.of(context).pop();

    } catch (exeption) {
      print(exeption);
      _state.addErrorTitle =
          S.of(context).ServiceError;
      _state.isAddInProcess = false;
      notifyListeners();
    }
  }

  Future<void> onPickImagesButtonPressed() async {
    print("Привіт");
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

class AddInjurySnapshotWidget extends StatelessWidget {
  const AddInjurySnapshotWidget({Key? key}) : super(key: key);

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(id),
      child: const AddInjurySnapshotWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ErrorTitleWidget(),
              SizedBox(height: 10),
              _TimeOfInjuryWidget(),
              SizedBox(height: 10),
              _AreaWidget(),
              SizedBox(height: 10),
              _SeverityWidget(),
              SizedBox(height: 10),
              _DescriptionWidget(),
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



class _TimeOfInjuryWidget extends StatelessWidget {
  const _TimeOfInjuryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.insert_chart_outlined_rounded),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Time,
          fillColor: inputColor),
      onChanged: model.changeTimeOfInjury,
    );
  }
}

class _AreaWidget extends StatelessWidget {
  const _AreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.insert_chart_outlined_rounded),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Area,
          fillColor: inputColor),
      onChanged: model.changeArea,
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.insert_chart_outlined_rounded),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Description,
          fillColor: inputColor),
      onChanged: model.changeDescription,
    );
  }
}

class _SeverityWidget extends StatelessWidget {
  const _SeverityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.insert_chart_outlined_rounded),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: S
              .of(context)
              .Severity,
          fillColor: inputColor),
      onChanged: model.changeSeverity,
    );
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
          Container( //                           <-- Card widget
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