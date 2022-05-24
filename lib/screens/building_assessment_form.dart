import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

import '../models/BuildingPart/construction_class.dart';
import '../models/BuildingPart/fire_protection.dart';
import '../models/BuildingPart/insured_type.dart';
import '../models/BuildingPart/risk_class.dart';
import '../models/Database/database_helper.dart';
import '../models/Measurement/measurement.dart';
import '../services/sqs_sender.dart';
import '../widgets/alert.dart';

class BuildingAssessmentForm extends StatefulWidget {
  final BuildingAssessment? buildingAssessment;
  const BuildingAssessmentForm({Key? key, this.buildingAssessment})
      : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingAssessment buildingAssessment = BuildingAssessment();

  @override
  void initState() {
    buildingAssessment = widget.buildingAssessment ?? BuildingAssessment();
    super.initState();
  }

  final SQSSender sqsSender = SQSSender();

  void sendMessage(String message) async {
    try {
      await sqsSender.sendToSQS(message);
      showDialogPopup("Info", "Assessment successfully sent.");
    } catch (e) {
      showDialogPopup("Error", "Assessment not sent.");
    }
  }

  void showDialogPopup(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Alert(title: title, content: content);
        });
  }

  // // Locally save order to users device
  void localSave() async {
    BuildingAssessment assessment = await DatabaseHelper.instance
        .createAssessment(buildingAssessment, buildingAssessment.buildingParts);

    print(assessment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  OutlinedButton.icon(
                    label: const Text("History"),
                    icon: const Icon(Icons.history),
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      )
                    },
                  ),
                  OutlinedButton.icon(
                    label: const Text("Settings"),
                    icon: const Icon(Icons.settings),
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      )
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        CustomDateFormField(
                          initialValue: buildingAssessment.appointmentDate,
                          onDateSaved: (newValue) => {
                            setState((() => {
                                  buildingAssessment.appointmentDate = newValue
                                }))
                          },
                        ),
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: "Description",
                          initialValue: buildingAssessment.description,
                          onChanged: (newValue) => {
                            setState(() =>
                                {buildingAssessment.description = newValue})
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: "Assessment Cause",
                          initialValue: buildingAssessment.assessmentCause,
                          onChanged: (newValue) => {
                            setState(() =>
                                {buildingAssessment.assessmentCause = newValue})
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          labelText: "Number of Apartments",
                          initialValue:
                              buildingAssessment.numOfAppartments.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.numOfAppartments =
                                      int.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.numberOfApartmentsValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Voluntary Deduction",
                          initialValue:
                              buildingAssessment.voluntaryDeduction.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.voluntaryDeduction =
                                      double.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.floatValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Assessment Fee",
                          initialValue:
                              buildingAssessment.assessmentFee.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.assessmentFee =
                                      double.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.floatValidator(value!),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        AddObjectsSection(
                          objectType: ObjectType.buildingPart,
                          buildingAssessment: buildingAssessment,
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BuildingPartForm(
                                  buildingAssessment: buildingAssessment,
                                ),
                              ),
                            )
                          },
                        ),
                        OutlinedButton(
                            onPressed: () {
                              // Validates form
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sending..')),
                                );
                                _formKey.currentState!.save();

                                //TODO: Remove for production!
                                print(buildingAssessment.toMessage());
                                localSave();
                                sendMessage(
                                    buildingAssessment.toMessage().toString());
                              }
                            },
                            child: const Text("Send"))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
