// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class TestingWidget extends StatefulWidget {
  const TestingWidget({Key? key}) : super(key: key);

  @override
  State<TestingWidget> createState() => _TestingWidgetState();
}

class _TestingWidgetState extends State<TestingWidget> {
  @override
  void initState() {
    // Field.updateFieldList = [
    //   {
    //     'firstName': [
    //       {'name': 'Makwaya Jacb', 'uid': 'trgf6ryr7r6rt'},
    //       {'name': 'Mwajuma Hassan', 'uid': 'fdvcgt64598uy'}
    //     ],
    //   },
    //   {'checkBox': true},
    //   {'toggleCheck': true},
    //   {'dateTime': '2022-03-04'},
    //   {
    //     'middleName': 'Kibwana',
    //   },
    //   {
    //     'lastName': {'name': 'Majaliwa Hassan', 'uid': '657ryrt575yt57'},
    //   }
    // ];
    Toast.init(context);
    super.initState();
  }

  TextInput textInput = TextInput();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   width: 300,
            //     child: FilePicker(onFileSelected: (value) {})),

            SizedBox(
              child: ElevatedButton(
                  child: const Text('Save Data'),
                  onPressed: () {
                    PopupModel(
                        endpointName: 'saveAgent',
                        queryFields: 'uid name',
                        responseResults: (response, onLoad) {},
                        checkUnSavedData: true,
                        buildContext: context,
                        buttonLabel: 'Save Test',
                        iconButton: Icons.save_outlined,
                        title: 'Testing Model',
                        formGroup: FormGroup(
                          updateFields: [
                            {'fullName': 'Juma Hassan Kimaro'},
                            {'mobileNumber': '0753332777'},
                            {'nationality': 'Tanzanian'},
                            {
                              'region': [
                                {'name': 'Mwanza', 'uid': '87887g8g'}
                              ]
                            },
                          ],
                          group: [
                            Group(header: "Test's info", children: [
                              Field.use.input(
                                context: context,
                                label: 'Full Name',
                                key: 'fullName',
                                fieldInputType: FieldInputType.FullName,
                                validate: true,
                                widthSize: WidthSize.col3,
                              ),
                              Field.use.input(
                                context: context,
                                label: 'Mobile Number',
                                key: 'mobileNumber',
                                fieldInputType: FieldInputType.MobileNumber,
                                validate: true,
                                widthSize: WidthSize.col3,
                              ),
                              Field.use.input(
                                context: context,
                                label: 'Citizenship',
                                key: 'nationality',
                                fieldInputType: FieldInputType.Other,
                                validate: true,
                                widthSize: WidthSize.col3,
                              ),
                              Field.use.multiSelect(
                                context: context,
                                // customDisplayKey: 'name',
                                label: 'Region',
                                items: [
                                  {'name': 'Mwanza', 'uid': '87887g8g'},
                                  {'name': 'Arusha', 'uid': 'tfy6565f6'}
                                ],
                                key: 'region',
                                isPageable: false,
                                fieldInputType: FieldInputType.Other,
                                validate: true,
                                widthSize: WidthSize.col3,
                              ),
                            ]),
                            // Group(
                            //   header: "Another info",
                            //     children: [
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Full Name',
                            //         key: 'fullName',
                            //         fieldInputType: FieldInputType.FullName,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Mobile Number',
                            //         key: 'mobileNumber',
                            //         fieldInputType: FieldInputType.MobileNumber,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Citizenship',
                            //         key: 'nationality',
                            //         fieldInputType: FieldInputType.Other,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.select(
                            //         context: context,
                            //         label: 'Region',
                            //         items: [{'name':'Mwanza'},{'name':'Arusha'}],
                            //         key: 'region',
                            //         fieldInputType: FieldInputType.Other,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //     ]),
                            // Group(
                            //   header: "Third info",
                            //     children: [
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Full Name',
                            //         key: 'fullName',
                            //         fieldInputType: FieldInputType.FullName,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Mobile Number',
                            //         key: 'mobileNumber',
                            //         fieldInputType: FieldInputType.MobileNumber,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.input(
                            //         context: context,
                            //         label: 'Citizenship',
                            //         key: 'nationality',
                            //         fieldInputType: FieldInputType.Other,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //       Field.use.select(
                            //         context: context,
                            //         label: 'Region',
                            //         items: [{'name':'Mwanza'},{'name':'Arusha'}],
                            //         key: 'region',
                            //         fieldInputType: FieldInputType.Other,
                            //         validate: true,
                            //         widthSize: WidthSize.col3,
                            //       ),
                            //     ]),
                          ],
                        )).show();
                  }),
            ),
          ],
        )
        // GElevatedButton(
        //     'Show Pop', onPressed: (){
        //   PopUpModelService(
        //       context: context
        //   ).show();
        // })
        ,
      ),
    );
  }
}
