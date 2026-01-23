import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/model/transaction_type.dart';
import 'package:track_my_wallet_finance_app/ui_models/transactionWithCategory.dart';
import 'dart:math' as math;

// class TranscationContent extends StatelessWidget {
//   final List<TransactionModel> transactions;
//   const TranscationContent({required this.transactions});
//
//   @override
//   Widget build(BuildContext context) {
//     if(transactions.isEmpty){
//       return const Center(child: Text('No Transactions'),);
//     }
//     return Container(
//       margin: EdgeInsets.only(top: 5.0),
//       child: ListView.builder(
//         itemCount: transactions.length,
//         itemBuilder: (context,index){
//           final text = transactions[index];
//           return  Column(
//             spacing: 12.0,
//             children: [
//               // // total
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Today',style: ktabLabelStyle),
//                       Text('₹ 154.00',style: ktabLabelStyle,),
//                     ],
//                   ),
//                   Divider(
//                     height: 10.0,
//                     color: kBlackColor.withValues(alpha: 0.2),
//                   ),
//                 ],
//               ),
//               // trancationList
//               Column(
//                 spacing: 10,
//
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: kGreenColor.withValues(alpha: 0.1),
//                             radius: 18,
//                             child: Transform(
//                               transform: Matrix4.rotationY(math.pi),
//                               alignment: Alignment.center,
//                               child: FaIcon(
//                                 FontAwesomeIcons.carSide,
//                                 size: 16,
//                                 color: kBlackColor.withValues(alpha: 0.8),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16.0,),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(text.note ?? '',style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   letterSpacing:-0.2,
//                                   fontWeight: FontWeight.w500,
//                                   color: kBlackColor,
//                                   height: 0
//                               ),),
//                               Text('travel',style: ktabLabelStyle,)
//                             ],
//                           ),
//                         ],
//                       ),
//                       Text('₹${text.amount}',style:  GoogleFonts.poppins(
//                           fontSize: 17,
//                           letterSpacing:-0.5,
//                           fontWeight: FontWeight.w500,
//                           color: kBlackColor
//                       ),)
//                     ],
//                   ),
//                 ],
//               )
//             ],
//           );
//         },
//
//       ),
//     );
//   }
// }

class TranscationContent extends StatelessWidget {
  final List<TransactionWithCategory> transactions;

  const TranscationContent({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No Transactions'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: tx.transaction.type == TransactionType.income ? kGreenColor.withValues(alpha: 0.1) : kKeyBoardCircleColor,
                    radius: 18,
                    child: Transform(
                      transform: Matrix4.rotationY(math.pi),
                      alignment: Alignment.center,
                      child: FaIcon(
                        tx.category.categoryIcon,
                        size: 16,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.transaction.note ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(tx.category.categoryLabel, style: ktabLabelStyle),
                    ],
                  ),
                ],
              ),

              Text(
                '₹${tx.transaction.amount}',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  color: tx.transaction.type == TransactionType.expense
                      ? kRedColor
                      : kBlackColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
