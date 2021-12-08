import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/models/job.dart';

class JobListTile extends StatelessWidget 
{
  const JobListTile({ Key key,@required this.job,this.onTap }) : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile
    (
      title: Text
              (
                job.name,
                style: TextStyle
                      (
                        fontSize: 10.0
                      ),
              ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}