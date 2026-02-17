import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/helperFunction.dart'; // import formatCurrency if needed

class SpaceTrendChart extends StatelessWidget {
  final List<({DateTime date, double amount})> trend;
  final String symbol;

  const SpaceTrendChart({super.key, required this.trend, required this.symbol});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    // Find max value to scale the graph roughly
    double maxY = 0;
    for (var item in trend) {
      if (item.amount > maxY) maxY = item.amount;
    }
    // Add some headroom
    maxY = (maxY * 1.25);
    if (maxY == 0) maxY = 100;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => kBlackColor,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
               final index = group.x.toInt();
               final item = trend[index];
               final dateStr = "${item.date.day}/${item.date.month}";
               return BarTooltipItem(
                 "$dateStr\n${item.amount.toStringAsFixed(2)}",
                 GoogleFonts.manrope(
                   color: Colors.white, 
                   fontWeight: FontWeight.w700,
                   fontSize: 12
                 ),
               );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide Y axis numbers to clean up
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30, 
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= trend.length) return const SizedBox.shrink();
                
                // Show label only for some bars to avoid overcrowding if many days
                // Logic: Show first, last, and every ~5th
               
                if (trend.length > 7 && index % ((trend.length / 5).ceil()) != 0) {
                  return const SizedBox.shrink();
                }

                final date = trend[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${date.day}", // Just the day number
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor.withValues(alpha: 0.4),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
           drawVerticalLine: false,
           getDrawingHorizontalLine: (value) => FlLine(
             color: kBlackColor.withValues(alpha: 0.05),
             strokeWidth: 1,
             dashArray: [5, 5],
           ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: trend.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.amount,
                color: kOrangeColor,
                width: 6, // Thin bars like in the "Nutrition Balance" image
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY, // Full height background
                  color: kBlackColor.withValues(alpha: 0.03),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
