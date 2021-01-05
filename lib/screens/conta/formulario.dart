import 'package:bytebank/components/caixa_mensagem.dart';
import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/conta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormularioConta extends StatefulWidget {
  final List<Conta> _contas;
  FormularioConta(this._contas);
  @override
  State<StatefulWidget> createState() {
    return FormularioContaState();
  }
}

class FormularioContaState extends State<FormularioConta> {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova conta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroConta,
              dica: '00000-0',
              rotulo: 'Número da conta',
              maximoCaracteres: 7,
            ),
            RaisedButton(
              child: Text('Criar'),
              onPressed: () => _criarConta(context),
            )
          ],
        ),
      ),
    );
  }

  void _criarConta(BuildContext context) {
    final String numeroConta = _controladorCampoNumeroConta.text;
    if (validar(context)) {
      final Conta novaConta = Conta(numeroConta);
      Navigator.pop(context, novaConta);
    }
  }

  bool validar(BuildContext context) {
    final String numeroConta = _controladorCampoNumeroConta.text;
    bool resultado = true;

    if (numeroConta == null || numeroConta == '') {
      CaixaMensagem(context).abrir('Atenção', 'Informe o número da conta', [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ]);
      resultado = false;
    }

    if (widget._contas.any((element) => element.numeroConta == numeroConta)) {
      CaixaMensagem(context).abrir('Atenção', 'Número de conta já existe.', [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ]);
      resultado = false;
    }

    return resultado;
  }
}
