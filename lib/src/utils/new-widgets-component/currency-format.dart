
String currencyFormatter(amount){
  final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    mathFunc(Match match) => '${match[1]},';

  return amount == null ? '0' :amount.toString().replaceAllMapped(reg, (Match match) => '${match[1]},' );
}