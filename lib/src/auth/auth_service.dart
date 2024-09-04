import 'package:hive/hive.dart';

class AuthService {
  final Box _credentialsBox = Hive.box('credentialsBox');

  Future<void> storeUserToken({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) async {
    await _credentialsBox.put('id', id);
    await _credentialsBox.put('accessToken', accessToken);
    await _credentialsBox.put('refreshToken', refreshToken);
  }

  Future<void> updateAccessToken({
    required String accessToken,
  }) async {
    await _credentialsBox.put('accessToken', accessToken);
  }

  Future<void> clearUserToken() async {
    await _credentialsBox.delete('id');
    await _credentialsBox.delete('accessToken');
    await _credentialsBox.delete('refreshToken');
  }

  Future<String> getUserId() async {
    return await _credentialsBox.get('id', defaultValue: '');
  }

  Future<String> getUserAccessToken() async {
    return await _credentialsBox.get('accessToken', defaultValue: '');
  }

  Future<String> getUserRefreshToken() async {
    return await _credentialsBox.get('refreshToken', defaultValue: '');
  }

  // Future<bool> isUserSignedIn() async {
  //   // Check if both 'id' and 'accessToken' exist in the Hive box
  //   final idExists = _credentialsBox.containsKey('id');
  //   final accessTokenExists = _credentialsBox.containsKey('accessToken');

  //   // Return true if both exist, otherwise return false
  //   return idExists && accessTokenExists;
  // }
}
