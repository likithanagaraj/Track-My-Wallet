import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';

enum ChartPeriod { daily, weekly, monthly }

class TransactionLineChart extends StatefulWidget {
  final ChartPeriod period;
  const TransactionLineChart({super.key, this.period = ChartPeriod.daily});

  @override
  State<TransactionLineChart> createState() => _TransactionLineChartState();
}

class _TransactionLineChartState extends State<TransactionLineChart> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final stats = widget.period == ChartPeriod.daily 
        ? provider.getDailyStats() 
        : widget.period == ChartPeriod.weekly 
          ? provider.getWeeklyStats() 
          : provider.getMonthlyStats();
    
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
              fontSize: 14,
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
    maxVal = (maxVal * 1.3).ceilToDouble(); // Add some padding
    if (maxVal == 0) maxVal = 100;

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.period == ChartPeriod.daily ? "Last 7 Days" : widget.period == ChartPeriod.weekly ? "Last 4 Weeks" : "Last 6 Months",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: kBlackColor,
                  letterSpacing: -0.3
                ),
              ),
              Row(
                children: [
                  _legendItem("In", kGreenColor),
                  const SizedBox(width: 12),
                  _legendItem("Out", const Color(0xFF3B82F6)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: kBlackColor.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                ),
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
                        
                        String label = "";
                        if (widget.period == ChartPeriod.daily) {
                           const weekdayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                           label = weekdayNames[date.weekday - 1];
                        } else if (widget.period == ChartPeriod.weekly) {
                           label = "W${((date.day - 1) / 7).ceil() + 1}";
                        } else {
                           const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                           label = monthNames[date.month - 1].substring(0, 3);
                        }
                        
                        return Text(
                          label,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor.withValues(alpha: 0.3),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (stats.length - 1).toDouble(),
                minY: 0,
                maxY: maxVal,
                lineBarsData: [
                  // Income Line
                  LineChartBarData(
                    spots: List.generate(stats.length, (i) => FlSpot(i.toDouble(), stats[i].income)),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: kGreenColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kGreenColor.withValues(alpha: 0.2),
                          kGreenColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  // Expense Line
                  LineChartBarData(
                    spots: List.generate(stats.length, (i) => FlSpot(i.toDouble(), stats[i].expense)),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF3B82F6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          const Color(0xFF3B82F6).withValues(alpha: 0.0),
                        ],
                      ),
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
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: kBlackColor.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
