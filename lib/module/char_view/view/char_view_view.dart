import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/ordinal/combo.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class CharViewView extends StatefulWidget {
  CharViewView({Key? key}) : super(key: key);

  final now = DateTime.now();
  final monthFormat = DateFormat.MMMM();

  Widget build(context, CharViewController controller) {
    controller.view = this;
    final chartData = ChartDataModel.chartData;
    final currentMonth = monthFormat.format(now);
    String monthNow = currentMonth;
    Map<String, dynamic>? monthData;
    for (final data in chartData) {
      if (data["month"] == "$monthNow") {
        monthData = data;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentMonth),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DChartComboO(
                barLabelDecorator: BarLabelDecorator(
                    barLabelPosition: BarLabelPosition.outside),
                barLabelValue: (group, ordinalData, index) {
                  return 'Rp.${ordinalData.measure}';
                },
                groupList: [
                  OrdinalGroup(id: '1', chartType: ChartType.bar, data: [
                    OrdinalData(
                        domain: 'Primer',
                        measure: monthData!["data"]["primer"]),
                    OrdinalData(
                        domain: 'Sekunder',
                        measure: monthData["data"]["sekunder"]),
                    OrdinalData(
                        domain: 'Tersier',
                        measure: monthData["data"]["tersier"]),
                    OrdinalData(
                        domain: 'Pendidikan',
                        measure: monthData["data"]["pendidikan"]),
                  ]),
                ]),
          )
        ],
      ),
    );
  }

  @override
  State<CharViewView> createState() => CharViewController();
}
