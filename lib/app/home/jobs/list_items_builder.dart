import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/empty_content.dart';

/*
  typedef is a alias function and it is used to create user define function in flutter for other 
  application function.

  So here ItemWidgetBuilder is variable of type 'T' and it holds widget return by a 'Function'
  of type widget and it takes two parameters 1. context 2. item of type 'T'
 */
typedef ItemWidgetBuilder <T> = Widget Function(BuildContext context,T item);

class ListItemsBuilder<T> extends StatelessWidget 
{
  const ListItemsBuilder({ Key  key,@required this.snapshot, @required this.itemBuilder }) : super(key: key);
  
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
   
  @override
  Widget build(BuildContext context) 
  {
     if(snapshot.hasData)
     {
       final List<T> items = snapshot.data;
       if(items.isNotEmpty)//This code manage data state of UI
       {
          return _buildList(items); 
       }
      else
       {
         return EmptyContent(); //This code manage empty state of UI.
       }
     }
     else if(snapshot.hasError) //This code manage error state of UI.
     {
       EmptyContent
       (
         title: 'Something went wrong',
         message: 'Can\'t load items right now',
       );   
     }

     return Center(child: CircularProgressIndicator(),);//This code manage loading state.
  }

  Widget _buildList(List<T> items)
  {
    return ListView.separated
    (

       itemCount: items.length,
      //itemCount: items.length + 2,//itemCount is increased by 2 because to add to add divider at the begining and at the end of list items.
      separatorBuilder: (context,index) => Divider(height: 0.5,),
      itemBuilder:(context,index)
      {
        /*
        Extra code is written to add the divider at the begining and at the end of list items 
        by returning container as an list item.
        */
        //  if(index == 0||index == items.length-1)
        //  {
        //    return Container();
        //  }
        //return itemBuilder(context,items[index - 1]);
         return itemBuilder(context,items[index]);

      }
    );
  }
}
