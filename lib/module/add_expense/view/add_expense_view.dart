import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class AddExpensePageView extends StatefulWidget {
  const AddExpensePageView({Key? key}) : super(key: key);

  Widget build(context, AddExpenseController controller) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Add New Expense",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "ADD Expense",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            QTextField(
              label: "Expense Name",
              validator: Validator.required,
              hint: "Type expense name",
              onChanged: (value) {
                controller.nama = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QRadioField(
              label: "Category",
              validator: Validator.atLeastOneitem,
              items: [
                {
                  "label": "Primer",
                  "value": "primer",
                },
                {
                  "label": "Sekunder",
                  "value": "sekunder",
                },
                {
                  "label": "Tersier",
                  "value": "tersier",
                },
                {
                  "label": "Pendidikan",
                  "value": "pendidikan",
                }
              ],
              onChanged: (value, label) {
                print(value);
                controller.category = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QTextField(
              label: "Item Name",
              validator: Validator.required,
              hint: "Type item name",
              onChanged: (value) {
                controller.itemName = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QNumberField(
              label: "Amount",
              validator: Validator.required,
              hint: "Type amount of expense",
              onChanged: (value) {
                num? parsedValue = num.tryParse(value);
                if (parsedValue != null) {
                  controller.amount = parsedValue;
                } else {
                  print("Error: Nilai tidak valid");
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            QDatePicker(
              label: "Date",
              validator: Validator.required,
              onChanged: (value) {
                controller.date = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Upload Attachment",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            QImagePicker(
              label: "Photo",
              validator: Validator.required,
              value: null,
              onChanged: (value) {
                controller.photo = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9B51E0),
                ),
                onPressed: () => controller.DoAddExpense(),
                child: const Text("Request Expense"),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }

  State<AddExpensePageView> createState() => AddExpenseController();
}
