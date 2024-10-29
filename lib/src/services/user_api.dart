import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/api_response.dart';

abstract class UserApi {
  Future<ApiResponse<MyUser>> login(
      {required String email, required String password});

  Future<ApiResponse<MyUser>> signUp(
      {required MyUser user, required String password});

  Future<ApiResponse<void>> signOut();

  // Future<ApiResponse<bool>> isUserSignedIn();

  Future<ApiResponse<bool>> checkIfEmailExists({required String email});

  Future<ApiResponse<void>> refreshAccessToken(
      {required String accessToken, required String refreshToken});

  Future<ApiResponse<String>> uploadAvatar({required File image});

  Future<ApiResponse<void>> updateUserData({required MyUser user});

  Future<ApiResponse<MyUser>> fetchUserDataById({required String userId});

  Future<ApiResponse<void>> toggleBookmark({required String travelId});

  Future<ApiResponse<void>> removeFriend({required String friendId});
}

class UserApiImpl extends UserApi {
  final dio = Dio();
  final baseUrl = GlobalData.baseUrl;

  @override
  Future<ApiResponse<MyUser>> login(
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

      return ApiResponse(data: user);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<MyUser>> signUp(
      {required MyUser user, required String password}) async {
    try {
      await dio.post("$baseUrl/auth/register", data: {
        "email": user.email,
        "password": password,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "number": user.phone,
      });

      return login(email: user.email, password: password);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    await HiveService.clearUserToken();
    return ApiResponse();
  }

  // @override
  // Future<ApiResponse<bool>> isUserSignedIn() async {
  //   return true;
  // }

  @override
  Future<ApiResponse<bool>> checkIfEmailExists({required String email}) async {
    try {
      final Response response = await dio.get(
        "$baseUrl/auth/getUserByEmail/$email",
      );

      return ApiResponse(data: response.data.length != 0);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> refreshAccessToken(
      {required String accessToken, required String refreshToken}) async {
    try {
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
      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<String>> uploadAvatar({required File image}) async {
    try {
      final Response response = await dio.post(
        "$baseUrl/user/uploadAvatar/${await HiveService.getUserId()}",
        data: FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path),
        }),
      );
      return ApiResponse(data: response.data["profileImageUrl"]);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> updateUserData({required MyUser user}) async {
    try {
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
      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  // User Rest API
  @override
  Future<ApiResponse<MyUser>> fetchUserDataById(
      {required String userId}) async {
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
        friends: List<String>.from(response.data[0]["userFriends"]),
      );

      return ApiResponse(data: user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          await refreshAccessToken(
            refreshToken: refreshToken,
            accessToken: accessToken,
          );
          return await fetchUserDataById(userId: userId);
        } on DioException catch (e) {
          return ApiResponse(errorMessage: e.message);
        }
      } else {
        return ApiResponse(errorMessage: e.message);
      }
    }
  }

  @override
  Future<ApiResponse<void>> toggleBookmark({required String travelId}) async {
    try {
      await dio.put("$baseUrl/user/toggleBookmark", data: {
        "userId": GlobalData.userId,
        "travelId": travelId,
      });
      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }

  @override
  Future<ApiResponse<void>> removeFriend({required String friendId}) async {
    try {
      await dio.put("$baseUrl/user/removeFriend/${GlobalData.userId}", data: {
        "targetId": friendId,
      });
      return ApiResponse();
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }
}
