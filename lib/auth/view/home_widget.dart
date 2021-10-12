import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_12_oct_2021/auth/model/CommonModel.dart';
import 'package:test_12_oct_2021/auth/model/comment_model.dart';
import 'package:test_12_oct_2021/auth/model/post_list_model.dart';
import 'package:test_12_oct_2021/auth/model/user_model.dart';
import 'package:test_12_oct_2021/auth/provider/home_provider.dart';
import 'package:test_12_oct_2021/utils/app_string.dart';
import 'package:test_12_oct_2021/utils/common/show_dialog.dart';

class HomeWidget extends StatefulWidget {
  final PostListModel postListModel;

  const HomeWidget({Key key, this.postListModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  HomeProvider mHomeProvider;
  UserModel userModel = UserModel();
  List<CommentModel> commentListModel = [];

  @override
  void initState() {
    _callGetUser();
    _callGetComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHomeProvider = Provider.of<HomeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(userModel != null && userModel.name != null
                ? setPrefix(userModel.name)
                : ""),
          ),
          const SizedBox(height: 8),
          Text("Post body : ${widget.postListModel.body}"),
          const SizedBox(height: 16),
          Text(
              "Comment count : ${commentListModel != null && commentListModel.length != 0 ? commentListModel.length.toString() : "0"}")
        ],
      ),
    );
  }

  String setPrefix(String name) {
    String userName = "";
    List listOfWords = name.split(' ');
    if (listOfWords.isNotEmpty && listOfWords.length == 1) {
      userName = '${listOfWords[0][0]}${listOfWords[0][0]}';
    } else if (listOfWords.isNotEmpty && listOfWords.length >= 2) {
      if (listOfWords[1][0] == "&") {
        userName = '${listOfWords[0][0]}${listOfWords[2][0]}';
        print(userName);
      } else {
        userName = '${listOfWords[0][0]}${listOfWords[1][0]}';
      }
    } else {
      userName = '';
    }
    return userName;
  }

  _callGetUser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      mHomeProvider.getUser(widget.postListModel.userId).then((value) {
        if (value != null) {
          try {
            CommonModel streams = CommonModel.fromJson(value);
            if (streams.status != null && streams.status == "0") {
              ShowDialog.showCustomDialog(
                  context, streams.message, APPStrings.ok);
            } else {
              userModel = UserModel.fromJson(value);
            }
          } catch (ex) {
            print(ex);
            ShowDialog.showCustomDialog(
                context, APPStrings.internalServerError, APPStrings.ok);
          }
        } else {
          ShowDialog.showCustomDialog(
              context, APPStrings.internalServerError, APPStrings.ok);
        }
      });
    } else {
      ShowDialog.showCustomDialog(
          context, APPStrings.noInternetConnection, APPStrings.ok);
    }
  }

  _callGetComment() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await mHomeProvider
          .getComment(widget.postListModel.id)
          .then((value) => {commentListModel.addAll(value)})
          .catchError((onError) {
        ShowDialog.showCustomDialog(
            context, APPStrings.internalServerError, APPStrings.ok);
      });
    } else {
      ShowDialog.showCustomDialog(
          context, APPStrings.noInternetConnection, APPStrings.ok);
    }

    setState(() {});
  }
}
