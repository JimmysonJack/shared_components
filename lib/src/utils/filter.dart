import 'package:shared_component/src/service/settings_service.dart';

class DataFilter {
  final String filterField;
  final dynamic filterString;
  final bool? equal;

  DataFilter(
      {required this.filterField,
      required this.filterString,
      this.equal = true});

  static List<Map<String, dynamic>> filter(List<Map<String, dynamic>> dataList,
      dynamic filterString, String? filteredField, bool? equal) {
    final list = dataList.where((element) {
      if (equal == false) {
        return element[filteredField].toString() != filterString.toString();
      }
      return element[filteredField].toString() == filterString.toString();
    }).toList();
    if (!SettingsService.use.isEmptyOrNull(filterString) &&
        SettingsService.use.isEmptyOrNull(filteredField)) {
      return List<Map<String, dynamic>>.from(list);
    }
    return list;
  }
}
