import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoFutureProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

final packageInfoProvider = Provider<PackageInfo?>(
  (ref) => ref.watch(packageInfoFutureProvider).asData?.value,
);
