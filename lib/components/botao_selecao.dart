import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotaoSelecao extends StatelessWidget {
  final List<bool> selecao;
  final List<Widget> child;
  final Function(int) aoPressionar;

  BotaoSelecao({this.child, this.selecao, this.aoPressionar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
          child: ToggleButtons(
            children: child,
            isSelected: selecao,
            onPressed: aoPressionar,
          ),
        ),
      ],
    );
  }
}
