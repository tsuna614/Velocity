import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/post_model.dart';

abstract class PostApi {
  Future<List<MyPost>> fetchPosts(
      {required bool isReviewPost, String? travelId});

  Future<String> addPost({required MyPost post});

  Future<String> uploadImage({required File image});

  Future<void> likePost({required String postId, required String userId});
}

class PostApiImpl extends PostApi {
  final baseUrl = GlobalData.baseUrl;
  final dio = Dio();

  @override
  Future<List<MyPost>> fetchPosts(
      {required bool isReviewPost, String? travelId}) async {
    try {
      final Response response = await dio.get(
        isReviewPost
            ? "$baseUrl/post/getAllReviewPosts"
            : "$baseUrl/post/getAllNormalPosts",
        data: {
          "travelId": travelId,
        },
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
          likes: postData['likes'].map<String>((e) => e.toString()).toList(),
          comments:
              postData['comments'].map<String>((e) => e.toString()).toList(),
          shares: postData['shares'].map<String>((e) => e.toString()).toList(),
          rating: postData["rating"] == null
              ? null
              : double.parse(postData['rating'].toString()),
          travelId: postData['travelId'],
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

  @override
  Future<String> addPost({required MyPost post}) async {
    try {
      Response response = await dio.post(
        "$baseUrl/post/createPost",
        data: {
          "userId": post.userId,
          "content": post.content,
          "imageUrl": post.imageUrl,
          "travelId": post.travelId,
          "rating": post.rating,
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

  @override
  Future<String> uploadImage({required File image}) async {
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

  @override
  Future<void> likePost(
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
