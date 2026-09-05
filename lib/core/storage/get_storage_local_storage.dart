import 'package:get_storage/get_storage.dart';

import 'i_local_storage.dart';

class GetStorageLocalStorage implements ILocalStorage {
  GetStorageLocalStorage({GetStorage? storage})
      : _storage = storage ?? GetStorage();

  final GetStorage _storage;

  @override
  T? read<T>(String key) => _storage.read<T>(key);

  @override
  Future<void> write(String key, dynamic value) => _storage.write(key, value);

  @override
  Future<void> remove(String key) => _storage.remove(key);
}
