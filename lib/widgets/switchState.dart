import 'package:flutter/material.dart';

class Switchstate extends StatefulWidget {
  final bool light;
  const Switchstate({super.key, this.light = true});

  @override
  State<Switchstate> createState() => _SwitchstateState();
}

class _SwitchstateState extends State<Switchstate> {
  late bool _isLight;

  @override
  void initState() {
    super.initState();
    _isLight = widget.light;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isLight,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          _isLight = value;
        });
      },
    );
  }
}
