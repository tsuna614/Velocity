import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/user_model.dart';

abstract class UserApi {
  static final dio = Dio();
  static final baseUrl = GlobalData.baseUrl;
  // final AuthService HiveService = AuthService();

  static Future<MyUser> login(
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
        profileImageUrl: userData['profileImageUrl'] ?? "",
      );

      await HiveService.storeUserToken(
        id: userData['_id'],
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

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

  static Future<MyUser> signUp(
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

  static Future<void> signOut() async {
    await HiveService.clearUserToken();
  }

  static Future<bool> isUserSignedIn() async {
    return true;
  }

  static Future<bool> checkIfEmailExists({required String email}) async {
    try {
      final Response response = await dio.get(
        "$baseUrl/auth/getUserByEmail/$email",
      );

      return response.data.length != 0;
    } on DioException catch (e) {
      printError(e);
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<void> refreshAccessToken(
      {required String accessToken, required String refreshToken}) async {
    try {
      print("TOKEN REFRESHED");
      final Response response = await dio.post(
        "$baseUrl/auth/refresh",
        options: Options(
          headers: {
            "x_authorization": accessToken,
          },
        ),
        data: {
          "refreshToken": refreshToken,
        },
      );
      await HiveService.updateAccessToken(
          accessToken: response.data["accessToken"]);
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<String> uploadAvatar({required File image}) async {
    try {
      final Response response = await dio.post(
        "$baseUrl/user/uploadAvatar/${await HiveService.getUserId()}",
        data: FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path),
        }),
      );
      return response.data["profileImageUrl"];
    } on DioException catch (e) {
      printError(e);
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<void> updateUserData({required MyUser user}) async {
    try {
      print(user.userId);
      await dio.put(
        "$baseUrl/user/updateUserById/${user.userId}",
        data: {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "number": user.phone,
          "profileImageUrl": user.profileImageUrl,
        },
        options: Options(
          headers: {
            "x_authorization": await HiveService.getUserAccessToken(),
          },
        ),
      );
    } on DioException catch (e) {
      printError(e);
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static void printError(DioException e) {
    if (e.response != null) {
      print('Error response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
    } else {
      print('Error message: ${e.message}');
    }
  }

  // User Rest API
  static Future<MyUser> fetchUserDataById({required String userId}) async {
    final accessToken = await HiveService.getUserAccessToken();
    final refreshToken = await HiveService.getUserRefreshToken();

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
        profileImageUrl: response.data[0]["profileImageUrl"] ?? "",
        bookmarkedTravels:
            List<String>.from(response.data[0]["bookmarkedTravels"]),
      );

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await refreshAccessToken(
            refreshToken: refreshToken,
            accessToken: accessToken,
          );
          return await fetchUserDataById(userId: userId);
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

  static Future<void> toggleBookmark({required String travelId}) async {
    try {
      await dio.put("$baseUrl/user/toggleBookmark", data: {
        "userId": GlobalData.userId,
        "travelId": travelId,
      });
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }
}
