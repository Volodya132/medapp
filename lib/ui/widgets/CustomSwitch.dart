import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomSwitch extends StatelessWidget {
  final int currentState;
  final List<String> labels;
  final ValueChanged<int?>? onChanged;
  const CustomSwitch({super.key, this.currentState = 0, required this.labels, this.onChanged});



  @override
  Widget build(BuildContext context) {

    return Container(
      child: ToggleSwitch(
        fontSize: 22,
        minWidth: 170,
        activeBgColors: const [[Color(0xff6ae11e)],[Color(0xff6ae11e)] ],
        activeFgColor: Colors.black,
        customTextStyles: const [TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold)],
        animate: true,
        animationDuration: 300,
        initialLabelIndex: currentState,
        totalSwitches: 2,
        labels: labels,
        onToggle: onChanged,
      ),
    );
  }
}