import 'package:bytebank/components/botao_selecao.dart';
import 'package:bytebank/components/caixa_mensagem.dart';
import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/conta.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:bytebank/utils/formatacao.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _tituloAppBar = 'Nova Transação';
const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0,00';
const _textoBotaoConfirmar = 'Confimar';

class FormularioTransacao extends StatefulWidget {
  final Conta _conta;
  final List<Conta> _contas;

  FormularioTransacao(this._conta, this._contas);

  State<StatefulWidget> createState() {
    return FormularioTransacaoState();
  }
}

class FormularioTransacaoState extends State<FormularioTransacao> {
  final TextEditingController _controladorCampoValor = TextEditingController();
  final List<bool> _selecao = List.generate(2, (index) => false);

  String indicacaoTransacao = '';
  String dropdownValor = 'Contas';

  bool transacaoEntreContas = false;
  bool visivelCkTransacao = false;
  bool visivelDropdownContas = false;

  @override
  Widget build(BuildContext context) {
    final Color colorSaldo =
        widget._conta.saldoTotal() > 0 ? Colors.blue : Colors.red;
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta ${widget._conta.numeroConta} - $_tituloAppBar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Tipo de transação',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                BotaoSelecao(
                  selecao: _selecao,
                  child: [
                    Text('R\$'),
                    Text('-R\$'),
                  ],
                  aoPressionar: (index) {
                    setState(() {
                      for (int i = 0; i < _selecao.length; i++) {
                        _selecao[i] = false;
                      }
                      _selecao[index] = !_selecao[index];

                      indicacaoTransacao =
                          _selecao[0] ? 'Crédito na conta' : 'Débito na conta';

                      if (widget._contas.any((element) =>
                          element.numeroConta != widget._conta.numeroConta)) {
                        visivelCkTransacao = _selecao[1];
                        transacaoEntreContas = false;
                        if (!transacaoEntreContas) {
                          visivelDropdownContas = false;
                          dropdownValor = 'Contas';
                        }
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Text(
                    indicacaoTransacao,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
            Editor(
              controlador: _controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              formato: [
                CurrencyTextInputFormatter(
                  locale: 'pt-BR',
                  symbol: 'R\$',
                )
              ],
              icone: Icons.monetization_on,
            ),
            Visibility(
              visible: visivelCkTransacao,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Transferência entre contas'),
                value: transacaoEntreContas,
                onChanged: (value) {
                  setState(() {
                    transacaoEntreContas = value;
                    visivelDropdownContas = value;
                  });
                },
              ),
            ),
            Visibility(
              visible: visivelDropdownContas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Visibility(
                      visible: true,
                      child: DropdownButton(
                          value: dropdownValor,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.blueGrey[800],
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 40,
                          underline: SizedBox(),
                          items: dropListaContas(widget._contas),
                          onChanged: (value) {
                            setState(() {
                              dropdownValor = value;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () => _criaTransferencia(context),
              child: Text(_textoBotaoConfirmar),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Saldo total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${Formatacao.toMoney(widget._conta.saldoTotal(), '#,##0.00', 'pt-Br')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorSaldo,
                    ),
                  )
                ],
              ),
            ),
          ),
          height: 50.0,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> dropListaContas(List<Conta> contas) {
    List<DropdownMenuItem<String>> dropdownMenuItem = contas
        .where((element) => element.numeroConta != widget._conta.numeroConta)
        .map<DropdownMenuItem<String>>((e) {
      return DropdownMenuItem<String>(
        value: e.numeroConta,
        child: Text(e.numeroConta),
      );
    }).toList();

    dropdownMenuItem.insert(
        0, DropdownMenuItem<String>(value: 'Contas', child: Text('Contas')));

    return dropdownMenuItem;
  }

  void _criaTransferencia(BuildContext context) {
    final double valor = Formatacao.toDouble(_controladorCampoValor.text);
    final TipoTrasacao tipoTrasacao = _selecao[0]
        ? TipoTrasacao.credito
        : _selecao[1]
            ? TipoTrasacao.debito
            : null;
    String transacaoDe = widget._conta.numeroConta;
    String transacaoPara = dropdownValor;

    if (validar(context)) {
      if (!transacaoEntreContas) {
        transacaoDe = '';
        transacaoPara = '';
      }

      final transferenciaCriada = Transacao(valor, tipoTrasacao,
          transacaoEntreContas, transacaoDe, transacaoPara);
      Navigator.pop(context, transferenciaCriada);
    }
  }

  bool validar(BuildContext context) {
    final double valor = Formatacao.toDouble(_controladorCampoValor.text);
    final TipoTrasacao tipoTrasacao = _selecao[0]
        ? TipoTrasacao.credito
        : _selecao[1]
            ? TipoTrasacao.debito
            : null;

    if (tipoTrasacao == null) {
      CaixaMensagem(context).abrir('Atenção', 'Informe o tipo de transação.', [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        )
      ]);
      return false;
    }

    if (valor == null || valor == 0) {
      CaixaMensagem(context).abrir('Atenção', 'Informe o valor.', [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        )
      ]);

      return false;
    }

    if (transacaoEntreContas) {
      if (dropdownValor == 'Contas') {
        CaixaMensagem(context)
            .abrir('Atenção', 'Selecione a conta para transferêcia', [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ]);
        return false;
      }
    }

    return true;
  }
}
