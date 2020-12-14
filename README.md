# scrollable_list_tabview

[![Build Status](https://travis-ci.com/firatcetiner/scrollable_list_tabview.svg?branch=main)](https://travis-ci.com/firatcetiner/scrollable_list_tabview)
[![Codemagic build status](https://api.codemagic.io/apps/5fab163fe55b87e07bbfb1c6/5fab163fe55b87e07bbfb1c5/status_badge.svg)](https://codemagic.io/apps/5fab163fe55b87e07bbfb1c6/5fab163fe55b87e07bbfb1c5/latest_build)
[![Coverage Status](https://coveralls.io/repos/github/firatcetiner/scrollable_list_tabview/badge.svg?branch=main)](https://coveralls.io/github/firatcetiner/scrollable_list_tabview?branch=main)

A Flutter widget which synchronize a ScrollView and a custom tab view.

The main idea is to create a custom tab view synchronizing with inner ScrollView. The scroll activity will trigger custom tab view at the top to follow the index of the inner scroll view widget.


![Demo](https://media2.giphy.com/media/VkrHmPClMEYkBj5Mkg/giphy.gif)

## Installation
Add dependency for package on your pubspec.yaml:

    dependencies:
	    scrollable_list_tabview: <latest>

## Usage
To use this widget we must first define how our tabs will look like.
### ListTab
|Parameter| Definition |
|--|--|
| `Widget icon` |Trailing widget for a tab, typically an Icon.|
|`Widget label`|Label to be shown in the tab, must be non-null.|
| `BorderRadiusGeometry borderRadius`|BorderRadius value for a single tab.|
|`Color activeBackgroundColor`|Color to be used when the tab is selected.|
|`Color inactiveBackgroundColor`| Color to be used when the tab isn't selected.|
|`bool showIconInList`| Decide whether show icon widget in the scrollable view.|
| `Color borderColor`| Color of the border of tab when its not selected|

Then we can use LisTab in ScrollableListTab.
### ScrollableListTab
|Parameter| Definition |
|--|--|
| `ListTab tab` |Data model used for rendering tab widgets.|
|`ScrollView body`|An individual inner scrollable widget.|

Then ScrollableListTabView will take a list of ScrollableListTab as an argument.

### ScrollableListTabView
|Parameter| Definition |
|--|--|
| `List<ScrollableListTab> tabs`|List of tabs to be built.|
|`double height`|Height of the tab at the top of the view.|
| `Duration tabAnimationDuration`|Duration of tab change animation.|
|`Duration bodyAnimationDuration`|Duration of inner scroll view animation.|
| `Curve tabAnimationCurve`|Animation curve used when animating tab change.|
|`Curve bodyAnimationCurve`|Animation curve used when changing index of inner ScrollView(s).|

## Example

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
      MyHomePage({Key key, this.title}) : super(key: key);

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
          body: ScrollableListTabView(
            tabHeight: 48,
            tabs: [
              ScrollableListTab(
                  tab: ListTab(label: Text('Label 1'), icon: Icon(Icons.group)),
                  body: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (_, index) => ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        alignment: Alignment.center,
                        child: Text(index.toString()),
                      ),
                      title: Text('List element $index'),
                    ),
                  )),
            ],
          ),
        );
      }
    }




## Limitations & Considerations
There are some limitations on this package. For example we only support ScrollView to be the body. Also, we could have used `builder` pattern to build the widgets.

I would like to thank Google developers for creating awesome package called [ScrollablePositionedList](https://pub.dev/packages/scrollable_positioned_list).


## Contribution
Contributions are accepted via pull requests. For more information about how to contribute to this package, please check the [contribution guide](https://github.com/firatcetiner/scrollable_list_tabview/blob/master/CONTRIBUTION.md).

## License
This project is licensed under the MIT license, additional knowledge about the license can be found [here](https://github.com/firatcetiner/scrollable_list_tabview/blob/master/LICENSE).




