import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final int maximoCaracteres;
  final List<TextInputFormatter> formato;

  const Editor(
      {this.controlador,
      this.rotulo,
      this.formato,
      this.dica,
      this.icone,
      this.maximoCaracteres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
          counter: Offstage(),
        ),
        inputFormatters: formato,
        keyboardType: TextInputType.number,
        maxLength: maximoCaracteres,
      ),
    );
  }
}
