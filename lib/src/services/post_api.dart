import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

abstract class PostApi {
  final ApiService apiService;
  PostApi(this.apiService);

  Future<ApiResponse<List<PostModel>>> fetchPosts({
    required PostType postType,
    String?
        targetId, // target id is the id of the object that the post is related to
    // for example it could be the id of a travel (review post) or the id of another post (comment post)
  });

  Future<ApiResponse<PostModel>> fetchPost({required String postId});

  Future<ApiResponse<String>> addPost({required PostModel post});

  Future<ApiResponse<String>> uploadImage({required File image});

  Future<ApiResponse<String>> uploadVideo({required File video});

  Future<ApiResponse<void>> likePost(
      {required String postId, required String userId});

  Future<ApiResponse<void>> deletePost({required String postId});
}

class PostApiImpl extends PostApi {
  final baseUrl = GlobalData.baseUrl;

  PostApiImpl(super.apiService);

  @override
  Future<ApiResponse<List<PostModel>>> fetchPosts(
      {required PostType postType, String? targetId}) async {
    return apiService.post(
      endpoint: postType == PostType.reviewPost
          ? "$baseUrl/post/getReviewPosts"
          : postType == PostType.commentPost
              ? "$baseUrl/post/getCommentPosts"
              : "$baseUrl/post/getAllNormalPosts",
      data: {
        "targetId": targetId,
      },
      fromJson: (data) {
        List<PostModel> posts;

        posts = data.map<PostModel>((e) => PostModel.fromJson(e)).toList();
        posts.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

        return posts;
      },
      options: Options(
        headers: {
          "x_authorization": HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<PostModel>> fetchPost({required String postId}) async {
    return apiService.get(
      endpoint: "$baseUrl/post/$postId",
      fromJson: (data) => PostModel.fromJson(data),
      options: Options(
        headers: {
          "x_authorization": HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<String>> addPost({required PostModel post}) async {
    return apiService.post(
      endpoint: "$baseUrl/post/createPost",
      data: {
        "userId": post.userId,
        "content": post.content,
        "imageUrl": post.imageUrl,
        "contentType":
            post.contentType == ContentType.video ? "video" : "image",
        if (post.travelId != null) "travelId": post.travelId,
        if (post.rating != null) "rating": post.rating,
        if (post.commentTargetId != null) "postId": post.commentTargetId,
        if (post.sharedPostId != null) "sharedPostId": post.sharedPostId,
      },
      options: Options(
        headers: {
          "x_authorization": await HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<String>> uploadImage({required File image}) async {
    return apiService.post(
      endpoint: "$baseUrl/post/uploadImage",
      data: FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path),
      }),
      fromJson: (data) => data["imageUrl"],
      options: Options(
        headers: {
          "x_authorization": HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<String>> uploadVideo({required File video}) async {
    return apiService.post(
      endpoint: "$baseUrl/post/uploadVideo",
      data: FormData.fromMap({
        "video": await MultipartFile.fromFile(video.path),
      }),
      fromJson: (data) => data["videoUrl"],
      options: Options(
        headers: {
          "x_authorization": HiveService.getUserAccessToken(),
        },
      ),
    );
  }

  @override
  Future<ApiResponse<void>> likePost(
      {required String postId, required String userId}) async {
    return apiService.post(
      endpoint: "$baseUrl/post/likePost",
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
  }

  @override
  Future<ApiResponse<void>> deletePost({required String postId}) async {
    return apiService.delete(
      endpoint: "$baseUrl/post/$postId",
      options: Options(
        headers: {
          "x_authorization": await HiveService.getUserAccessToken(),
        },
      ),
    );
  }
}
