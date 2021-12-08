import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Job
{
  Job({@required this.id,@required this.name, @required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

//fromMap() method is used to read or fetch the data from firestore and convert it a List rather than map.
  factory Job.fromMap(Map<String,dynamic> data,String documentId)
  {
    if(data == null)
    {
      return null;
    }
    final String name = data['name'];
    if(name==null){return null;}
    final int ratePerHour = data['ratePerHour'];

    return Job
    (
      id: documentId,
      name: name,
      ratePerHour: ratePerHour
    );
  }

//toMap() method will convert the normal data into key-value pair
  Map<String,dynamic> toMap()
  {
    return 
    {
      'name': name,
      'ratePerHour': ratePerHour
    };
  } 

 /*
   hashCode is single integer which represents state of objects that affects == comparison
 */
  @override
  // TODO: implement hashCode
  int get hashCode => hashValues(id, name,ratePerHour);

  /* == operator is used to compare objects of different types */
  @override
  bool operator ==(other)
  {
    //Below condition is written to check that object in the same memory are equal or not.
    if(identical(this, other))
    return true;
    //Below condition is written to check that object should be same as of current object.
    if(runtimeType!= other.runtimeType)
    return false;
    final Job otherJob = other;//statement depicts that other object is of type Job.
    return id == otherJob.id && name == otherJob.name && ratePerHour == otherJob.ratePerHour;
  }

   /*Always override toString() method for better diagionstics when test case fail. */
  @override
  String toString() => 'id : $id,name:$name,ratePerHour:$ratePerHour';
}