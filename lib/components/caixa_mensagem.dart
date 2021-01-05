import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaixaMensagem {
  final BuildContext _context;

  CaixaMensagem(this._context);

  Future<AlertDialog> abrir(
      String titulo, String mensagem, List<TextButton> botoes) async {
    return showDialog<AlertDialog>(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(mensagem)],
              ),
            ),
            actions: botoes,
          );
        });
  }
}
