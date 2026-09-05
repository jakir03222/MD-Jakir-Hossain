/// Abstraction over local key-value persistence.
abstract class ILocalStorage {
  T? read<T>(String key);

  Future<void> write(String key, dynamic value);

  Future<void> remove(String key);
}
