import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core.dart';

final currentRouteUriProvider =
    StateNotifierProvider.autoDispose<_CurrentRouteUriController, Uri>(
  (ref) {
    return _CurrentRouteUriController(
      ref,
      ref.read(routerProvider).routeInformationProvider.value.uri,
    );
  },
);

class _CurrentRouteUriController extends StateNotifier<Uri> {
  final Ref _ref;

  _CurrentRouteUriController(this._ref, super.state) {
    final goRouter = _ref.read(routerProvider);

    goRouter.routeInformationProvider.addListener(_routeListener);
  }

  void _routeListener() {
    final goRouter = _ref.read(routerProvider);
    final uri = goRouter.routeInformationProvider.value.uri;
    _setCurrentRouteName(uri);
  }

  void _setCurrentRouteName(Uri uri) {
    state = uri;
  }

  @override
  void dispose() {
    final goRouter = _ref.read(routerProvider);
    goRouter.routeInformationProvider.removeListener(_routeListener);
    super.dispose();
  }
}
