import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'comman.dart';
import 'package:infertilityapp/advice.dart';

class GraphPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  GraphPage({required this.userId, required this.name, required this.dayDifference});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<charts.Series<dynamic, String>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String url = '$graph?userid=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          List<dynamic> sortedData = List<dynamic>.from(data['data']);
          sortedData.sort((a, b) => b['date'].compareTo(a['date'])); // Sort by date in descending order
          final latestData = sortedData.take(5).toList();
          setState(() {
            _chartData = _createChartData(latestData); // Update chart data with latest fetched data
          });

          // Check for optimum levels after updating chart data
          _checkOptimumLevels(latestData);
        } else {
          _showErrorDialog(data['message']);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Failed to connect to the server.');
    }
  }

  void _checkOptimumLevels(List<dynamic> data) {
    if (data.isNotEmpty) {
      // Get the latest date from the data
      String latestDate = data.first['date']; // Assuming 'date' is the field holding the date

      // Filter data to get entries for the latest date
      List<dynamic> latestData = data.where((element) => element['date'] == latestDate).toList();

      // Check if all values for the latest date are in optimum range
      bool allOptimum = latestData.every((element) =>
      (element['endometrium_thickness'] >= 8 && element['endometrium_thickness'] <= 10) &&
          (element['follicular_diameter'] > 17) &&
          (element['RI'] < 0.5) &&
          (element['PSV'] > 11)
      );

      if (allOptimum) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _showOptimumDialog();
        });
      }
    }
  }

  void _showOptimumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Optimum Levels'),
        content: Text('Patient reached optimum level'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  List<charts.Series<dynamic, String>> _createChartData(List<dynamic> data) {
    return [
      charts.Series<dynamic, String>(
        id: 'Endometrium Thickness',
        colorFn: (dynamic sales, _) => (sales['endometrium_thickness'] >= 8 && sales['endometrium_thickness'] <= 10)
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['endometrium_thickness'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['endometrium_thickness']}',
      ),
      charts.Series<dynamic, String>(
        id: 'Follicular Diameter',
        colorFn: (dynamic sales, _) => (sales['follicular_diameter'] > 17)
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['follicular_diameter'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['follicular_diameter']}',
      ),
      charts.Series<dynamic, String>(
        id: 'Perifollicular Rate',
        colorFn: (dynamic sales, _) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['perifollicular_rate'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['perifollicular_rate']}',
      ),
      charts.Series<dynamic, String>(
        id: 'RI',
        colorFn: (dynamic sales, _) => (sales['RI'] < 0.5)
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['RI'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['RI']}',
      ),
      charts.Series<dynamic, String>(
        id: 'PSV',
        colorFn: (dynamic sales, _) => (sales['PSV'] > 11)
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['PSV'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['PSV']}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/arrow.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 30),
            Text(
              'View Graph',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Image.asset(
              'assets/ovule.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 50),
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 1000,
                    child: charts.BarChart(
                      _chartData,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: [
                        charts.SeriesLegend(),
                        charts.ChartTitle('Date', behaviorPosition: charts.BehaviorPosition.bottom, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('Values', behaviorPosition: charts.BehaviorPosition.start, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                      ],
                      defaultRenderer: charts.BarRendererConfig<String>(
                        cornerStrategy: const charts.ConstCornerStrategy(30),
                      ),
                      selectionModels: [
                        charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: (charts.SelectionModel model) {
                            if (model.hasDatumSelection) {
                              final selectedDatum = model.selectedDatum.first;
                              final series = selectedDatum.series;
                              final datum = selectedDatum.datum;
                              String measure;

                              switch (series.id) {
                                case 'Endometrium Thickness':
                                  measure = datum['endometrium_thickness'].toString();
                                  break;
                                case 'Follicular Diameter':
                                  measure = datum['follicular_diameter'].toString();
                                  break;
                                case 'Perifollicular Rate':
                                  measure = datum['perifollicular_rate'].toString();
                                  break;
                                case 'RI':
                                  measure = datum['RI'].toString();
                                  break;
                                case 'PSV':
                                  measure = datum['PSV'].toString();
                                  break;
                                default:
                                  measure = 'N/A';
                              }

                              final domain = datum['date'];
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$domain: $measure'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Color(0xffed4662),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GestureDetector(
            onTap: () async {
              // After data is sent, navigate to the next page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvicePage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Advices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}