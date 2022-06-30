import 'package:mobx/mobx.dart';
import '../utils/table.dart';

part 'paging_store.g.dart';

class PagingStore = _PagingStoreBase with _$PagingStore;
abstract class _PagingStoreBase with Store {

  @observable
  int _pageSize = 10;

  @computed
  int get pageSize{
    PagingValues.getInstance().setPageSize(_pageSize);
    return _pageSize;
  }

  @action
  setSize(value) => _pageSize = value;
}