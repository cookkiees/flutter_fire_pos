import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textformfield_widget.dart';
import '../../../data/providers/consumer_provider.dart';
import '../../../theme/text_theme.dart';

class AddConsumersWidget extends StatelessWidget {
  const AddConsumersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumersProvider = context.watch<ConsumersProvider>();

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add new consumers',
            style: MyTextTheme.defaultStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          InkWell(
            onTap: () {
              consumersProvider.resetFields();
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.clear,
              size: 24.0,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                CustomTextFormFieldWidget(
                  labelText: 'Name',
                  controller: consumersProvider.nameController,
                  errorText: consumersProvider.errorName,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isNotEmpty) {
                        final capitalizedValue =
                            '${newValue.text[0].toUpperCase()}${newValue.text.substring(1).toLowerCase()}';
                        if (capitalizedValue != newValue.text) {
                          return TextEditingValue(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                              offset: capitalizedValue.length,
                            ),
                          );
                        }
                      }
                      return newValue;
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextFormFieldWidget(
                  labelText: 'Address',
                  controller: consumersProvider.addressController,
                  errorText: consumersProvider.errorAddress,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isNotEmpty) {
                        final capitalizedValue =
                            '${newValue.text[0].toUpperCase()}${newValue.text.substring(1).toLowerCase()}';
                        if (capitalizedValue != newValue.text) {
                          return TextEditingValue(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                              offset: capitalizedValue.length,
                            ),
                          );
                        }
                      }
                      return newValue;
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: CustomTextFormFieldWidget(
                        labelText: 'Phone Number',
                        controller: consumersProvider.phoneNumberController,
                        errorText: consumersProvider.errorPhoneNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              consumersProvider.duplicateConsumersName,
              style: MyTextTheme.defaultStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await consumersProvider.addConsumer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: Text(
                  'Submit',
                  style: MyTextTheme.defaultStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
