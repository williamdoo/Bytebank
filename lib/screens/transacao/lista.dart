import 'package:bytebank/models/conta.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:bytebank/utils/formatacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _titutoAppBar = 'Transações';

class ListaTransacao extends StatefulWidget {
  final Conta _conta;

  ListaTransacao(this._conta);

  @override
  State<StatefulWidget> createState() {
    return ListaTransacaoState();
  }
}

class ListaTransacaoState extends State<ListaTransacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta ${widget._conta.numeroConta} - $_titutoAppBar'),
      ),
      body: ListView.builder(
        itemCount: widget._conta.transacoes.length,
        itemBuilder: (context, indice) {
          final transacao = widget._conta.transacoes[indice];
          return ItemTransacao(transacao);
        },
      ),
    );
  }
}

class ItemTransacao extends StatelessWidget {
  final Transacao _transacao;

  ItemTransacao(this._transacao);

  @override
  Widget build(BuildContext context) {
    Color colorText = _transacao.valor > 0 ? Colors.blue : Colors.red;
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text('Tipo Transação: ${_transacao.toStringTipoTransacao()}'),
        subtitle: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${Formatacao.toDateTime(_transacao.dataTransacao, 'dd/MM/yyyy HH:mm:ss')}'),
                  Text(
                    '${Formatacao.toMoney(_transacao.valor, '#,##0.00', 'pt-Br')}',
                    style: TextStyle(color: colorText),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(_transacao.transacaoEntreConta
                  ? 'Transferência para conta ${_transacao.transacaoPara}'
                  : _transacao.transacaoDe == ''
                      ? ''
                      : 'Transferência recebida conta ${_transacao.transacaoDe}'),
            )
          ],
        ),
      ),
    );
  }
}
