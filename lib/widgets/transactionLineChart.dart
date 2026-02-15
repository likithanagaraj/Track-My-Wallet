import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';

class TransactionLineChart extends StatelessWidget {
  const TransactionLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<TransactionProvider>().getWeeklyStats();
    
    // Check if there's any data
    final hasData = stats.any((s) => s.income > 0 || s.expense > 0);
    
    if (!hasData) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            "Add transactions to see trends",
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kBlackColor.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    // Find max value for Y axis
    double maxVal = 0;
    for (var s in stats) {
      if (s.income > maxVal) maxVal = s.income;
      if (s.expense > maxVal) maxVal = s.expense;
    }
    maxVal = (maxVal * 1.2).ceilToDouble(); // Add some padding
    if (maxVal == 0) maxVal = 100;

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Overview",
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kBlackColor,
                  letterSpacing: -0.3
                ),
              ),
              Row(
                children: [
                  _legendItem("Income", kGreenColor.withValues(alpha: 0.6)),
                  const SizedBox(width: 12),
                  _legendItem("Expense", kOrangeColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= stats.length) return const SizedBox();
                        final date = stats[index].date;
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        // Adjust index to day of week? No, stats is already ordered.
                        // Let's just use the first letter of the day name.
                        const weekdayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
                        String dayLabel = weekdayNames[date.weekday - 1];
                        
                        return Text(
                          dayLabel,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor.withValues(alpha: 0.4),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxVal,
                lineBarsData: [
                  // Income Line
                  LineChartBarData(
                    spots: List.generate(stats.length, (i) => FlSpot(i.toDouble(), stats[i].income)),
                    isCurved: true,
                    color: kGreenColor.withValues(alpha: 0.7),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: kBlueColor,
                    ),
                  ),
                  // Expense Line
                  LineChartBarData(
                    spots: List.generate(stats.length, (i) => FlSpot(i.toDouble(), stats[i].expense)),
                    isCurved: true,
                    color: kOrangeColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: kOrangeColor.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
