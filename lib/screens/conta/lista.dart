import 'package:bytebank/components/caixa_mensagem.dart';
import 'package:bytebank/models/conta.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:bytebank/screens/conta/formulario.dart';
import 'package:bytebank/screens/transacao/formulario.dart';
import 'package:bytebank/screens/transacao/lista.dart';
import 'package:bytebank/utils/formatacao.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaConta extends StatefulWidget {
  final List<Conta> _contas = List();
  @override
  State<StatefulWidget> createState() {
    return ListaContaState();
  }
}

class ListaContaState extends State<ListaConta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contas'),
      ),
      body: ListView.builder(
          itemCount: widget._contas.length,
          itemBuilder: (context, index) {
            final conta = widget._contas[index];
            return Dismissible(
                key: Key(conta.hashCode.toString()),
                background: Container(color: Colors.blueGrey[100]),
                direction: DismissDirection.startToEnd,
                child: ItemConta(conta, widget._contas, () {
                  setState(() {
                    widget._contas.remove(conta);
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Conta ${conta.numeroConta} removido'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        setState(() {
                          widget._contas.add(conta);
                        });
                      },
                    ),
                  ));
                }, (transacaoRecebida) {
                  setState(() {
                    widget._contas
                        .firstWhere((element) =>
                            element.numeroConta ==
                            transacaoRecebida.transacaoPara)
                        .adicionarTransferencia(transacaoRecebida);
                  });
                }),
                onDismissed: (direction) {
                  setState(() {
                    widget._contas.remove(conta);
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Conta ${conta.numeroConta} removido'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        setState(() {
                          widget._contas.add(conta);
                        });
                      },
                    ),
                  ));
                });
          }),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormularioConta(
              context,
              widget._contas,
              (Conta contaRecebida) => {
                    setState(() {
                      widget._contas.add(contaRecebida);
                    })
                  });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ItemConta extends StatefulWidget {
  final Conta _conta;
  final List<Conta> _contas;
  final Function callBackRemover;
  final Function callBackTransferencia;

  ItemConta(this._conta, this._contas, this.callBackRemover,
      this.callBackTransferencia);

  @override
  State<StatefulWidget> createState() {
    return ItemContaState(callBackRemover, callBackTransferencia);
  }
}

class ItemContaState extends State<ItemConta> {
  final Function callBackRemover;
  final Function callBackTransferencia;

  ItemContaState(this.callBackRemover, this.callBackTransferencia);

  @override
  Widget build(BuildContext context) {
    final Color colorSaldo =
        widget._conta.saldoTotal() > 0 ? Colors.blue : Colors.red;
    return Card(
      child: ListTile(
          title: Text('Número conta: ${widget._conta.numeroConta}'),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Saldo total'),
              Text(
                '${Formatacao.toMoney(widget._conta.saldoTotal(), '#,##0.00', 'pt-Br')}',
                style: TextStyle(
                  color: colorSaldo,
                ),
              ),
            ],
          ),
          onTap: () {
            _abrirListaTrasacao(context, widget._conta);
          },
          trailing: PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'trasacao':
                  _abrirFormularioTrasacao(
                      context,
                      widget._conta,
                      widget._contas,
                      (Transacao transacaoRecebida) => {
                            setState(() {
                              widget._conta
                                  .adicionarTransacao(transacaoRecebida);
                              if (transacaoRecebida.transacaoEntreConta) {
                                callBackTransferencia(transacaoRecebida);
                              }
                            })
                          });
                  break;
                case 'apagar':
                  apagar(context, () {
                    callBackRemover();
                  });
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'trasacao',
                child: Text('Nova trasação'),
              ),
              PopupMenuItem(
                value: 'apagar',
                child: Text('Apagar conta'),
              ),
            ],
          )),
    );
  }
}

void _abrirFormularioConta(
    BuildContext context, List<Conta> contas, Function callback) {
  final Future<Conta> future =
      Navigator.push(context, MaterialPageRoute(builder: (context) {
    return FormularioConta(contas);
  }));
  future.then((contaRecebida) => {
        if (contaRecebida != null)
          {
            callback(contaRecebida),
          }
      });
}

void _abrirFormularioTrasacao(
    BuildContext context, Conta conta, List<Conta> contas, Function callback) {
  final Future<Transacao> future =
      Navigator.push(context, MaterialPageRoute(builder: (context) {
    return FormularioTransacao(conta, contas);
  }));
  future.then((transacaoRecebida) => {
        if (transacaoRecebida != null)
          {
            callback(transacaoRecebida),
          }
      });
}

void _abrirListaTrasacao(BuildContext context, Conta conta) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ListaTransacao(conta);
  }));
}

void apagar(BuildContext context, Function callBack) {
  CaixaMensagem(context).abrir('Confirma', 'Deseja apagar a conta?', [
    TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        callBack();
      },
      child: Text('Sim'),
    ),
    TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Não'),
    ),
  ]);
}
