// import 'package:flutter/material.dart';
//
// class TimePickerTile extends StatefulWidget {
//   const TimePickerTile();
//
//   @override
//   State<TimePickerTile> createState() => _TimePickerTileState();
// }
//
// class _TimePickerTileState extends State<TimePickerTile> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     TimeOfDay? scheduledTime;
//     String minutes = '';
//     if (scheduledTime != null) {
//       scheduledTime.minute.toString().length == 1
//           ? minutes = '0${scheduledTime.minute}'
//           : minutes = scheduledTime.minute.toString();
//     }
//
//     Future<TimeOfDay?> pickSchedule(BuildContext context) async {
//       DateTime now = DateTime.now();
//       TimeOfDay? timeOfDay = await showTimePicker(
//         builder: (BuildContext context, Widget? child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//             child: child!,
//           );
//         },
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(
//           now.add(
//             const Duration(minutes: 1),
//           ),
//         ),
//       );
//       return timeOfDay;
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: width * 0.04, vertical: height * 0.01),
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: Theme.of(context).colorScheme.primary, width: 2),
//           color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: () async {
//           TimeOfDay? scheduledTime = await pickSchedule(context);
//           setState(() {
//             scheduledTime = scheduledTime;
//           });
//         },
//         child: Row(
//           children: [
//             Text(
//               subject.scheduledTime == null
//                   ? 'Schedule notification ->'
//                   : 'Scheduled at ${subject.scheduledTime.hour}:$minutes',
//               style: Theme.of(context).primaryTextTheme.labelLarge,
//             ),
//             const Spacer(),
//             subject.scheduledTime != null
//                 ? InkWell(
//               child: const Icon(Icons.delete),
//               onTap: () {
//                 subject.setScheduledTime(null);
//               },
//             )
//                 : Container(),
//             SizedBox(
//               width: width * 0.01,
//             ),
//             Icon(subject.scheduledTime == null
//                 ? Icons.notification_add
//                 : Icons.notifications_active)
//           ],
//         ),
//       ),
//     );
//   }
// }
