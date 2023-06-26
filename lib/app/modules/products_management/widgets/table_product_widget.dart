import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fire_pos/app/components/custom_elevated_button_widget.dart';
import 'package:flutter_fire_pos/app/data/providers/table_provider.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textformfield_widget.dart';
import '../../../data/model/product_model.dart';
import '../../../data/providers/product_provider.dart';
import '../../../theme/text_theme.dart';

class TableProductWidget extends StatelessWidget {
  const TableProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, TableProvider>(
      builder: (context, productsProvider, tableProvider, child) {
        List<Product> products = productsProvider.products;
        int itemsPerPage = tableProvider.itemsPerPageProduct;
        int currentPage = tableProvider.currentPageProduct;

        int startIndex = currentPage * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        if (endIndex > products.length) {
          endIndex = products.length;
        }
        List<Product> pageProducts = products.sublist(startIndex, endIndex);

        return Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Table(
              border: TableBorder.all(width: 0.2),
              columnWidths: const {
                0: FlexColumnWidth(0.3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(0.8),
              },
              children: [
                TableRow(
                  children: [
                    tableCellWidget(
                      title: 'ID',
                      fontWeight: FontWeight.w600,
                      onTap: () => tableProvider.sortProducts('ID'),
                    ),
                    headerTableCellWidget(
                      title: 'Product Name',
                      onTap: () => tableProvider.sortProducts('Product Name'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Category',
                      onTap: () => tableProvider.sortProducts('Category'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Stock',
                      onTap: () => tableProvider.sortProducts('Stock'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Selling Price',
                      onTap: () => tableProvider.sortProducts('Selling Price'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Basic Price',
                      onTap: () => tableProvider.sortProducts('Basic Price'),
                      fontWeight: FontWeight.w600,
                    ),
                    tableCellWidget(
                      title: 'Action',
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                ...pageProducts.map((product) {
                  return TableRow(
                    children: [
                      tableCellWidget(title: '${product.id}'),
                      tableCellWidget(
                        title: product.name,
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: product.category,
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: product.stock.toString(),
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: "Rp ${product.sellingPrice}",
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: "Rp ${product.basicPrice}",
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: MyColors.grey,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Delete Product',
                                          style: MyTextTheme.defaultStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this product?',
                                          style: MyTextTheme.defaultStyle(),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Cancel',
                                              style: MyTextTheme.defaultStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Delete',
                                              style: MyTextTheme.defaultStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              productsProvider.deleteProduct(
                                                  "${product.id}");
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                tooltip: 'Add Stock',
                                icon: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: MyColors.grey,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController quantityController =
                                          TextEditingController();

                                      return AlertDialog(
                                        title: Text(
                                          'Update Stock',
                                          style: MyTextTheme.defaultStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: CustomTextFormFieldWidget(
                                          labelText: 'Stock',
                                          controller: quantityController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                        actions: [
                                          SizedBox(
                                            width: 80,
                                            height: 36,
                                            child: CustomElevatedButtonWidget(
                                              title: 'Cancel',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              radius: 8,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            height: 36,
                                            child: CustomElevatedButtonWidget(
                                              title: 'Update',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              radius: 8,
                                              onPressed: () async {
                                                await productsProvider
                                                    .updateStock(
                                                        "${product.id}",
                                                        quantityController);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        );
      },
    );
  }

  TableCell tableCellWidget({
    String title = '',
    AlignmentGeometry alignment = Alignment.center,
    double left = 0,
    FontWeight fontWeight = FontWeight.w400,
    void Function()? onTap,
  }) {
    return TableCell(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: left),
          height: 40,
          alignment: alignment,
          child: Text(
            title,
            style: MyTextTheme.defaultStyle(
              color: Colors.black,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }

  TableCell headerTableCellWidget({
    String title = '',
    AlignmentGeometry alignment = Alignment.center,
    FontWeight fontWeight = FontWeight.w400,
    void Function()? onTap,
  }) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        alignment: alignment,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: MyTextTheme.defaultStyle(
                  color: Colors.black,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.import_export_outlined,
                  size: 18.0,
                  color: MyColors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
