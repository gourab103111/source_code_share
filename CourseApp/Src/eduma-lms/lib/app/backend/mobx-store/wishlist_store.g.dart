// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WishlistStore on _WishlistStore, Store {
  late final _$dataAtom = Atom(name: '_WishlistStore.data', context: context);

  @override
  ObservableList<CourseModel> get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(ObservableList<CourseModel> value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  late final _$_WishlistStoreActionController =
      ActionController(name: '_WishlistStore', context: context);

  @override
  void setWishlist(List<CourseModel> items) {
    final _$actionInfo = _$_WishlistStoreActionController.startAction(
        name: '_WishlistStore.setWishlist');
    try {
      return super.setWishlist(items);
    } finally {
      _$_WishlistStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data}
    ''';
  }
}
