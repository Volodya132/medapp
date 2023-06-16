import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/reg_service.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
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
  DateTime dateTimeOfInjury = DateTime.now();
  String area = "";
  String description = "";
  String severity = "";
  List<String> imagePaths = [];

  bool isAddInProcess = false;

  String dateFormat ="yyyy-mm-dd h:mm a";
  TextEditingController dataController = TextEditingController();



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


  void changeTimeOfInjury(DateTime value) {
    if (_state.dateTimeOfInjury == value) return;
    _state.dateTimeOfInjury = value;
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
    final timeOfInjury = _state.dateTimeOfInjury;
    final area = _state.area;
    final description = _state.description;
    final severity = _state.severity;
    final imagePaths = _state.imagePaths;
    //  if (name.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty || phoneNumber.isEmpty) return;

    _state.addErrorTitle = '';
    _state.isAddInProcess = true;
    notifyListeners();

    try {
      _regService.addInjurySnapshot(InjurySnapshot(ObjectId(),
          datetime: timeOfInjury,
          area: double.parse(area),
          description: description,
          severity: severity,
          imageLocalPaths: imagePaths), id);

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

  Future selectDateTime(BuildContext context)async {
    DateTime? pickedDateTime = await WorkWithDate.pickDate(context);
    if(pickedDateTime == null) return;
    state.dateTimeOfInjury = pickedDateTime;
    String formattedDate = DateFormat(_state.dateFormat).format(pickedDateTime);
    _state.dataController.text = formattedDate.toString();
    notifyListeners();
  }

  void setDataFormat(String formatOfDateTime) {
    _state.dateFormat = formatOfDateTime;
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
        appBar: CustomAppBar(title: S
            .of(context)
            .AddRecord),
        body:
        const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
    final dataController =
    context.select((_ViewModel value) => value.state.dataController);
    model.setDataFormat(S.of(context).FormatOfDateTime);
    return InputWidget(
      controller: dataController,
      readOnly: true,
      onTap: () => model.selectDateTime(context),
      hintText: S.of(context).Time,
    );
  }
}

class _AreaWidget extends StatelessWidget {
  const _AreaWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeArea,
      hintText: S.of(context).Area,
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeDescription,
      hintText: S.of(context).Description,
    );
  }
}

class _SeverityWidget extends StatelessWidget {
  const _SeverityWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return InputWidget(
      onChanged: model.changeSeverity,
      hintText: S.of(context).Severity,
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