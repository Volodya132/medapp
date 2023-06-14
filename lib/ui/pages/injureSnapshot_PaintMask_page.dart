import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:finger_painter/finger_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medapp/domain/entity/injurySnapshot.dart';
import 'package:medapp/domain/services/injurySnapshot_service.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/widgets/CustomSnagBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';
import '../helper/buttonConstants.dart';
import '../helper/theme.dart';
import '../widgets/CustomAppBar.dart';
import "package:image/image.dart" as IMG;

enum _PaintState { black, white, erase}

class _ViewModelState {
  PainterController painterController;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool sizeActive = false;
  _PaintState paintState = _PaintState.black;
  double brushSize = 10.0;
  bool isInteractive = false;
  bool isMove = false;

  final GlobalKey painterContainerKey = GlobalKey();

  _ViewModelState(this.painterController) {
    painterController.setMaxStrokeWidth(brushSize);
    painterController.setMinStrokeWidth(brushSize);
    painterController.setBlendMode(BlendMode.srcOver);
    painterController.clearContent();
  }



}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final String photo;

  final _state = _ViewModelState(PainterController());

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

  Future<void> changeDrawAndMoveState() async {
    state.isMove = !state.isMove;
    if(state.isMove){
      state.painterController.setStrokeColor(Colors.transparent);
    }
    else{
      updateColor();
    }
    notifyListeners();
  }
  Future<void> onInteractiveStart() async {

  }

  Future<void> onInteractiveEnd() async {

  }

  Future<void> onAddCleanButtonPressed() async {
    state.painterController.clearContent();
    notifyListeners();
  }
  Icon getIconByState() {
    if(state.paintState == _PaintState.black) {
      return const Icon(Icons.circle_rounded);
    }
    if(state.paintState == _PaintState.white) {
      return const Icon(Icons.circle_outlined);
    }
    return Icon(MdiIcons.eraser);

  }
  Future<void> updateBrushSize() async {
    _state.painterController.setMinStrokeWidth(_state.brushSize);
    _state.painterController.setMaxStrokeWidth(_state.brushSize);
    notifyListeners();
  }
  Future<void> pickStroke() async {
    final selectedBrushSize = await showDialog<double>(
      context: context,
      builder: (context) =>
          BrushSizePickerDialog(initialBrushSize: _state.brushSize),
    );



    if (selectedBrushSize != null) {
        _state.brushSize = selectedBrushSize;
        updateBrushSize();
    }
    notifyListeners();
  }
  Future<void> updateColor() async {
    if(_state.paintState == _PaintState.black) {
      _state.painterController.setBlendMode(BlendMode.srcOver);
      _state.painterController.setStrokeColor(Colors.black);
    }
    else if(_state.paintState == _PaintState.white) {
      _state.painterController.setBlendMode(BlendMode.srcOver);
      _state.painterController.setStrokeColor(Color.fromARGB(100, 23, 23, 23));

    }
    else {
      _state.painterController.setBlendMode(BlendMode.dstOut);
      _state.painterController.setStrokeColor(Colors.black);
    }
    notifyListeners();
  }
  Future<void> changeColor() async {
    if(_state.paintState == _PaintState.black) {
      state.paintState = _PaintState.white;
    }
    else if(_state.paintState == _PaintState.white) {
      state.paintState = _PaintState.erase;
    }
    else {
      state.paintState = _PaintState.black;
    }

    updateColor();
    notifyListeners();
  }

  Future<void> onSaveImage()async {
    Uint8List? bytes = state.painterController.getImageBytes();
    if(bytes != null) {
      final filename = await saveImage(bytes);
      CustomSnackBar.show(context, S.of(context).TheMaskIsSaved, actionLabel: "OK", onAction: ()=>{});
    }

  }
  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();

    final time = DateTime.now().toIso8601String().
    replaceAll('.', '-').
    replaceAll(':', '-');
    final name = 'mask_$time';

    final res = await ImageGallerySaver.saveImage(bytes, name: name);
    return res['filePath'];
  }
  Uint8List? resizeImage(Uint8List data, newWidth, newHeight) {
    Uint8List resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    if(img == null){
      return null;
    }
    IMG.Image resized = IMG.copyResize(img, width: newWidth, height: newHeight);
    resizedData = IMG.encodeJpg(resized);
    return resizedData;
  }

    Size? _getContainerSize() {
    final renderBox = state.painterContainerKey.currentContext?.findRenderObject()  as RenderBox?;
    if(renderBox == null) {
      return null;
    }
    final containerSize = renderBox.size;
    return containerSize;
  }
  Future<void> onFileOpen()async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    String? filepath = result.files.single.path;
    if(filepath == null) {
      return;
    }
    File file = File(filepath);

    ui.Size? contSize = _getContainerSize();
    if(contSize == null) {
      return;
    }
    var bytes = resizeImage(await file.readAsBytes(), contSize.width.round(), contSize.height.round());
    if(bytes == null) {
      return;
    }
    state.painterController.setBackgroundImage(bytes);
  }

  Future saveAndShare() async{
    Uint8List? bytes = state.painterController.getImageBytes();
    if(bytes == null) {
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/temp_mask.png');
    image.writeAsBytesSync(bytes);
    await Share.shareXFiles([XFile(image.path)]);
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
      appBar: CustomAppBar(title: S.of(context).MaskPainting),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:  const Padding(
        padding:  EdgeInsets.only(bottom: 20),
        child: _CustomSpeedDial(),


      ),
      body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:   [
                 // RegButtonWidget(),
                  _ToolPanel(),
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
    final painterController = context.select((_ViewModel vm) =>
    vm.state.painterController);
    final isMove = context.select((_ViewModel vm) => vm.state.isMove);
    final painterContainerKey = context.select((_ViewModel vm) =>
    vm.state.painterContainerKey);
    return InteractiveViewer(
        scaleEnabled: isMove,
        panEnabled: isMove,
        onInteractionStart: (ScaleStartDetails) =>
        {
          viewModel.onInteractiveStart()
        },
        onInteractionEnd: (ScaleEndDetails) =>
        {
          viewModel.onInteractiveEnd()
        },
        minScale: 0.1,
        maxScale: 2,
        child: Container(
          key: painterContainerKey,
          child: Painter(
              controller: painterController,
              //size: const Size(300, 300),
              child: Image.file(File(viewModel.photo))

          ),)
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


class _CustomSpeedDial extends StatelessWidget {
  const _CustomSpeedDial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final isDialOpen =
    context.select((_ViewModel value) => value.state.isDialOpen);
    final paintState =
    context.select((_ViewModel value) => value.state.paintState);
    return SpeedDial(
        icon: Icons.settings_sharp,
        backgroundColor: COLOR_ACCENT,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.save_rounded),
              onTap: () async {
                model.onSaveImage();
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.folder_rounded),
              onTap: () async {
                model.onFileOpen();
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.share),
              onTap: () async {
                model.saveAndShare();
              }
          ),

        ]);
  }
}


class BrushSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialBrushSize;

  const BrushSizePickerDialog({Key? key, required this.initialBrushSize}) : super(key: key);

  @override
  _BrushSizePickerDialogState createState() => _BrushSizePickerDialogState();
}

class _BrushSizePickerDialogState extends State<BrushSizePickerDialog> {
  /// current selection of the slider
  double _brushSize = 0;

  @override
  void initState() {
    super.initState();
    _brushSize = widget.initialBrushSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FloatingActionButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _brushSize);
          },
          child: Text('OK'),
        )
      ],
      title: Text(S.of(context).BrushSize),
      content: Container(
        height: 100,
        child: Slider(
          value: _brushSize,
          min: 1,
          max: 40,
          onChanged: (value) {
            setState(() {
              _brushSize = value;
            });
          },
        ),
      ),
    );
  }
}

class _ToolPanel extends StatelessWidget {
  const _ToolPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    const iconSize = 35.0;
    final isMove =
    context.select((_ViewModel value) => value.state.isMove);
    final  paintState=
    context.select((_ViewModel value) => value.state.paintState);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            iconSize: iconSize,
            onPressed: model.changeDrawAndMoveState,
            icon: isMove
                ? const Icon(Icons.zoom_in_map_rounded)
                : const Icon(Icons.brush_rounded),
        ),
        IconButton(
          color: Colors.black,
          iconSize: iconSize,
          onPressed: model.changeColor,
          icon: model.getIconByState()
        ),
        IconButton(
            iconSize: iconSize,
            onPressed: model.pickStroke,
            icon: const Icon(Icons.line_weight_rounded)
        ),
        IconButton(
          iconSize: iconSize,
          onPressed: () => {},
          icon: Icon(MdiIcons.autoFix),
        ),

      ],
    );
  }
}