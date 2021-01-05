class Transacao {
  final DateTime dataTransacao = DateTime.now();
  TipoTrasacao tipoTransacao;
  double valor;
  bool transacaoEntreConta;
  String transacaoPara;
  String transacaoDe;

  Transacao(this.valor, this.tipoTransacao, this.transacaoEntreConta,
      this.transacaoDe, this.transacaoPara);

  @override
  String toString() {
    return 'Transferencia (Tipo transação $tipoTransacao) (valor $valor)';
  }

  String toStringTipoTransacao() {
    switch (tipoTransacao) {
      case TipoTrasacao.debito:
        return 'Débito';
      case TipoTrasacao.credito:
        return 'Crédito';
      default:
        return '';
    }
  }
}

enum TipoTrasacao {
  debito,
  credito,
}
