import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker_app/models/job.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

class EditAndAddJobPage extends StatefulWidget 
{
  EditAndAddJobPage({@required this.database,this.job});
  final Database database;
  final Job job; 

  static Future<void> show(BuildContext context,{Database database,Job job}) async
  {
    /*
    Below provider contain 'context' of JobsPage because 'show' method is called in JobsPage
    and it provides database object to AddJobPage.
    */
    //final database = Provider.of<Database>(context,listen: false);

    await Navigator.of(context,rootNavigator: true).push
    (
      MaterialPageRoute
      (
        builder: (context)=> EditAndAddJobPage(database: database,job: job,),
        fullscreenDialog: true
      )
        
    );
  }

  @override
  _EditAndAddJobPageState createState() => _EditAndAddJobPageState();
}

class _EditAndAddJobPageState extends State<EditAndAddJobPage> {

  final _formKey = GlobalKey<FormState>();//It define to validate and save form data using globalKey '_formKey'.

  String _name;
  int _ratePerHour;

  @override
  void initState()
  {
    super.initState();
    if(widget.job!=null)
    {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }
  
  bool _validateAndSaveForm()
  {
    final form = _formKey.currentState;//This statement is written to check current state of form.
    if(form.validate())
    {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async
  {
     if(_validateAndSaveForm())
     {
      try
      { 
      //Below line of code will give you most up-to-date snapshot or data present in stream.  
      final jobs = await widget.database.jobsStream().first; 
      final allJobNames = jobs.map((job) =>job.name).toList();
      if(widget.job!=null)
      {
        allJobNames.remove(widget.job.name);
      }
      if(allJobNames.contains(_name))
      {
        showAlertDialog
        (
          context, 
          title: 'Name already used', 
          content:'Please choose a different job name', 
          defaultActionText: 'OK'
        );
      } 
      else
      {
      /*
        ?. is null aware access operator 
        ?? is used to check value is null or not, if the value is null then value of right hand side 
        will be assign to id
       */  
      final id = widget.job?.id ?? documentIdFromCurrentDate();  
      final job = Job(id: id,name: _name,ratePerHour: _ratePerHour);
      await widget.database.setJob(job);
      Navigator.of(context).pop();
      }
      }on FirebaseException catch(e)
      {
        showExceptionAlertDialog(context, title: 'Operation Failed', exception: e);
      }
      
     }
     
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job':'Edit Job'),
        actions: 
        [
          FlatButton
          (
            onPressed:_submit, 
            child:Text
            (
              'Save',
              style: TextStyle
              (
                fontSize: 18,
                color: Colors.white
              ),
            ),
          )
        ],
      ),

      body: _buildContents(),
      backgroundColor: Colors.grey[200],//for changing color of scaffold
    );
  }

  Widget _buildContents()
  {
    return SingleChildScrollView
    (
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card
        (
          child: Padding
          (
            padding: const EdgeInsets.all(16.0),
            child: _buildForm()
          ),
        ),
      ),
    );
  }
  
 Widget _buildForm()
 {
   return Form
   (
     key: _formKey,
     child: Column
     (
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: _buildFormChildren(),
     )
   );
 }

  List <Widget> _buildFormChildren()
  {
     return 
     [
       TextFormField
       (
         decoration: InputDecoration
         (
           labelText:'Job Name'
         ),
         initialValue: _name,
         //validator is used to validate the input as empty or has some value.
         validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty' ,
         onSaved: (value)=> _name = value,//This method will update the local variables and widget rebuild is not required after updating value.
       ),
       TextFormField
       (
         decoration: InputDecoration
         (
           labelText: 'Rate Per Hour',
         ),
         initialValue: _ratePerHour!=null ? '$_ratePerHour' : null,
         //Below line of code is written to show the numeric keyboard to the user
         keyboardType: TextInputType.numberWithOptions(signed:false,decimal: false) ,
         validator: (value) => value.isNotEmpty ? null : 'ratePerHour can\'t be empty',
         onSaved: (value)=> _ratePerHour = int.tryParse(value) ?? 0,
       )
     ];
  }

}


