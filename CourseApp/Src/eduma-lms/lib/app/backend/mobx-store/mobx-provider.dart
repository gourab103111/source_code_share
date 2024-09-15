import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

mixin Disposable {
  @mustCallSuper
  Future<void> dispose() async {}
}

mixin MobxProviderSingleChildWidget on SingleChildWidget {}

class MobxProvider<T extends Store?> extends SingleChildStatelessWidget
    with MobxProviderSingleChildWidget {
  const MobxProvider({
    required T Function(BuildContext) create,
    this.child,
    Key? key,
    bool lazy = true,
  })  : _create = create,
        _value = null,
        _lazy = lazy,
        super(key: key, child: child);

  /// Note that value provided stores are not disposed
  const MobxProvider.value({
    Key? key,
    required T value,
    this.child,
  })  : _value = value,
        _create = null,
        _lazy = true,
        super(key: key, child: child);

  final Widget? child;
  final T Function(BuildContext)? _create;
  final T? _value;
  final bool _lazy;

  static T of<T extends Store>(
    BuildContext context, {
    bool listen = false,
  }) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) rethrow;
      throw FlutterError(
        '''
        MobxProvider.of() called with a context that does not contain a $T.
        No ancestor could be found starting from the context that was passed to MobxProvider.of<$T>().
        This can happen if the context you used comes from a widget above the MobxProvider.
        The context used was: $context
        ''',
      );
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _value == null
        ? InheritedProvider<T>(
            create: _create,
            dispose: disposeStore,
            child: child,
          )
        : InheritedProvider<T?>.value(
            value: _value,
            lazy: _lazy,
            child: child,
          );
  }

  void disposeStore(BuildContext context, Store? store) {
    if (store == null) return;

    if (store is Disposable) {
      (store as Disposable).dispose();
    }
  }
}

class MobxMultiProvider extends MultiProvider {
  MobxMultiProvider({
    required List<MobxProviderSingleChildWidget> providers,
    required Widget child,
    Key? key,
  }) : super(key: key, providers: providers, child: child);
}

abstract class LifecycleStore with Disposable, Store {
  LifecycleStore() {
    onInit();
  }

  @mustCallSuper
  @protected
  Future<void> onInit();
}

mixin StorageAdapterMixin {
  Future<void> storeData(String key, Map<String, dynamic>? data);
  Future<Map<String, dynamic>?> retrieveData(String key);
}

mixin RehydratedMixin {
  Future<void> restoreState(Map<String, dynamic> restoreState);
  Future<Map<String, dynamic>> storeState();
}

abstract class RehydratedStore extends LifecycleStore with RehydratedMixin {
  RehydratedStore(
    this._key,
    this._storageAdapter,
  ) : super();

  final String _key;
  final StorageAdapterMixin _storageAdapter;

  @override
  @mustCallSuper
  Future<void> onInit() async {
    final state = await _storageAdapter.retrieveData(_key);
    if (state == null) return;
    await restoreState(state);
  }

  @mustCallSuper
  @override
  Future<void> dispose() async {
    final state = await storeState();
    await _storageAdapter.storeData(_key, state);
    return super.dispose();
  }
}
