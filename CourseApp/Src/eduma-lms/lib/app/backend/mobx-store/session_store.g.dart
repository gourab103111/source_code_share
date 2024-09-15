// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SessionStore on _SessionStore, Store {
  late final _$tokenAtom = Atom(name: '_SessionStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$userInfoAtom =
      Atom(name: '_SessionStore.userInfo', context: context);

  @override
  UserInfoModel? get userInfo {
    _$userInfoAtom.reportRead();
    return super.userInfo;
  }

  @override
  set userInfo(UserInfoModel? value) {
    _$userInfoAtom.reportWrite(value, super.userInfo, () {
      super.userInfo = value;
    });
  }

  late final _$_SessionStoreActionController =
      ActionController(name: '_SessionStore', context: context);

  @override
  void setToken(dynamic value) {
    final _$actionInfo = _$_SessionStoreActionController.startAction(
        name: '_SessionStore.setToken');
    try {
      return super.setToken(value);
    } finally {
      _$_SessionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserInfo(dynamic value) {
    final _$actionInfo = _$_SessionStoreActionController.startAction(
        name: '_SessionStore.setUserInfo');
    try {
      return super.setUserInfo(value);
    } finally {
      _$_SessionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
token: ${token},
userInfo: ${userInfo}
    ''';
  }
}
