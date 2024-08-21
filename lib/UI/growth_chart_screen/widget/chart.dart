import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walletstone/UI/growth_chart_screen/controller/growth_controller.dart';
import '../../Constants/colors.dart';
import '../model/growth_chart_model.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrowthController>(context);
    provider.findMinAndMaxDate();
    return Consumer<GrowthController>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? SizedBox(
                height: 292.w,
                child: const Center(
                  child: Text(
                    'Loading... ',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ),
              )
            : SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  isVisible: true,
                  minimum: provider.minDate,
                  maximum: provider.maxDate,
                  axisLine: const AxisLine(color: greyColor),
                  labelStyle: const TextStyle(color: greyColor),
                  majorGridLines: const MajorGridLines(color: transparent),
                  // dateFormat: DateFormat('yyyy-MM-dd'),
                ),
                primaryYAxis: const NumericAxis(
                  axisLine: AxisLine(color: greyColor),
                  labelStyle: TextStyle(color: greyColor),
                  majorGridLines: MajorGridLines(color: textfieldColor),
                ),
                plotAreaBorderColor: transparent,
                tooltipBehavior: TooltipBehavior(
                  canShowMarker: true,
                  enable: true,
                  header: '',
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    final List<ChartData> dataSource =
                        series.dataSource as List<ChartData>;
                    final ChartData chartData = dataSource[pointIndex];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name: ${chartData.name}\nDate: ${provider.formatDate(point.x)}\nAmount: ${point.y}",
                        style: const TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    );
                  },
                ),
                series: [
                  if (provider.isCryptoEnabled)
                    SplineSeries<ChartData, DateTime>(
                      splineType: SplineType.cardinal,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      dataSource: provider.cryptoDataList,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: stockGreenColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: textfieldColor,
                      ),
                    ),
                  if (provider.isAssetEnabled)
                    SplineSeries<ChartData, DateTime>(
                      splineType: SplineType.cardinal,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      dataSource: provider.assetDataList,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: blueAccentColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: textfieldColor,
                      ),
                    ),
                  if (provider.isCashEnabled)
                    SplineSeries<ChartData, DateTime>(
                      splineType: SplineType.cardinal,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      dataSource: provider.cashDataList,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: redColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: textfieldColor,
                      ),
                    ),
                  if (provider.isLoanEnabled)
                    SplineSeries<ChartData, DateTime>(
                      splineType: SplineType.cardinal,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      dataSource: provider.loanDataList,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: amber,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: textfieldColor,
                      ),
                    ),
                  if (provider.isTripEnabled)
                    SplineSeries<ChartData, DateTime>(
                      splineType: SplineType.cardinal,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      dataSource: provider.tripDataList,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: greyColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: textfieldColor,
                      ),
                    ),
                ],
                backgroundColor: transparent,
              );
      },
    );
  }
}
