import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

abstract class UserApi {
  final ApiService apiService;
  UserApi(this.apiService);

  Future<ApiResponse<UserModel>> login(
      {required String email, required String password});

  Future<ApiResponse<UserModel>> signUp(
      {required UserModel user, required String password});

  Future<ApiResponse<void>> signOut();

  // Future<ApiResponse<bool>> isUserSignedIn();

  Future<ApiResponse<bool>> checkIfEmailExists({required String email});

  Future<ApiResponse<void>> refreshAccessToken(
      {required String accessToken, required String refreshToken});

  Future<ApiResponse<String>> uploadAvatar({required File image});

  Future<ApiResponse<void>> updateUserData({required UserModel user});

  Future<ApiResponse<UserModel>> fetchUserDataById({required String userId});

  Future<ApiResponse<void>> toggleBookmark({required String travelId});

  Future<ApiResponse<void>> removeFriend({required String friendId});
}

class UserApiImpl extends UserApi {
  final baseUrl = GlobalData.baseUrl;
  UserApiImpl(super.apiService);

  @override
  Future<ApiResponse<UserModel>> login(
      {required String email, required String password}) async {
    final response = await apiService.post<UserModel>(
      endpoint: "$baseUrl/auth/login",
      data: {
        "email": email,
        "password": password,
      },
      fromJson: (data) => UserModel.fromJson(data['user'][0]),
    );

    if (response.data != null) {
      await HiveService.storeUserToken(
        id: response.data!.userId,
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );
    }

    return response;
  }

  @override
  Future<ApiResponse<UserModel>> signUp(
      {required UserModel user, required String password}) async {
    final response = await apiService.post(
      endpoint: "$baseUrl/auth/register",
      data: {
        "email": user.email,
        "password": password,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "number": user.phone,
      },
    );

    // catch error if there is any
    if (response.errorMessage != null) {
      return ApiResponse(errorMessage: response.errorMessage);
    } else {
      return login(email: user.email, password: password);
    }
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    await HiveService.clearUserToken();
    return ApiResponse();
  }

  @override
  Future<ApiResponse<bool>> checkIfEmailExists({required String email}) async {
    return apiService.get<bool>(
      endpoint: "$baseUrl/auth/getUserByEmail/$email",
      fromJson: (data) => data.length != 0, // return true or false
    );
  }

  @override
  Future<ApiResponse<void>> refreshAccessToken(
      {required String accessToken, required String refreshToken}) async {
    final response = await apiService.post(
      endpoint: "$baseUrl/auth/refresh",
      data: {
        "refreshToken": refreshToken,
      },
      options: Options(
        headers: {
          "x_authorization": accessToken,
        },
      ),
      fromJson: (data) => data["accessToken"],
    );
    if (response.errorMessage == null) {
      await HiveService.updateAccessToken(
          accessToken: response.data.toString());
    }
    return response;
  }

  @override
  Future<ApiResponse<String>> uploadAvatar({required File image}) async {
    return apiService.post<String>(
      endpoint: "$baseUrl/user/uploadAvatar/${GlobalData.userId}",
      data: FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path),
      }),
      fromJson: (data) => data["profileImageUrl"],
    );
  }

  @override
  Future<ApiResponse<void>> updateUserData({required UserModel user}) async {
    return apiService.put<void>(
      endpoint: "$baseUrl/user/updateUserById/${user.userId}",
      data: {
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
        "number": user.phone,
        "profileImageUrl": user.profileImageUrl,
      },
      fromJson: (data) => {},
      options: Options(
        headers: {
          "x_authorization": await HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  // User Rest API
  @override
  Future<ApiResponse<UserModel>> fetchUserDataById(
      {required String userId}) async {
    final accessToken = await HiveService.getUserAccessToken();
    final refreshToken = await HiveService.getUserRefreshToken();

    final response = await apiService.get<UserModel>(
      endpoint: "$baseUrl/user/getUserById/$userId",
      fromJson: (data) => UserModel.fromJson(data[0]),
      options: Options(
        headers: {
          "x_authorization": accessToken,
        },
      ),
    );

    if (response.errorMessage != null && response.statusCode == 401) {
      final refreshResponse = await refreshAccessToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      if (refreshResponse.errorMessage == null) {
        return fetchUserDataById(userId: userId);
      }
    }

    return response;
  }

  @override
  Future<ApiResponse<void>> toggleBookmark({required String travelId}) async {
    return apiService.put<void>(
      endpoint: "$baseUrl/user/toggleBookmark",
      data: {
        "userId": GlobalData.userId,
        "travelId": travelId,
      },
      fromJson: (data) => {},
      options: Options(
        headers: {
          "x_authorization": await HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<void>> removeFriend({required String friendId}) async {
    return apiService.put<void>(
      endpoint: "$baseUrl/user/removeFriend/${GlobalData.userId}",
      data: {
        "targetId": friendId,
      },
      fromJson: (data) => {},
      options: Options(
        headers: {
          "x_authorization": await HiveService.getUserAccessToken(),
        },
      ),
    );
  }
}
