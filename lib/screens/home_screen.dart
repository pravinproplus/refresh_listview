import 'package:flutter/material.dart';
import 'package:listview_task/network/network_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data;
  bool isnull = false;

  Future getlistData() async {
    try {
      NetworkHelper networkHelper =
          NetworkHelper(url: 'https://jsonplaceholder.typicode.com/todos');
      var ds = await networkHelper.getData();

      setState(() {
        data = ds;
        isnull = true;
      });
    } catch (e) {
      print(e);
    }
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
            body: RefreshIndicator(
              onRefresh: getlistData,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
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
            ),
          );
  }
}
