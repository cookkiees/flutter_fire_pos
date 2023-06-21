import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textformfield_widget.dart';
import '../../../data/providers/product_provider.dart';
import '../../../theme/text_theme.dart';

class AddNewMenuWidget extends StatelessWidget {
  const AddNewMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add new menu',
            style: MyTextTheme.defaultStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          InkWell(
            onTap: () {
              productProvider.resetFields();
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
                  controller: productProvider.nameController,
                  errorText: productProvider.errorName,
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
                Consumer<ProductProvider>(
                  builder: (BuildContext context,
                      ProductProvider productProvider, Widget? child) {
                    return CustomTextFormFieldWidget(
                      labelText: 'Category',
                      controller: productProvider.categoryController,
                      errorText: productProvider.errorCategories,
                      suffixIcon: PopupMenuButton<String>(
                        splashRadius: 16,
                        tooltip: '',
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onSelected: (selectedValue) {
                          productProvider.categoryController.text =
                              selectedValue;
                        },
                        itemBuilder: (BuildContext context) {
                          return productProvider.categories
                              .map((String category) {
                            return PopupMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList();
                        },
                      ),
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
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: CustomTextFormFieldWidget(
                        labelText: 'Stock',
                        controller: productProvider.stockController,
                        errorText: productProvider.errorStock,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 2,
                      child: CustomTextFormFieldWidget(
                        labelText: 'Basic Price',
                        controller: productProvider.basicController,
                        errorText: productProvider.errorBasicPrice,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 2,
                      child: CustomTextFormFieldWidget(
                        labelText: 'Selling Price',
                        controller: productProvider.sellingController,
                        errorText: productProvider.errorSellingPrice,
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
              productProvider.duplicateProductName,
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
                  await productProvider.addProduct();
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
