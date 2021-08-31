import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listview_task/network/network_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = new ScrollController();
  var data;
  var maxlenth = 10;
  bool isnull = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future getlistData() async {
    try {
      NetworkHelper networkHelper =
          NetworkHelper(url: 'https://jsonplaceholder.typicode.com/todos');
      var ds = await networkHelper.getData();

      setState(() {
        data = ds;
        print(data);
        isnull = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getlistData();
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (data.length == maxlenth) {
      refreshController.loadComplete();
    } else {
      maxlenth = maxlenth + 10;
    }
    if (mounted) setState(() {});
    refreshController.loadComplete();
  }

  @override
  void initState() {
    getlistData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isnull == false
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text('List View'),
            ),
            body: SmartRefresher(
              controller: refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: maxlenth,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(data[index]['id'].toString()),
                        subtitle: Text(data[index]['title']),
                      ),
                    );
                  }),
              footer: CustomFooter(
                builder: (ctx, mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
            ),
          );
  }
}
