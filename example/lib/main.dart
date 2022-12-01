import 'package:flutter/material.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter ScrollableListTabView Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        child: ScrollableListTabView(
          backgroundColor: Colors.white,
          automaticallyImplyLeading:false,
          pinned: true,
          paddingBody:EdgeInsets.symmetric(horizontal:16),
          paddingTab:EdgeInsets.symmetric(horizontal:12),
          floating:true,
          expandedHeight: 270,
          tabHeight: 37,
          highlightColor: Colors.white,
          splashColor: Colors.white,
          bgrTabColor: Colors.amber,
          bodyAnimationDuration: const Duration(milliseconds: 150),
          tabAnimationCurve: Curves.easeOut,
          tabAnimationDuration: const Duration(milliseconds: 200),
          tabs: [
            ScrollableListTab(
              tab: ListTab(
                labelTab: 'Label 1',
                title: Text('Bất động sản'),
                activeBackgroundColor:Colors.blue,
                inactiveBackgroundColor:Colors.red,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (_, index) => ListTile(
                  title: Text('List element $index'),
                ),
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
               labelTab: 'Label 1',
                title: Text('Label 1') ,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 11,
                itemBuilder: (_, index) => ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text('List element $index'),
                ),
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                labelTab: 'Label 1',
                title: Text('Label 1') ,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 11,
                itemBuilder: (_, index) => ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text('List element $index'),
                ),
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                labelTab: 'Label 1',
                title: Text('Label 1') ,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 11,
                itemBuilder: (_, index) => ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text('List element $index'),
                ),
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                labelTab: 'Label 1',
                title: Text('Label 1') ,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 11,
                itemBuilder: (_, index) => ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text('List element $index'),
                ),
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                labelTab: 'Label 1',
                title: Text('Label 1') ,
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (_, index) => ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text('List element $index'),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
