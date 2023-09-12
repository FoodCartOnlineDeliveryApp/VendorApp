import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/insights_response.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<double> leftData = [];
List<String> bottomData = [];
String currencySymbol = '';
List<Earning_chart> earningGraph = [];
List<Order_chart> orderGraph = [];

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

class InsightScreen extends StatefulWidget {
  @override
  _InsightScreenState createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  Future? insightFuture;

  @override
  void initState() {
    super.initState();
    insightFuture = getInsights();
    currencySymbol = SharedPreferenceHelper.getString(Preferences.currency_symbol);
  }

  Future<void> _refreshInsight() async {
    setState(() {
      insightFuture = getInsights();
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
          getTranslated(context, insight)!,
          style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead, fontSize: 18),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.png'))),
          child: RefreshIndicator(
            onRefresh: _refreshInsight,
            color: Palette.green,
            child: FutureBuilder<BaseModel<InsightsResponse>>(
              future: insightFuture!.then((value) => value as BaseModel<InsightsResponse>),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return DeviceUtils.showProgress(true);
                  } else {
                    var data = snapshot.data!.data;
                    if (data != null) {
                      if (data.data!.earningChart != null) {
                        earningGraph.addAll(data.data!.earningChart!);
                      }
                      if (data.data!.orderChart != null) {
                        orderGraph.addAll(data.data!.orderChart!);
                      }
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, today)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, orders)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          Text(
                                            data.data!.todayOrder.toString(),
                                            style: TextStyle(
                                                fontFamily: "ProximaBold",
                                                color: Palette.inorder,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, total)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, orders)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          Text(
                                            data.data!.totalOrder.toString(),
                                            style: TextStyle(
                                                fontFamily: "ProximaBold",
                                                color: Palette.removeacct,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, today)!,
                                            style: TextStyle(
                                                fontFamily: proxima_nova_reg,
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, earnings)!,
                                            style: TextStyle(
                                                fontFamily: proxima_nova_reg,
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '$currencySymbol ${data.data!.todayEarnings.toString()}',
                                            style: TextStyle(
                                                fontFamily: proxima_nova_bold,
                                                color: Palette.intlearning,
                                                fontSize: 20),
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
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, total)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, earnings)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          Text(
                                            '$currencySymbol ${data.data!.totalEarnings.toString()}',
                                            style: TextStyle(
                                                fontFamily: "ProximaBold",
                                                color: Palette.intodayear,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, total)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, product)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          Text(
                                            data.data!.totalMenu.toString(),
                                            style: TextStyle(
                                                fontFamily: "ProximaBold",
                                                color: Palette.ttlprdct,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    height: 30.w,
                                    width: 27.w,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context, total)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            getTranslated(context, product_item)!,
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                color: Palette.loginhead,
                                                fontSize: 13.5),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          Text(
                                            data.data!.totalSubmenu.toString(),
                                            style: TextStyle(
                                                fontFamily: "ProximaBold",
                                                color: Palette.ttlitem,
                                                fontSize: 20),
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
                              Column(
                                children: [
                                  Row(
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  showEarningData(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getTranslated(context, orders)!,
                                              style: TextStyle(
                                                  color: Palette.loginhead,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  showOrderData(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                          child: Container(child: Text(snapshot.data!.error.getErrorMessage())));
                    }
                  }
                } else {
                  return DeviceUtils.showProgress(true);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
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

showOrderData() {
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
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      series: <ChartSeries<Order_chart, String>>[
        SplineSeries<Order_chart, String>(
            color: Palette.loginhead,
            width: 1,
            isVisibleInLegend: false,
            dataSource: orderGraph,
            xValueMapper: (Order_chart sales, _) => sales.label,
            yValueMapper: (Order_chart sales, _) => sales.data,
            name: orders,
            markerSettings: const MarkerSettings(
                color: Palette.green,
                isVisible: true,
                height: 10,
                width: 10,
                shape: DataMarkerType.circle,
                borderWidth: 1,
                borderColor: Palette.loginhead),

            dataLabelSettings: const DataLabelSettings(isVisible: false))
      ]);
}
