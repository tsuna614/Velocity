import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/post_model.dart';

abstract class PostApi {
  static final baseUrl = GlobalData.baseUrl;
  static final dio = Dio();

  static Future<List<MyPost>> fetchPosts() async {
    try {
      final Response response = await dio.get(
        "$baseUrl/post/getAllPosts",
        options: Options(
          headers: {
            "x_authorization": await HiveService.getUserAccessToken(),
          },
        ),
      );

      List<MyPost> posts = [];

      for (int i = 0; i < response.data.length; i++) {
        final Map<String, dynamic> postData = response.data[i];
        posts.add(MyPost(
          postId: postData['_id'],
          userId: postData['userId'],
          dateCreated: DateTime.parse(postData['createdAt']),
          content: postData['content'] ?? "",
          imageUrl: postData['imageUrl'] ?? "",
          likes: response.data[i]['likes']
              .map<String>((e) => e.toString())
              .toList(),
          comments: response.data[i]['comments']
              .map<String>((e) => e.toString())
              .toList(),
          shares: response.data[i]['shares']
              .map<String>((e) => e.toString())
              .toList(),
        ));
      }

      posts.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

      return posts;
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<String> addPost({required MyPost post}) async {
    try {
      Response response = await dio.post(
        "$baseUrl/post/createPost",
        data: {
          "userId": post.userId,
          "content": post.content,
          "imageUrl": post.imageUrl,
        },
        options: Options(
          headers: {
            "x_authorization": await HiveService.getUserAccessToken(),
          },
        ),
      );

      return response.data["_id"];
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<String> uploadImage({required File image}) async {
    try {
      print("UPLOADING IMAGE");
      final Response response = await dio.post(
        "$baseUrl/post/uploadImage",
        data: FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path),
        }),
        options: Options(
          headers: {
            "x_authorization": await HiveService.getUserAccessToken(),
          },
        ),
      );
      return response.data["imageUrl"];
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }

  static Future<void> likePost(
      {required String postId, required String userId}) async {
    try {
      await dio.post(
        "$baseUrl/post/likePost",
        data: {
          "postId": postId,
          "userId": userId,
        },
        options: Options(
          headers: {
            "x_authorization": await HiveService.getUserAccessToken(),
          },
        ),
      );
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }
}
