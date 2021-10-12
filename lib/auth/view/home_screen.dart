import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_12_oct_2021/auth/provider/home_provider.dart';
import 'package:test_12_oct_2021/auth/view/home_widget.dart';
import 'package:test_12_oct_2021/utils/app_string.dart';
import 'package:test_12_oct_2021/utils/common/show_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider mHomeProvider;

  @override
  void initState() {
    _callGetPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHomeProvider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: getBody()),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return HomeWidget(
                  postListModel: mHomeProvider.postListModel[index]);
            },
            itemCount: mHomeProvider.postListModel.length,
          ),
        ),
      ],
    );
  }

  _callGetPostList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      mHomeProvider.listOfPost().then((value) {});
    } else {
      ShowDialog.showCustomDialog(
          context, APPStrings.noInternetConnection, APPStrings.ok);
    }
  }
}
