import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/earning_history_response.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

List<Earning_chart> earningGraph = [];

bool showAvg = false;

class EarningHistoryScreen extends StatefulWidget {
  @override
  _EarningHistoryScreenState createState() => _EarningHistoryScreenState();
}

class _EarningHistoryScreenState extends State<EarningHistoryScreen> {
  Future? earningHistoryFuture;

  @override
  void initState() {
    earningHistoryFuture = getEarningHistory();
    super.initState();
  }

  Future<void> _refreshEarningHistory() async {
    setState(() {
      earningHistoryFuture = getEarningHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          getTranslated(context, earning_history)!,
          style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead, fontSize: 17),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              color: Colors.black,
              size: 35.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: _refreshEarningHistory,
          child: FutureBuilder<BaseModel<EarningHistoryResponse>>(
            future:
                earningHistoryFuture!.then((value) => value as BaseModel<EarningHistoryResponse>),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return DeviceUtils.showProgress(true);
              } else {
                var data = snapshot.data!.data;

                if (data != null) {
                  if (data.data!.earningChart != null) {
                    earningGraph.addAll(data.data!.earningChart!);
                  }
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(context, total_balance)!,
                                    style: TextStyle(
                                        color: Palette.switchs,
                                        fontFamily: "ProximaNova",
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${data.data!.totalBalance}",
                                    style: TextStyle(
                                        color: Palette.green,
                                        fontFamily: "ProximaNova",
                                        fontSize: 26),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${data.data!.todayEarning.toString()}",
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 35),
                                      ),
                                      Text(
                                        '${getTranslated(context, '$today')} ${getTranslated(context, '$earnings')}',
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${data.data!.weeklyEarning.toString()}",
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 35),
                                      ),
                                      Text(
                                        '${getTranslated(context, '$weekly')} ${getTranslated(context, '$earnings')}',
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${data.data!.todayEarning.toString()}",
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 35),
                                      ),
                                      Text(
                                        '${getTranslated(context, '$monthly')} ${getTranslated(context, '$earnings')}',
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${data.data!.yearlyEarning.toString()}",
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 35),
                                      ),
                                      Text(
                                        '${getTranslated(context, '$yearly')} ${getTranslated(context, '$earnings')}',
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: "ProximaThin",
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(boxShadow: [
                              ], borderRadius: BorderRadius.circular(0), color: Colors.white),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(getTranslated(context, earnings)!,
                                                style: TextStyle(
                                                    color: Palette.loginhead,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  showEarningData(),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ),
    );
  }

  showEarningData() {
    return SfCartesianChart(
        margin: EdgeInsets.zero,
        primaryXAxis: CategoryAxis(
            interval: 1,
            majorGridLines: const MajorGridLines(
              width: 0,
            ),
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        primaryYAxis: NumericAxis(
            labelFormat: '${SharedPreferenceHelper.getString(Preferences.currency_symbol)}{value}',
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        plotAreaBorderWidth: 0,
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        series: <ChartSeries<Earning_chart, String>>[
          SplineSeries<Earning_chart, String>(
              color: Palette.loginhead,
              width: 1,
              isVisibleInLegend: false,
              dataSource: earningGraph,
              xValueMapper: (Earning_chart sales, _) => sales.label,
              yValueMapper: (Earning_chart sales, _) => sales.data,
              name: 'Earnings',
              markerSettings: const MarkerSettings(
                  color: Palette.green,
                  isVisible: true,
                  height: 10,
                  width: 10,
                  shape: DataMarkerType.circle,
                  borderWidth: 1,
                  borderColor: Palette.loginhead),
              dataLabelSettings: const DataLabelSettings(isVisible: false)),
        ]);
  }
}
