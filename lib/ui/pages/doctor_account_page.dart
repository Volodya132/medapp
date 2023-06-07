import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/domain/services/realmService.dart';
import 'package:medapp/ui/helper/inputConstants.dart';
import 'package:medapp/ui/widgets/CusomButton.dart';
import 'package:medapp/ui/widgets/CustomAppBar.dart';
import 'package:provider/provider.dart';

import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/services/auth_service.dart';

import '../../generated/l10n.dart';
import '../helper/buttonConstants.dart';
import '../navigation/main_navigation.dart';
enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {

}

class DoctorAccountWidget extends StatelessWidget {
  const DoctorAccountWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const DoctorAccountWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [

              ],
            ),
          ),
        ),
      ),
    );
  }
}


