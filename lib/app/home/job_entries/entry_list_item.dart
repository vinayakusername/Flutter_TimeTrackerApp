import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/job_entries/format.dart';
import 'package:flutter_time_tracker_app/models/entry.dart';
import 'package:flutter_time_tracker_app/models/job.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.job,
    @required this.onTap,
  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start);
    final startDate = Format.date(entry.start);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = Format.hours(entry.durationInHours);

    final pay = job.ratePerHour * entry.durationInHours;
    final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
          /*
            Below if(job.ratePerHour>0) Condition is known as Collection-if in dart.
            It will adds elements to a collection if condition is true.

            '...' three dot is known as spread operator and it is used to add a list of items to 
            a collection and it is done by unpacking the elements in the list
           */
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('$startTime - $endTime', style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment.isNotEmpty)
          Text(
            entry.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.job,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
