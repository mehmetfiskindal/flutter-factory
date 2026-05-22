import 'package:connectivity_plus/connectivity_plus.dart';

enum OfflineStatus {
  online,
  offline,
}

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<OfflineStatus> watchStatus() {
    return _connectivity.onConnectivityChanged.map(_toStatus).distinct();
  }

  Future<OfflineStatus> currentStatus() async {
    return _toStatus(await _connectivity.checkConnectivity());
  }

  OfflineStatus _toStatus(List<ConnectivityResult> results) {
    return results.every((result) => result == ConnectivityResult.none)
        ? OfflineStatus.offline
        : OfflineStatus.online;
  }
}
