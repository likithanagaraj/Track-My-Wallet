import 'package:flutter/material.dart' hide CloseButtonIcon;
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:track_my_wallet_finance_app/Repository/transactionRepository.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/Repository/user_preferences_provider.dart';
import 'package:track_my_wallet_finance_app/data/categories.dart';
import 'package:track_my_wallet_finance_app/model/categoryModel.dart';
import 'package:track_my_wallet_finance_app/widgets/bottomSheet.dart';
import 'package:track_my_wallet_finance_app/widgets/closeButton.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/appScreenBackground.dart';
import 'package:track_my_wallet_finance_app/Repository/event_provider.dart';
import 'package:track_my_wallet_finance_app/model/eventModel.dart';
import '../constants.dart';
import 'package:track_my_wallet_finance_app/model/transactionModel.dart';
import '../model/transaction_type.dart';
import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');
    
    String cleanText = newValue.text.replaceAll(',', '');
    if (cleanText == '.') return newValue.copyWith(text: '0.');
    
    // Validate number format (allow digits and one decimal point)
    final regex = RegExp(r'^\d+(\.\d*)?$');
    if (!regex.hasMatch(cleanText)) return oldValue;

    final parts = cleanText.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (m) => '${m[1]},');

    String result = integerPart + (decimalPart != null ? '.$decimalPart' : '');
    
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class TransactionScreen extends StatefulWidget {
  final TransactionModel? existingTransaction;
  final String? initialEventId;

  const TransactionScreen({
    super.key, 
    this.existingTransaction, 
    this.initialEventId,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  TransactionType selectedType = TransactionType.expense;
  CategoryModel? selectedCatgory;
  DateTime _selectedDate = DateTime.now();
  String? _selectedEventId;
  final FocusNode noteFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  final TransactionRepository repository = TransactionRepository();

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final tx = widget.existingTransaction!;
      // Format 20000 -> 20,000 using our ThousandsFormatter logic (or just simple replace)
      // Actually, controller text can be raw, the formatter will handle it? 
      // No, let's format it manually for the initial value.
      String initialAmount = tx.amount.toStringAsFixed(tx.amount % 1 == 0 ? 0 : 2);
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      initialAmount = initialAmount.replaceAllMapped(reg, (m) => '${m[1]},');
      
      amountController = TextEditingController(text: initialAmount);
      noteController = TextEditingController(text: tx.note ?? "");
      selectedType = tx.type;
      _selectedDate = tx.createdAt;
      _selectedEventId = tx.eventId;
      
      // Find category in active list
      final catList = selectedType == TransactionType.expense ? expenseCategories : incomeCategories;
      selectedCatgory = catList.firstWhere((c) => c.id == tx.categoryId, orElse: () => catList.first);
    } else {
      amountController = TextEditingController(text: "");
      noteController = TextEditingController();
      _selectedDate = DateTime.now();
      _selectedEventId = widget.initialEventId;
    }

    // Auto-focus amount input if not editing
    if (widget.existingTransaction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          amountFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void handleTypeChange(TransactionType type) {
    setState(() {
      selectedType = type;
      selectedCatgory = null;
    });
  }

  void handleCategoryType(CategoryModel type) {
    setState(() {
      selectedCatgory = type;
    });
    Navigator.pop(context);
  }

  List<CategoryModel> get activeCategory {
    return selectedType == TransactionType.expense
        ? expenseCategories
        : incomeCategories;
  }

  void showCategoryBottomSheet() {
    showFlexibleBottomSheet(
      bottomSheetColor: kWhiteColor,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      builder: (context, scrollController, offset) => CategoryBottomSheet(
        category: activeCategory,
        scrollController: scrollController,
        selectedCategory: selectedCatgory,
        onCategorySelect: handleCategoryType,
      ),
      anchors: [0, 0.5, 1],
      isSafeArea: true,
    );
  }

  bool get isFormValid {
    final cleanAmount = amountController.text.replaceAll(',', '');
    return cleanAmount != '0' && 
           cleanAmount.isNotEmpty && 
           selectedCatgory != null;
  }

  void handleContinue() {
    if (!isFormValid) return;

    final cleanedAmountString = amountController.text.replaceAll(',', '');
    final amount = double.parse(cleanedAmountString);
    final provider = context.read<TransactionProvider>();

    if (widget.existingTransaction != null) {
      // Edit Mode
      final updatedTx = TransactionModel(
        id: widget.existingTransaction!.id,
        amount: amount,
        type: selectedType,
        categoryId: selectedCatgory!.id,
        note: noteController.text.isEmpty ? null : noteController.text,
        createdAt: _selectedDate,
        eventId: _selectedEventId,
      );
      provider.updateTransaction(updatedTx);
    } else {
      // Add Mode
      final transaction = repository.create(
        amount: amount,
        categoryId: selectedCatgory!.id,
        type: selectedType,
        note: noteController.text.isEmpty ? null : noteController.text,
        createdAt: _selectedDate,
      );
      
      // Update with eventId if present
      final finalTx = TransactionModel(
        id: transaction.id,
        amount: transaction.amount,
        type: transaction.type,
        categoryId: transaction.categoryId,
        note: transaction.note,
        createdAt: transaction.createdAt,
        eventId: _selectedEventId,
      );
      
      provider.addTransaction(finalTx);
    }
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<UserPreferencesProvider>().currencySymbol;

    return Scaffold(
      backgroundColor: kscaffolBg,
      resizeToAvoidBottomInset: true,
      body: AppScreenBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Delete Button (In Edit Mode)
              if (widget.existingTransaction != null)
                Positioned(
                  top: 5,
                  left: 10,
                  child:  CircleAvatar(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    radius: 17,
                    child: IconButton(
                      onPressed: () async {
                        final delete = await _showDeleteConfirmation(context);
                        if (delete == true && context.mounted) {
                          context.read<TransactionProvider>().deleteTransaction(widget.existingTransaction!.id);
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(FluentIcons.delete_24_regular, size: 18, color: Colors.red),
                    ),
                  ),
                ),

              // Close Button
              Positioned(
                top: 5,
                right: 10,
                child:  AppCloseButton(onTap: () => Navigator.pop(context)),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
            
                              // Amount Input Section (Centered Currency + Input)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currencySymbol,
                                    style: GoogleFonts.manrope(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w600,
                                      color: kBlackColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4,),
                                  IntrinsicWidth(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        textSelectionTheme: TextSelectionThemeData(
                                          cursorColor: kBlackColor,
                                          selectionHandleColor: kBlackColor, // This changes the drop handle
                                          selectionColor: kBlackColor.withValues(alpha: 0.1), // Optional: selection highlight
                                        ),
                                      ),
                                      child: TextField(
                                        controller: amountController,
                                        cursorColor: kBlackColor,
                                        cursorHeight: 38,
                                        focusNode: amountFocusNode,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [ThousandsFormatter()],
                                        style: GoogleFonts.manrope(
                                          fontSize: 44,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0,
                                          color: kBlackColor.withValues(alpha: 0.8),
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          hintText: '0',
                                          hintStyle: GoogleFonts.manrope(
                                            color: kBlackColor.withValues(alpha: 0.3),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
            
                              const SizedBox(height: 2),
            
                              // Toggle Button (Income / Expense)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTypeButton(TransactionType.income),
                                  const SizedBox(width: 12),
                                  _buildTypeButton(TransactionType.expense),
                                ],
                              ),
            
                              const SizedBox(height: 20),
                              
                              _buildDatePicker(),
                              
                              const SizedBox(height: 20),
            
                              // Category Selector
                              GestureDetector(
                                onTap: showCategoryBottomSheet,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: kBlackColor.withValues(alpha: 0.1)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: kOrangeColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          selectedCatgory != null
                                              ? selectedCatgory!.categoryIcon
                                              : FluentIcons.grid_24_filled,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        selectedCatgory?.categoryLabel ?? "Choose category",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kBlackColor.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        FluentIcons.chevron_down_24_filled,
                                        size: 18,
                                        color: kBlackColor.withValues(alpha: 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
            
                              const SizedBox(height: 8),

                              _buildSpaceSelector(),
            
                              const SizedBox(height: 8),
            
                              // Note Input
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: kWhiteColor.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: kBlackColor.withValues(alpha: 0.1),
                                      style: BorderStyle.solid // Can't easily do dashed border without custom painter, using solid for clean look
                                  ),
                                ),
                                child: TextField(
                                  controller: noteController,
                                  cursorColor: kBlackColor,
                                  focusNode: noteFocusNode,
                                  style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      color: kBlackColor,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Add a note (optional)...",
                                    hintStyle: GoogleFonts.manrope(
                                        color: kBlackColor.withValues(alpha: 0.5),
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500
                                    ),
                                    border: InputBorder.none,
            
                                  ),
                                ),
                              ),
            
                              const Spacer(),
            
                              ContinueButton(
                                onTap: handleContinue,
                                isEnabled: isFormValid,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    bool isToday = selectedDay == today;
    bool isYesterday = selectedDay == yesterday;
    bool isOther = !isToday && !isYesterday;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dateChip("Today", isToday, () => setState(() => _selectedDate = DateTime.now())),
        const SizedBox(width: 8),
        _dateChip("Yesterday", isYesterday, () => setState(() => _selectedDate = DateTime.now().subtract(const Duration(days: 1)))),
        const SizedBox(width: 8),
        _dateChip(
          isOther ? "${_selectedDate.day}/${_selectedDate.month}" : "Other",
          isOther,
          () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: kBlackColor,
                      onPrimary: Colors.white,
                      onSurface: kBlackColor,
                    ),
                    textTheme: GoogleFonts.manropeTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        textStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
        ),
      ],
    );
  }

  Widget _dateChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? kBlackColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kBlackColor : kBlackColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? kBlackColor : kBlackColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kWhiteColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Delete Transaction?",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          "This action cannot be undone and will be removed from your records.",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w500, color: kBlackColor.withValues(alpha: 0.6), height: 1.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel", style: GoogleFonts.manrope(color: kBlackColor.withValues(alpha: 0.5), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Delete", style: GoogleFonts.manrope(color: Colors.red, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceSelector() {
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.events;
    
    if (events.isEmpty) return const SizedBox.shrink();

    final selectedEvent = eventProvider.getEventById(_selectedEventId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlackColor.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          dropdownColor: kWhiteColor,
          borderRadius: BorderRadius.circular(20),
          value: _selectedEventId,
          hint: Text("Link to Space (Optional)", style: GoogleFonts.manrope(fontSize: 14, color: kBlackColor.withValues(alpha: 0.5))),
          isExpanded: true,
          items: [
             DropdownMenuItem<String?>(
              value: null,
              child: Text("None",style: GoogleFonts.manrope(fontSize: 14, color: kBlackColor,letterSpacing: 0)),
            ),
            ...events.map((e) => DropdownMenuItem<String?>(
              value: e.id,
              child: Row(
                children: [
                  Icon(IconData(e.iconCodePoint, fontFamily: 'FluentSystemIcons-Regular', fontPackage: 'fluentui_system_icons'), size: 16, color: kBlackColor.withValues(alpha: 0.7)),
                  const SizedBox(width: 8),
                  Text(e.name, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 0)),
                ],
              ),
            )),
          ],
          onChanged: (val) => setState(() => _selectedEventId = val),
        ),
      ),
    );
  }

  Widget _buildTypeButton(TransactionType type) {
    final isSelected = selectedType == type;
    final isIncome = type == TransactionType.income;
    // Expense uses Up-Right arrow (default is active orange)
    // Income uses Down-Left arrow
    
    // Icon Logic
    IconData icon;
    if (type == TransactionType.expense) {
      icon = FluentIcons.arrow_up_24_filled; // Rotate 45
    } else {
      icon = FluentIcons.arrow_up_24_filled; // Rotate 225
    }

    final double rotationAngle = type == TransactionType.expense 
        ? 45 * 3.14159 / 180 
        : 225 * 3.14159 / 180;

    return GestureDetector(
      onTap: () => handleTypeChange(type),
      child: Container(
        padding: const EdgeInsets.only(left: 4,right: 8,top: 4,bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? (isIncome ? kOrangeColor : kOrangeColor) : Colors.transparent, // Active colors
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? null : Border.all(color: kBlackColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Transform.rotate(
               angle: rotationAngle,
               child: Container(
                 padding: EdgeInsets.all(4),
                 decoration: BoxDecoration(
                   color: isSelected ? kWhiteColor : kBlackColor.withValues(alpha: 0.07),
                   shape: BoxShape.circle,
                 ),
                 child: Icon(
                   icon,
                   size: 16,
                   color: isSelected
                      ? (isIncome ? kBlackColor : kBlackColor)
                      : kBlackColor.withValues(alpha: 0.5),
                 ),
               ),
             ),
             const SizedBox(width: 6),
             Text(
               type == TransactionType.income ? "income" : "expenses",
               style: GoogleFonts.manrope(
                 fontSize: 14,
                 fontWeight: FontWeight.w600,
                 letterSpacing: 0,
                 color: isSelected
                    ? (isIncome ? kWhiteColor : Colors.white)
                    : kBlackColor.withValues(alpha: 0.5),
               ),
             )
          ],
        ),
      ),
    );
  }
}
