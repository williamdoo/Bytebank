import 'package:bytebank/models/transacao.dart';

class Conta {
  final String numeroConta;
  List<Transacao> transacoes = List();

  Conta(this.numeroConta);

  void adicionarTransacao(Transacao transacao) {
    transacao.valor = transacao.tipoTransacao == TipoTrasacao.debito
        ? transacao.valor * -1
        : transacao.valor;

    transacoes.add(transacao);
  }

  void adicionarTransferencia(Transacao transacao) {
    Transacao transferencia = Transacao(transacao.valor * -1,
        TipoTrasacao.credito, false, transacao.transacaoDe, '');

    transacoes.add(transferencia);
  }

  double saldoTotal() {
    if (transacoes != null) {
      return transacoes.fold(
          0, (previousValue, element) => previousValue + element.valor);
    } else {
      return 0;
    }
  }
}
