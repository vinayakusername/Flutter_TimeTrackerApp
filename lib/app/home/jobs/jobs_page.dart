
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/job_entries/job_entries_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/edit_and_add_job_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/job_list_tile.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/list_items_builder.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker_app/models/job.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {

  
/*
  Because methods(_signOut and _confirmSignOut) are transfere to account page.

  //Global Accessing FirebaseAuth Service to use Authentication service using singleton object which is 'instance'
  Future<void>_signOut(BuildContext context) async
  {
    
    try
    {
     final auth = Provider.of<AuthBase>(context,listen: false); 
     await auth.signOut();
    }catch(e)
    {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async
  {
    final didRequestSignOut = await showAlertDialog
     (
       context, 
       title: 'LogOut', 
       content: 'Are you sure that you want to logout?',
       cancelActionText: 'Cancel', 
       defaultActionText: 'LogOut'
       
     );

     if(didRequestSignOut == true)
     {
       _signOut(context);
     }
  }
*/

//Below method is created to delete the job from the list.
 Future<void> _delete(BuildContext context,Job job)async
  {
    try
    {
    
    final database = Provider.of<Database>(context,listen: false);
    await database.deleteJob(job);

    }on FirebaseException catch(e)
    {
      showExceptionAlertDialog
      (
        context, 
        title: 'Operation failed', 
        exception: e
      );
    }
    
  }

/*
  Future<void> _createJob(BuildContext context) async
  {
    try
    {
     final database = Provider.of<Database>(context,listen: false);
     await database.createJob(Job(name: 'Blogging',ratePerHour: 10));
    } on FirebaseException catch(e)
    {
      showExceptionAlertDialog
      (
        context, 
        title: 'Operation Failed', 
        exception:e
      );
    }
  }*/


  @override
  Widget build(BuildContext context) {

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Jobs'),
        actions: 
        [

          IconButton
          (
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed:()=> EditAndAddJobPage.show
                                         (
                                           context,
                                           database:Provider.of<Database>(context,listen: false)
                                         ), 
          ),
         /*
          FlatButton
          (
            onPressed:()=> _confirmSignOut(context), 
            child: Text
            (
            'LogOut',
             style: TextStyle(color: Colors.white,fontSize: 18.0),
            )
          ),*/
          /*
          ElevatedButton
          (
            onPressed:()=> _confirmSignOut(context), 
            child: Text
            (
            'LogOut',
             style: TextStyle(color: Colors.white,fontSize: 18.0),
            )
          )*/
        ],
      ), 
      
      body: _buildContents(context),
      /*
      floatingActionButton: FloatingActionButton
      (
        child: Icon(Icons.add),
        onPressed:()=> EditAndAddJobPage.show
                                         (
                                           context,
                                           database:Provider.of<Database>(context,listen: false)
                                         ),
      ),*/ 
    );
  }

  Widget _buildContents(BuildContext context)
  {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<List<Job>>
    (
      stream: database.jobsStream(),
      builder:(context,snapshot)
      {
       return ListItemsBuilder<Job>
         (
           snapshot: snapshot,
           itemBuilder: (context,job)=> Dismissible
                                        (
                                          key: Key('job - ${job.id}'),
                                          background: Container(color:Colors.red),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (direction) => _delete(context,job),
                                          child: JobListTile
                                                 (
                                                   job: job,
                                                   onTap:()=> JobEntriesPage.show(context,job),
                                                 ),
                                        ),
         );
        
      },
    );

   
  }

}