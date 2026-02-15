import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/constants.dart';
import 'package:track_my_wallet_finance_app/Repository/event_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/eventRepository.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/model/eventModel.dart';
import 'package:track_my_wallet_finance_app/screens/space_details_screen.dart';
import 'package:track_my_wallet_finance_app/widgets/route_animations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:track_my_wallet_finance_app/model/transactionModel.dart';

class SpacesCarousel extends StatelessWidget {
  const SpacesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final events = eventProvider.events;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Spaces",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: kBlackColor.withValues(alpha: 0.8),
                  letterSpacing: -0.2
                ),
              ),
              if (events.isNotEmpty)
                GestureDetector(
                  onTap: () => showAddSpaceSheet(context),
                  child: Icon(FluentIcons.add_circle_24_regular, color: kBlackColor.withValues(alpha: 0.7), size: 20),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 65,
          child: events.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final totalSpent = transactionProvider.transactions
                        .where((t) => t.eventId == event.id)
                        .fold(0.0, (sum, t) => sum + t.amount);

                    return _SpaceCard(event: event, totalSpent: totalSpent);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddSpaceSheet(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhiteColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBlackColor.withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(FluentIcons.folder_add_24_regular, color: kBlackColor.withValues(alpha: 0.6), size: 22),
            const SizedBox(width: 12),
            Text(
              "Create a Space for a trip or event",
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: kBlackColor.withValues(alpha: 0.6),
                letterSpacing: 0.1
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddSpaceSheet(BuildContext context, {EventModel? event}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddSpaceSheet(event: event),
    );
  }
}

class _AddSpaceSheet extends StatefulWidget {
  final EventModel? event;
  const _AddSpaceSheet({this.event});

  @override
  State<_AddSpaceSheet> createState() => _AddSpaceSheetState();
}

class _AddSpaceSheetState extends State<_AddSpaceSheet> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;

  final List<IconData> _icons = [
    FluentIcons.airplane_24_regular,
    FluentIcons.beach_24_regular,
    FluentIcons.food_24_regular,
    FluentIcons.shopping_bag_24_regular,
    FluentIcons.vehicle_car_24_regular,
    FluentIcons.gift_24_regular,
    FluentIcons.home_24_regular,
    FluentIcons.sparkle_24_regular,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _selectedIconIndex = _icons.indexWhere((icon) => icon.codePoint == widget.event!.iconCodePoint);
      if (_selectedIconIndex == -1) _selectedIconIndex = 0;
    }
  }

  final List<Color> _colors = [
    const Color(0xFFDBE4F3),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create New Space",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: kBlackColor,
                    letterSpacing: -0.2
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(FluentIcons.dismiss_24_regular, color: kBlackColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text("NAME", style: klabel),
            TextField(
              cursorColor: kBlackColor,
              controller: _nameController,
              autofocus: true,
              style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g. Vietnam Trip",
                hintStyle: GoogleFonts.manrope(color: kBlackColor.withValues(alpha: 0.3),fontSize: 14),
                border: UnderlineInputBorder(borderSide: BorderSide(color: kBlackColor.withValues(alpha: 0.1))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kBlackColor)),
              ),
            ),
            const SizedBox(height: 24),
            Text("ICON", style: klabel),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIconIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIconIndex = index),
                    child: Container(
                      width: 50,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? kBlackColor : kBlackColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_icons[index], color: isSelected ? kWhiteColor : kBlackColor, size: 20),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Removed COLOR selection as requested (Fixed to one color)
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveSpace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlackColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  widget.event == null ? "Create Space" : "Save Changes",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _saveSpace() {
    if (_nameController.text.trim().isEmpty) return;

    final provider = context.read<EventProvider>();
    final repository = EventRepository();
    
    final name = _nameController.text.trim();
    final icon = _icons[_selectedIconIndex];

    if (widget.event != null) {
      final updatedEvent = EventModel(
        id: widget.event!.id,
        name: name,
        iconCodePoint: icon.codePoint,
        colorValue: widget.event!.colorValue,
        createdAt: widget.event!.createdAt,
        budget: widget.event!.budget,
      );
      provider.updateEvent(updatedEvent);
    } else {
      final event = repository.create(
        name: name,
        iconCodePoint: icon.codePoint,
        colorValue: const Color(0xFFDBE4F3).value,
      );
      provider.addEvent(event);
    }

    Navigator.pop(context);
  }
}

class _SpaceCard extends StatelessWidget {
  final EventModel event;
  final double totalSpent;

  const _SpaceCard({required this.event, required this.totalSpent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SmoothPageRoute(page: SpaceDetailsScreen(event: event)),
        );
      },
      onLongPress: () => _showOptions(context),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.9),
              const Color(0xFFDBE4F3).withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 1.5),

        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kBlueColor.withValues(alpha: 0.5),
                    blurRadius: 8,
                  )
                ]
              ),
              child: Icon(
                IconData(event.iconCodePoint,
                  fontFamily: 'FluentSystemIcons-Regular',
                  fontPackage: 'fluentui_system_icons'
                ),
                color: kBlackColor.withValues(alpha: 0.8),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kBlackColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Spent \$${totalSpent.toStringAsFixed(0)}",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: kBlackColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kBlackColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Space Options",
              style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(FluentIcons.edit_24_regular, color: kBlackColor),
              title: Text("Edit Space", style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                const SpacesCarousel().showAddSpaceSheet(context, event: event);
              },
            ),
            ListTile(
              leading: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
              title: Text("Delete Space", style: GoogleFonts.manrope(color: Colors.red, fontWeight: FontWeight.w600)),
              subtitle: Text("This will also delete all transactions in this Space", style: GoogleFonts.manrope(fontSize: 11)),
              onTap: () {
                final txProvider = context.read<TransactionProvider>();
                // Delete all transactions linked to this event
                final linkedTxs = txProvider.transactions.where((t) => t.eventId == event.id).toList();
                for (var tx in linkedTxs) {
                   txProvider.deleteTransaction(tx.id);
                }
                // Finally delete the event itself
                context.read<EventProvider>().deleteEvent(event.id);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
