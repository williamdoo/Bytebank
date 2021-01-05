import 'package:intl/intl.dart';

class Formatacao {
  static String toMoney(double valor, String formato, String locate) {
    NumberFormat format = NumberFormat(formato, locate);
    return 'R\$ ${format.format(valor)}';
  }

  static String toDateTime(DateTime dataHora, String formato) {
    String formatoDataHora = DateFormat(formato).format(dataHora);

    return formatoDataHora;
  }

  static double toDouble(String valor) {
    double value = 0;
    String result = valor.replaceAll('R\$', '');
    result = result.replaceAll('.', '');
    result = result.replaceAll(',', '.');
    result = result.trim();
    value = double.tryParse(result);

    return value;
  }
}
