import 'package:mobx/mobx.dart';
part 'update_table.g.dart';
class UpdateTable extends _UpdateTableBase with _$UpdateTable {
  static UpdateTable? _instance;
  static UpdateTable _getInstance(){
    _instance ??= UpdateTable();
    return _instance!;
  }
  static UpdateTable get change => _getInstance();
}

abstract class _UpdateTableBase with Store{
  @observable
  bool updateTable = false;

  @observable
  List<Map<String,dynamic>> tableListData = [];

  @observable
  bool modalIsOpened = false;

  @action
  setModalIsOpened(bool value) => modalIsOpened = value;

  @action
  setUpdateTable(bool value) => updateTable = value;
}