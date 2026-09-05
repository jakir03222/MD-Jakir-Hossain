/// Abstraction for network reachability (Interface Segregation).
abstract class IConnectivityService {
  Future<bool> get isOnline;

  Stream<bool> get onStatusChanged;
}
