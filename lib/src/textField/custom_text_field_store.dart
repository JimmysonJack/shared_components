import 'package:mobx/mobx.dart';

part 'custom_text_field_store.g.dart';

class CustomTextStore = _CustomTextStoreBase with _$CustomTextStore;
abstract class _CustomTextStoreBase with Store {
  @observable
  String? _fieldValue;

  @computed
  String get fieldValue => _fieldValue ?? '';

  set fieldValue(String value) => _fieldValue = value;
}