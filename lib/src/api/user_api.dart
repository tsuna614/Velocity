import 'package:dio/dio.dart';
import 'package:velocity_app/src/auth/auth_service.dart';
import 'package:velocity_app/src/model/user_model.dart';

class UserApi {
  // String baseUrl = "http://localhost:3000";
  String baseUrl = "http://10.0.2.2:3000";
  final dio = Dio();
  final AuthService _authService = AuthService();

  Future<MyUser> login(
      {required String email, required String password}) async {
    try {
      final Response response = await dio.post(
        "$baseUrl/auth/login",
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Set the content type to JSON
          },
        ),
      );

      // WARNING: might need to implement something to check if field 'user' is not null
      final Map<String, dynamic> userData = response.data['user'][0];
      MyUser user = MyUser(
        userId: userData['_id'],
        email: userData['email'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        phone: userData['number'],
      );

      await _authService.storeUserToken(
        id: userData['_id'],
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      return user;

      // // Check if the response data is a map
      // if (response.data is Map<String, dynamic>) {
      //   final Map<String, dynamic> responseData = response.data;

      //   // Extract specific fields
      //   final String? accessToken = responseData['accessToken'];
      //   final String? refreshToken = responseData['refreshToken'];
      //   final String? message = responseData['msg'];

      //   // Print the extracted data
      //   print('Message: $message');
      //   print('Access Token: $accessToken');
      //   print('Refresh Token: $refreshToken');

      //   // You can also extract user details if needed
      // if (responseData['user'] is List) {
      //   final List<dynamic> userList = responseData['user'];
      //   if (userList.isNotEmpty) {
      //     final Map<String, dynamic> user = userList[0];
      //     final String? email = user['email'];
      //     final String? firstName = user['firstName'];
      //     final String? lastName = user['lastName'];
      //     print('User Email: $email');
      //     print('User Name: $firstName $lastName');
      //   }
      // }
      // } else {
      //   print('Unexpected response format');
      // }
    } on DioException catch (e) {
      printError(e);
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  Future<MyUser> signUp(
      {required MyUser user, required String password}) async {
    try {
      final Response response = await dio.post("$baseUrl/auth/register", data: {
        "email": user.email,
        "password": password,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "number": user.phone,
      });

      print(response.statusCode);

      return user;
    } on DioException catch (e) {
      printError(e);
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  Future<void> signOut() async {
    await _authService.clearUserToken();
  }

  Future<MyUser> fetchUserData({required String userId}) async {
    final accessToken = await _authService.getUserAccessToken();
    final refreshToken = await _authService.getUserRefreshToken();

    try {
      final Response response = await dio.get(
        "$baseUrl/user/getUserById/$userId",
        options: Options(
          headers: {
            "x_authorization": accessToken,
          },
        ),
      );

      MyUser user = MyUser(
        userId: userId,
        email: response.data[0]["email"],
        firstName: response.data[0]["firstName"],
        lastName: response.data[0]["lastName"],
        phone: response.data[0]["number"],
      );

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await refreshAccessToken(refreshToken: refreshToken);
          return await fetchUserData(userId: userId);
        } on DioException catch (e) {
          printError(e);
          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            message: e.message,
          );
        }
      } else {
        printError(e);
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: e.message,
        );
      }
    }
  }

  Future<bool> isUserSignedIn() async {
    return true;
  }

  Future<void> refreshAccessToken({required String refreshToken}) async {
    try {} on DioException {
      rethrow;
    }
  }

  void printError(DioException e) {
    if (e.response != null) {
      print('Error response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
    } else {
      print('Error message: ${e.message}');
    }
  }
}
