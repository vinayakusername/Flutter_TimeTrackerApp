
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/account/account_page.dart';
import 'package:flutter_time_tracker_app/app/home/cupertino_home_scaffold.dart';
import 'package:flutter_time_tracker_app/app/home/entries/entries_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/jobs_page.dart';
import 'package:flutter_time_tracker_app/app/home/tab_item.dart';


//This HomePage will manage the state of three different tabs and it will also keeps tracks of tabs.
class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{

  TabItem _currentTab = TabItem.jobs;

  
  /*
   Below map variable is created to assign GobalKey to each TabItem so that we can manage 
   NavigationState.
   */
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys =
  { 
    TabItem.jobs: GlobalKey<NavigatorState> (),
    TabItem.entries: GlobalKey<NavigatorState> (),
    TabItem.account: GlobalKey<NavigatorState> (),
  };

 /*
   Below getter method will return widgets with respect of TabItem.
  */
  Map<TabItem,WidgetBuilder> get widgetBuilder
  {
    return
    {
       TabItem.jobs: (_) => JobsPage(), //_ underScore is used when we are not using 'context' as a argument.
       TabItem.entries: (context) => EntriesPage.create(context), //_ underScore is used when we are not using 'context' as a argument.
       TabItem.account: (_) => AccountPage(), //_ underScore is used when we are not using 'context' as a argument.
    };
   

  }


  void _select(TabItem tabItem)
  {
    //Below code is written to add pop to root navigator.
    if(tabItem == _currentTab)
    {
      //pop to first route by pressing on back button of android phone
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }
    else
    {
       setState(() 
       {
        _currentTab = tabItem;
       });
    }
  }

  @override
  Widget build(BuildContext context) {

    //With the willPopScope and NavigatorKeys we are handling the back button of android
    return WillPopScope
    (
      onWillPop:() async => !await navigatorKeys[_currentTab].currentState.maybePop() ,
      child: CupertinoHomeScaffold
      (
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilder: widgetBuilder,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}