import 'package:mobx/mobx.dart';

part 'dialog_store.g.dart';

class DialogStore = _DialogStoreBase with _$DialogStore;
abstract class _DialogStoreBase with Store {

  @observable
  bool buttonEnabled = true;

  @action
  bool validatingInputs(List inputs) {
    buttonEnabled = !inputs.any((element) => element == null || element == '');
    return buttonEnabled;
  }
}