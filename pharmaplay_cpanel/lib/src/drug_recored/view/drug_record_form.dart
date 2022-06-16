import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cross_file/cross_file.dart';

import 'dart:io';
import 'dart:typed_data';

//import 'package:xfile/xfile.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:pharma_repository/pharma_repository.dart';
import 'package:pharmaplay_cpanel/src/drug_recored/drug_record.dart';

//import 'data.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:pharmaplay_cpanel/generated/l10n.dart';
import 'package:pharmaplay_cpanel/src/dashboard/dashboard.dart';
import 'package:pharmaplay_cpanel/src/utlites/data_lists.dart';

class ApiImage {
  final String imageUrl;
  final String id;
  ApiImage({
    required this.imageUrl,
    required this.id,
  });
}

class DrugRecordForm extends StatelessWidget {
  const DrugRecordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    return BlocListener<DrugRecordBloc, DrugRecordState>(
      listener: (context, state) {
        print(
            '-------------------Subemission status -----------: ${state.status.toString()} ');
        if (state.status == DrugRecordStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.errMsg}')),
            );
        } else if (state.status == DrugRecordStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(' : ${state.errMsg}')),
            );
        } else if (state.status == DrugRecordStatus.isSubmissionInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(' ${state.errMsg}')),
            );
        }
      },
      child: const DrugFormBuilder(),
    );
  }
}

class DrugFormBuilder extends StatefulWidget {
  const DrugFormBuilder({Key? key}) : super(key: key);

  @override
  State<DrugFormBuilder> createState() => _DrugFormBuilderState();
}

class _DrugFormBuilderState extends State<DrugFormBuilder> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool _DrugNoHasError = false;
  //bool _genderHasError = false;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: getIniailCardValues(context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              FormBuilderTextField(
                autovalidateMode: AutovalidateMode.always,
                name: 'drugNo',
                decoration: InputDecoration(
                  labelText: 'DrugNo',
                  suffixIcon: _DrugNoHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _DrugNoHasError =
                        !(_formKey.currentState?.fields['DrugNo']?.validate() ??
                            false);
                  });
                },
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  //FormBuilderValidators.max(70),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),

//en__brandName

              FormBuilderTextField(
                autovalidateMode: AutovalidateMode.always,
                name: 'en__brandName',
                decoration: InputDecoration(
                  labelText: 'en__brandName',
                  suffixIcon: _DrugNoHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _DrugNoHasError = !(_formKey
                            .currentState?.fields['en__brandName']
                            ?.validate() ??
                        false);
                  });
                },
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  //FormBuilderValidators.numeric(),
                  //FormBuilderValidators.max(70),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),

// ar__brandName

              FormBuilderTextField(
                autovalidateMode: AutovalidateMode.always,
                name: 'ar__brandName',
                decoration: InputDecoration(
                  labelText: 'ar__brandName',
                  suffixIcon: _DrugNoHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _DrugNoHasError = !(_formKey
                            .currentState?.fields['ar__brandName']
                            ?.validate() ??
                        false);
                  });
                },
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  //FormBuilderValidators.numeric(),
                  //FormBuilderValidators.max(70),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
//  drugGroupID

              FormBuilderSearchableDropdown<String>(
                name: 'drugGroupName',
                // items: allCountries,
                onChanged: _onChanged,
                showSearchBox: true,
                isFilteredOnline: true,
                // compareFn: (item, selectedItem) =>
                //     item!.toLowerCase() == selectedItem!.toLowerCase(),
                onFind: (text) async {
                  var resault = await getDrugroupsStringslist(context);

                  return resault
                      .where((element) => element
                          .toString()
                          .toLowerCase()
                          .contains(text!.toLowerCase()))
                      .toList();
                },
                decoration: const InputDecoration(labelText: 'drugGroupName'),
              ),

//======

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderImagePicker(
                    name: 'photos',
                    displayCustomType: (obj) =>
                        obj is ApiImage ? obj.imageUrl : obj,
                    decoration: const InputDecoration(labelText: 'Pick Photos'),
                    maxImages: 1,
                    initialValue: const [
                      // "assets/icons/drop_box.svg",
                      //  "assets/images/logo.png",
                      // 'https://images.pexels.com/photos/8311418/pexels-photo-8311418.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
                    ],
                  ),
                ],
              ),

              //====

              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());

                          try {
                            var val =
                                _formKey.currentState?.fields['photos']!.value;
                            XFile selectedImg = val!.first;
                            debugPrint('changed 1 photo to : ' +
                                selectedImg.path.toString());

                            Uint8List imgbytes1 =
                                await selectedImg.readAsBytes();

                            debugPrint(selectedImg.runtimeType.toString());
                            debugPrint(imgbytes1.toString());

                            // convert to bytes
                            var base64Image = base64Encode(imgbytes1);
                            debugPrint('changed  2 photo to : ' +
                                base64Image.toString());

                            // convert to string

                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
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

Future<List<DrugGroup>> getDrugroupslist(BuildContext context) async {
  var v1 = await DataLists(
          pharmaRepository: context.read<PharmaRepository>(),
          localeUI: context.read<DashBoardBloc>().state.localeUI.languageCode)
      .getDrugroups;
  print(v1);
  return v1;
}

Future<List<String>> getDrugroupsStringslist(BuildContext context) async {
  var v1 = await DataLists(
          pharmaRepository: context.read<PharmaRepository>(),
          localeUI: context.read<DashBoardBloc>().state.localeUI.languageCode)
      .getDrugroupsStrings;
  print('-----');

  print(v1);
  print('-----');
  return v1;
}

Map<String, dynamic> getIniailCardValues(BuildContext context) {
  var values = context.read<DashBoardBloc>().state.drugRecord;
  //Map drugMap = json.decode(values?.drug.toString() ?? '');

  return {
    'drugNo': values?.drug.drugNo ?? 0,
    'ar__brandName': values?.drug.brandName,
    'en__brandName': values?.drug.brandName,
    'drugGroupName':
        '{${values?.drugGroup.drugGroupName.trim()} , ${values?.drugGroup.drugGroupID}}',
  };
}
/*
class DrugFormBuilder extends StatefulWidget {
  const DrugFormBuilder({Key? key}) : super(key: key);

  @override
  State<DrugFormBuilder> createState() => _DrugFormBuilderState();
}

class _DrugFormBuilderState extends State<DrugFormBuilder> {
  final _formKey = GlobalKey<FormBuilderState>();
  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              FormBuilderSearchableDropdown<String>(
                name: 'searchable_dropdown_online',
                // items: allCountries,
                onChanged: _onChanged,
                showSearchBox: true,
                isFilteredOnline: true,
                compareFn: (item, selectedItem) =>
                    item!.toLowerCase() == selectedItem!.toLowerCase(),
                onFind: (text) async {
                  await Future.delayed(const Duration(seconds: 1));
                  return allCountries
                      .where((element) =>
                          element.toLowerCase().contains(text.toLowerCase()))
                      .toList();
                },
                decoration: const InputDecoration(
                    labelText: 'Searchable Dropdown Online'),
              ),
              FormBuilderSearchableDropdown<String>(
                name: 'searchable_dropdown_offline',
                items: allCountries,
                onChanged: _onChanged,
                showSearchBox: true,
                decoration: const InputDecoration(
                    labelText: 'Searchable Dropdown Offline'),
              ),
              const SizedBox(height: 15),
              FormBuilderColorPickerField(
                name: 'color_picker',
                initialValue: Colors.yellow,
                // readOnly: true,
                colorPickerType: ColorPickerType.materialPicker,
                decoration: const InputDecoration(labelText: 'Color Picker'),
              ),
              FormBuilderChipsInput<Contact>(
                decoration: const InputDecoration(labelText: 'Chips Input'),
                name: 'chips_test',
                onChanged: _onChanged,
                maxChips: 5,
                findSuggestions: (String query) {
                  if (query.isNotEmpty) {
                    var lowercaseQuery = query.toLowerCase();
                    return contacts.where((profile) {
                      return profile.name
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          profile.email
                              .toLowerCase()
                              .contains(query.toLowerCase());
                    }).toList(growable: false)
                      ..sort((a, b) => a.name
                          .toLowerCase()
                          .indexOf(lowercaseQuery)
                          .compareTo(
                              b.name.toLowerCase().indexOf(lowercaseQuery)));
                  } else {
                    return const <Contact>[];
                  }
                },
                chipBuilder: (context, state, profile) {
                  return InputChip(
                    key: ObjectKey(profile),
                    label: Text(profile.name),
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(profile.imageUrl),
                    ),
                    onDeleted: () => state.deleteChip(profile),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
                suggestionBuilder: (context, state, profile) {
                  return ListTile(
                    key: ObjectKey(profile),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profile.imageUrl),
                    ),
                    title: Text(profile.name),
                    subtitle: Text(profile.email),
                    onTap: () => state.selectSuggestion(profile),
                  );
                },
              ),
              FormBuilderCupertinoDateTimePicker(
                name: 'date_time',
                initialValue: DateTime.now(),
                inputType: CupertinoDateTimePickerInputType.both,
                decoration: const InputDecoration(
                  labelText: 'Cupertino DateTime Picker',
                ),
                locale: const Locale.fromSubtags(languageCode: 'en_GB'),
              ),
              FormBuilderCupertinoDateTimePicker(
                name: 'date',
                initialValue: DateTime.now(),
                inputType: CupertinoDateTimePickerInputType.date,
                decoration: const InputDecoration(
                  labelText: 'Cupertino DateTime Picker - Date Only',
                ),
                locale: const Locale.fromSubtags(languageCode: 'en_GB'),
              ),
              FormBuilderCupertinoDateTimePicker(
                name: 'time',
                initialValue: DateTime.now(),
                inputType: CupertinoDateTimePickerInputType.time,
                decoration: const InputDecoration(
                  labelText: 'Cupertino DateTime Picker - Time Only',
                ),
                locale: const Locale.fromSubtags(languageCode: 'en_GB'),
              ),
              FormBuilderTypeAhead<String>(
                decoration: const InputDecoration(
                    labelText: 'TypeAhead (Autocomplete TextField)',
                    hintText: 'Start typing country name'),
                name: 'country',
                onChanged: _onChanged,
                itemBuilder: (context, country) {
                  return ListTile(
                    title: Text(country),
                  );
                },
                controller: TextEditingController(text: ''),
                initialValue: 'Uganda',
                suggestionsCallback: (query) {
                  if (query.isNotEmpty) {
                    var lowercaseQuery = query.toLowerCase();
                    return allCountries.where((country) {
                      return country.toLowerCase().contains(lowercaseQuery);
                    }).toList(growable: false)
                      ..sort((a, b) => a
                          .toLowerCase()
                          .indexOf(lowercaseQuery)
                          .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                  } else {
                    return allCountries;
                  }
                },
              ),
              FormBuilderTouchSpin(
                decoration: const InputDecoration(labelText: 'TouchSpin'),
                name: 'touch_spin',
                initialValue: 10,
                step: 1,
                iconSize: 48.0,
                addIcon: const Icon(Icons.arrow_right),
                subtractIcon: const Icon(Icons.arrow_left),
                onChanged: _onChanged,
              ),
              FormBuilderRatingBar(
                decoration: const InputDecoration(labelText: 'Rating Bar'),
                name: 'rate',
                // enabled: false,
                itemSize: 32.0,
                initialValue: 1.0,
                maxRating: 5.0,
                onChanged: _onChanged,
              ),
              FormBuilderSignaturePad(
                decoration: const InputDecoration(
                  labelText: 'Signature Pad',
                ),
                name: 'signature',
                border: Border.all(color: Colors.green),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
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
*/

