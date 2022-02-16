import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatefulWidget {
  const DonutChart({
    Key? key,
    required this.currentCount,
    required this.completedCount,
    required this.plannedCount,
    required this.onHoldCount,
    required this.droppedCount,
    required this.totalCount,
  }) : super(key: key);

  final int currentCount;
  final int completedCount;
  final int plannedCount;
  final int onHoldCount;
  final int droppedCount;
  final int totalCount;

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: PieChart(PieChartData(
                        sectionsSpace: 10,
                        sections: [
                          PieChartSectionData(
                            value: widget.currentCount.toDouble(),
                            title: "Current",
                            showTitle: false,
                            radius: 20,
                            color: Colors.blue,
                          ),
                          PieChartSectionData(
                            value: widget.completedCount.toDouble(),
                            title: "Current",
                            showTitle: false,
                            radius: 20,
                            color: Colors.green,
                          ),
                          PieChartSectionData(
                            value: widget.plannedCount.toDouble(),
                            title: "Current",
                            showTitle: false,
                            radius: 20,
                            color: Colors.pink,
                          ),
                          PieChartSectionData(
                            value: widget.onHoldCount.toDouble(),
                            title: "Current",
                            showTitle: false,
                            radius: 20,
                            color: Colors.orange,
                          ),
                          PieChartSectionData(
                            value: widget.droppedCount.toDouble(),
                            title: "Current",
                            showTitle: false,
                            radius: 20,
                            color: Colors.purple,
                          ),
                        ],
                      )),
                    ),
                    Column(
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        Text(
                          widget.totalCount.toString(),
                          style: Theme.of(context).textTheme.headline2?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _countWidget(
                      title: 'Current', value: widget.currentCount.toString(), color: Colors.blue),
                  _countWidget(
                      title: 'Completed',
                      value: widget.completedCount.toString(), color: Colors.green),
                  _countWidget(
                      title: 'Planned', value: widget.plannedCount.toString(), color: Colors.pink),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _countWidget(
                      title: 'On Hold', value: widget.onHoldCount.toString(), color: Colors.orange),
                  _countWidget(
                      title: 'Dropped', value: widget.droppedCount.toString(), color: Colors.purple),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _countWidget({required String title, required String value, Color? color}) {
    return Column(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: color ?? Theme.of(context).colorScheme.primary)),
        Text(
          value,
          style: Theme.of(context).textTheme.headline3?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
