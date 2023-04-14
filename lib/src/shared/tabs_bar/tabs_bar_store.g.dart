// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_bar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TabsBarStore on _TabsBarStoreBase, Store {
  Computed<List<Tabs>>? _$tabsItemsComputed;

  @override
  List<Tabs> get tabsItems =>
      (_$tabsItemsComputed ??= Computed<List<Tabs>>(() => super.tabsItems,
              name: '_TabsBarStoreBase.tabsItems'))
          .value;

  late final _$selectedItemAtom =
      Atom(name: '_TabsBarStoreBase.selectedItem', context: context);

  @override
  int get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(int value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$_tabsItemsAtom =
      Atom(name: '_TabsBarStoreBase._tabsItems', context: context);

  @override
  List<Tabs>? get _tabsItems {
    _$_tabsItemsAtom.reportRead();
    return super._tabsItems;
  }

  @override
  set _tabsItems(List<Tabs>? value) {
    _$_tabsItemsAtom.reportWrite(value, super._tabsItems, () {
      super._tabsItems = value;
    });
  }

  late final _$_TabsBarStoreBaseActionController =
      ActionController(name: '_TabsBarStoreBase', context: context);

  @override
  dynamic setTabs(List<Tabs> listItems) {
    final _$actionInfo = _$_TabsBarStoreBaseActionController.startAction(
        name: '_TabsBarStoreBase.setTabs');
    try {
      return super.setTabs(listItems);
    } finally {
      _$_TabsBarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedItem: ${selectedItem},
tabsItems: ${tabsItems}
    ''';
  }
}
