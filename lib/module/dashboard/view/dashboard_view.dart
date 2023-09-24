import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  Widget build(context, DashboardController controller) {
    final now = DateTime.now();
    final monthFormat = DateFormat.MMMM();
    final monthName = monthFormat.format(now);
    String monthnow = monthName;
    final chartData = ChartDataModel.chartData;
    // controller.view = this;
    ScrollController _scrollController = ScrollController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF9B51E0),
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              color: Color(0xFF9B51E0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Text(
                        "Welcome Back " + controller.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              Text(
                                "Spending on $monthnow 2023",
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    final totalmonthnow = chartData
                                        .where((data) =>
                                            data["month"] == "$monthnow")
                                        .toList();
                                    num total = 0;
                                    for (final data in totalmonthnow) {
                                      total += data["data"]["primer"] +
                                          data["data"]["sekunder"] +
                                          data["data"]["tersier"] +
                                          data["data"]["pendidikan"].toInt();
                                    }
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "RP$total" "000",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 270,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Builder(
                builder: (context) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(12.0),
                          child: ListView.builder(
                            itemCount:
                                chartData.length > 12 ? 12 : chartData.length,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final data = chartData[index];
                              return Container(
                                height: 100,
                                width: 80,
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["primer"] /
                                                40,
                                            width: 20,
                                            color: Colors.blue,
                                          ),
                                          Container(
                                            height: (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["sekunder"] /
                                                40,
                                            width: 20,
                                            color: Colors.yellow,
                                          ),
                                          Container(
                                            height: (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["tersier"] /
                                                40,
                                            width: 20,
                                            color: Colors.red,
                                          ),
                                          Container(
                                            height: (data["data"]["primer"] +
                                                    data["data"]["sekunder"] +
                                                    data["data"]["tersier"] +
                                                    data["data"]
                                                        ["pendidikan"]) *
                                                data["data"]["pendidikan"] /
                                                40,
                                            width: 20,
                                            color: Colors.green,
                                          ),
                                        ]),
                                    SizedBox(height: 15.0),
                                    Container(
                                        height: 25,
                                        child: Text(
                                          data["month"],
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Pengeluaran di Bulan $monthName",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                  height: 76.0,
                  child: ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = chartData.firstWhere(
                          (element) => element["month"] == "$monthnow");
                      List<String> kebutuhan = [
                        'Primer',
                        'Sekunder',
                        'Tersier',
                        'Pendidikan'
                      ];

                      return Row(
                        children: kebutuhan.map((jenis) {
                          return Container(
                            width: 160,
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jenis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    "${data["data"][jenis.toLowerCase()]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: ExpenseListView()),
            ExpenseItem(),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  @override
  DashboardController createState() => DashboardController();
}
