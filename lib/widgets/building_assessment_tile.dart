import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/BuildingAssessment/building_assessment.dart';

class BuildingAssessmentTile extends StatefulWidget {
  final BuildingAssessment? entry;
  final List<Widget>? buildingParts;

  const BuildingAssessmentTile({Key? key, this.entry, this.buildingParts})
      : super(key: key);

  @override
  State<BuildingAssessmentTile> createState() => _BuildingAssessmentTileState();
}

class _BuildingAssessmentTileState extends State<BuildingAssessmentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(150, 132, 20, 57),
        ),
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 35, bottom: 10, left: 40, right: 40),
                child: Text(
                  'Building Assessment #' + widget.entry!.id.toString(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 35, bottom: 10, left: 40, right: 40),
                child: Row(children: [
                  const Icon(Icons.event_available),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(DateFormat.yMMMd()
                        .format(widget.entry!.appointmentDate as DateTime)),
                  )
                ]),
              ),
            ],
          ),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Appointment Date:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                            DateFormat.yMMMMd().format(
                                widget.entry!.appointmentDate as DateTime),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Number of Apartments:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(widget.entry!.numOfAppartments.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Voluntary Deduction:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(widget.entry!.voluntaryDeduction.toString() + " %",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Assessment Fee:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(widget.entry!.assessmentFee.toString() + " €",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 150),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 40),
                          child: Row(
                            children: [
                              const Text(
                                'Description:    ',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(widget.entry!.description.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 65),
                          child: Row(
                            children: [
                              const Text(
                                'Assessment Cause:    ',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(widget.entry!.assessmentCause.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 225, 225, 225)))
                            ],
                          )),
                    ])),
          ]),
          Padding(
              padding: const EdgeInsets.only(
                  bottom: 25, top: 10, left: 25, right: 25),
              child: Theme(
                  data: ThemeData()
                      .copyWith(dividerColor: Color.fromARGB(0, 246, 0, 0)),
                  child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      title: const Text(
                        'Building parts',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      children: widget.buildingParts as List<Widget>)))
        ]));
  }
}
