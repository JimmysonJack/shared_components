import 'package:mobx/mobx.dart';
import 'package:shared_component/src/tabs_bar/tabs.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'tabs_bar_store.g.dart';
class TabsBarStore extends _TabsBarStoreBase with _$TabsBarStore {
  static TabsBarStore? _instance;
  static TabsBarStore getInstance(){
    _instance ??= TabsBarStore();
    return _instance!;
  }
}

abstract class _TabsBarStoreBase with Store{

  @observable
  int selectedItem = 0;

  @observable
  List<Tabs>? _tabsItems;

  @computed
  List<Tabs> get tabsItems => _tabsItems ?? [];
  @action
  setTabs(List<Tabs> listItems){
    List<Tabs> filteredList = listItems.where((element) => element.permission == true).toList();
    _tabsItems = filteredList;

  }
  onSelected({itemIndex,url}){
    selectedItem = itemIndex;
    Modular.to.navigate(url);
  }
}