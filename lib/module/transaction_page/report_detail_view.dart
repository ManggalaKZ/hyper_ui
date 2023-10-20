import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class ReportDetailView extends StatelessWidget {
  final String documentId;

  ReportDetailView({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('report').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("Report not found");
        } else {
          var data = snapshot.data?.data() as Map<String, dynamic>;

          var reportName = data['reportName'] ?? 'null';
          var name = data['name'] ?? 'null';
          var university = data['university'] ?? 'null';
          var major = data['major'] ?? 'null';
          var year = data['year'] ?? 'null';
          var description = data['description'] ?? '-';
          var photo = data['photo'] ?? 'null';
          var date = data['date'] ?? 'null';
          String formattedDate = date != null
              ? DateFormat('dd-MMMM-yyyy').format(date.toDate())
              : "";
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
                "Report Details",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              padding: EdgeInsets.only(left: 15, right: 15),
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          reportName,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Report Info",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reffering"),
                            SizedBox(width: 20),
                            Flexible(
                                child: Text(
                              name,
                              overflow: TextOverflow.visible,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("University"),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Text(
                              university,
                              overflow: TextOverflow.visible,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Major"),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Text(
                              major,
                              overflow: TextOverflow.visible,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Year of Study"),
                            Text(year),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reference ID"),
                            Text(documentId),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Description"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Attachment",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image.network('$photo',
                            width: 200.0, height: 200.0, fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          print('Error: $exception');
                          return Text('-- Image Not Found --');
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
