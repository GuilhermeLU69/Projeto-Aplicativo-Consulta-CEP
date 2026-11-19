// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_HomeControllerBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$lastAddressAtom =
      Atom(name: '_HomeControllerBase.lastAddress', context: context);

  @override
  AddressModel? get lastAddress {
    _$lastAddressAtom.reportRead();
    return super.lastAddress;
  }

  @override
  set lastAddress(AddressModel? value) {
    _$lastAddressAtom.reportWrite(value, super.lastAddress, () {
      super.lastAddress = value;
    });
  }

  late final _$notFoundAtom =
      Atom(name: '_HomeControllerBase.notFound', context: context);

  @override
  bool get notFound {
    _$notFoundAtom.reportRead();
    return super.notFound;
  }

  @override
  set notFound(bool value) {
    _$notFoundAtom.reportWrite(value, super.notFound, () {
      super.notFound = value;
    });
  }

  late final _$modeAtom =
      Atom(name: '_HomeControllerBase.mode', context: context);

  @override
  SearchMode get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(SearchMode value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  late final _$searchByCepAsyncAction =
      AsyncAction('_HomeControllerBase.searchByCep', context: context);

  @override
  Future<void> searchByCep(String cep) {
    return _$searchByCepAsyncAction.run(() => super.searchByCep(cep));
  }

  late final _$searchByAddressAsyncAction =
      AsyncAction('_HomeControllerBase.searchByAddress', context: context);

  @override
  Future<void> searchByAddress(
      {required String uf, required String city, required String street}) {
    return _$searchByAddressAsyncAction
        .run(() => super.searchByAddress(uf: uf, city: city, street: street));
  }

  late final _$selectAddressAsyncAction =
      AsyncAction('_HomeControllerBase.selectAddress', context: context);

  @override
  Future<void> selectAddress(AddressModel address) {
    return _$selectAddressAsyncAction.run(() => super.selectAddress(address));
  }

  late final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase', context: context);

  @override
  void setMode(SearchMode value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setMode');
    try {
      return super.setMode(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadLastAddress() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.loadLastAddress');
    try {
      return super.loadLastAddress();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
lastAddress: ${lastAddress},
notFound: ${notFound},
mode: ${mode}
    ''';
  }
}
