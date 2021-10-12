import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_12_oct_2021/auth/model/comment_model.dart';
import 'package:test_12_oct_2021/auth/model/post_list_model.dart';
import 'package:test_12_oct_2021/service/network_repository.dart' as api;
import 'package:test_12_oct_2021/utils/app_string.dart';

class HomeProvider extends ChangeNotifier {
  BuildContext mContext;
  bool isRequestSend = false;

  List<PostListModel> postListModel = [];
  String postErrorMessage;

  List<CommentModel> commentListModel = [];
  String commentErrorMessage;

  HomeProvider(context) {
    mContext = context;
  }

  Future<Map<String, dynamic>> listOfPost() {
    isRequestSend = true;
    notifyListeners();
    return api.callGetMethod(mContext, APPStrings.apiPost).then((value) {
      isRequestSend = false;
      if (value != null) {
        try {
          postListModel = List<PostListModel>.from(
              json.decode(value).map((x) => PostListModel.fromJson(x)));
        } catch (ex) {
          postErrorMessage = APPStrings.internalServerError;
        }
      } else {
        postErrorMessage = APPStrings.internalServerError;
      }
      notifyListeners();
    }).catchError((e) {
      isRequestSend = false;
      notifyListeners();
      throw e;
    });
  }

  Future<Map<String, dynamic>> getUser(int userId) {
    isRequestSend = true;
    notifyListeners();
    return api
        .callGetMethod(mContext, APPStrings.apiGetUser + userId.toString())
        .then((value) {
      isRequestSend = false;
      Map<String, dynamic> data = jsonDecode(value);
      notifyListeners();
      return data;
    }).catchError((e) {
      isRequestSend = false;
      notifyListeners();
      throw e;
    });
  }

  Future<List<CommentModel>> getComment(int postId) async {
    String response = await api
        .post(APPStrings.apiGetComment + postId.toString() + "/comments");

    return List<CommentModel>.from(
        json.decode(response).map((x) => CommentModel.fromJson(x)));
  }
}
