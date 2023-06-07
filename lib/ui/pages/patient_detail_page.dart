import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/domain/entity/evolutionInjury.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/generated/l10n.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../domain/entity/injury.dart';
import '../../domain/entity/patient.dart';
import '../../domain/services/patient_service.dart';



class _ViewModelState {
  final String patientNameTitle;
  var injuries;


  _ViewModelState({
    required this.patientNameTitle,
    required this.injuries,
  });


  _ViewModelState copyWith({
    String? patientNameTitle,
    var injuries,
  }) {
    return _ViewModelState(
      patientNameTitle: patientNameTitle ?? this.patientNameTitle,
      injuries: injuries ?? this.injuries,

    );
  }

  String? getLastChange(int index) {

    DateTime? result = injuries[index].getLastChange();
    if(result != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyy');
      return formatter.format(result);
    }
    return null;
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final ObjectId id;
  final _patientService = PatientService();

  var _state = _ViewModelState(patientNameTitle: '', injuries: []);
  _ViewModelState get state => _state;

  void loadValue() async {
    await _patientService.initilalize(id);
    _updateState();
  }

  _ViewModel(this.context, this.id) {
    loadValue();
  }


  Future<void> onAddInjuryButtonPressed() async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/addInjury', arguments: id);
  }

  Future<void> onInjuryTap(id) async {
    Navigator.of(context).pushNamed('/patients_page/patientDetail/injuryDetail', arguments: id);
  }
  Future<void> onBackTap() async {
    Navigator.of(context).pop();
  }

  void _updateState() {
    final Patient patient = _patientService.patient!;
    _state = _state.copyWith(
      patientNameTitle: "${patient.lname} ${patient.fname} ${patient.mname} ",
      injuries: patient.currentInjuries,
    );
    notifyListeners();
  }
}

class PatientDetail extends StatelessWidget {
  const PatientDetail({Key? key}) : super(key: key);

  static Widget create(id) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context, id),
      child: const PatientDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF3AB7FF), Color(0xFFA8E7FF), Color(0xFF3AB7FF)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: CustomScrollView(
                slivers: [

                  SliverAppBar(
                    shadowColor: const Color(0xFF3AB7FF),
                    toolbarHeight: 80,
                    expandedHeight: 150,
                    pinned: true,
                    //backgroundColor: Colors.transparent,
                    leading: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: _BackWidget()),
                    flexibleSpace: Container(
                        decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF3AB7FF), Color(0xFFA8E7FF), Color(0xFF3AB7FF)]))
                    ),
                    bottom: PreferredSize(
                        preferredSize: Size.zero,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              children: const [
                                _WelcomeWidget()
                              ],
                            ))

                    ),),

                  SliverToBoxAdapter(
                      child: Container(

                          constraints:  BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [

                                _AddPatientWidget(),
                                SizedBox(height: 15),
                                _InjuriesListWidget(),
                              ],
                            ),
                          ))),
                ])
        ),
      ),
    );
  }
}

class _BackWidget extends StatelessWidget {
  const _BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return IconButton(onPressed: viewModel.onBackTap, icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,));

  }
}

class _WelcomeWidget extends StatelessWidget {
  const _WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) =>
    vm.state.patientNameTitle);
    return
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34
          ),
        ),
      );
  }

}

class _AddPatientWidget extends StatelessWidget {
  const _AddPatientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return CustomButton(
        onPressed: viewModel.onAddInjuryButtonPressed,
        text: S.of(context).Add,
        icon: Icons.add);
  }
}


class _InjuriesListWidget extends StatelessWidget {
  const _InjuriesListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var injuries = context.select((_ViewModel vm) => vm.state.injuries);
    final viewModel = context.read<_ViewModel>();
    return StreamBuilder<RealmResultsChanges<Injury>>(
        stream: RealmService.getInjuriesChanges(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) return Container();
          //final results = data.results;
          viewModel.loadValue();
          injuries = viewModel.state.injuries;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: injuries.length,
              itemBuilder: (context, index) =>
                  Card( //                           <-- Card widget
                    child:
                    ListTile(
                      title: Text(injuries[index]?.type ?? "No label"),
                      subtitle: Text('${S
                          .of(context)
                          .LastChange}: ${S
                          .of(context)
                          .NoInformation}'),
                      onTap: () => viewModel.onInjuryTap(injuries[index]?.id),
                    ),
                  ));
        }
    );
  }
}