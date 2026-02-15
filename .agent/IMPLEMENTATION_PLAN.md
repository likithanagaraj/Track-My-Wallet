# Implementation Plan for Track My Wallet - Final Features

## Completed:
1. ✅ Created UserPreferences Hive model
2. ✅ Created UserPreferencesRepository
3. ✅ Expanded categories to 17 expense and 11 income categories
4. ✅ Updated currency list to 14 major world currencies
5. ✅ Updated app purpose reasons to 5 research-based options

## Remaining Tasks:

### 1. Hive Integration & Data Persistence
- [ ] Register UserPreferences adapter in main.dart
- [ ] Update Currency screen to save selected currency
- [ ] Update Enquire screen to save selected purposes
- [ ] Update UserInput screen to save name and mark onboarding complete
- [ ] Update main.dart to check onboarding status and route accordingly

### 2. Home Screen Updates
- [ ] Replace "Likitha" with dynamic userName from Hive
- [ ] Replace initials with dynamic user initials
- [ ] Make profile circle clickable to navigate to Profile screen

### 3. Profile Screen (NEW)
- [ ] Create profile_screen.dart
- [ ] Display user name, currency, and purposes
- [ ] Allow editing name with TextField
- [ ] Allow changing currency with dropdown/picker
- [ ] Save changes back to Hive
- [ ] Update UI across app when changes are made

### 4. Learn Screen Enhancement
- [ ] Replace placeholder with PageView/Carousel
- [ ] Create 5-10 educational cards about:
  - Budgeting basics
  - Saving strategies
  - Debt management
  - Investment fundamentals
  - Financial goals
- [ ] Add swipe gestures
- [ ] Add page indicators

### 5. Empty State UI
- [ ] Create empty_transactions_widget.dart
- [ ] Add illustration/icon
- [ ] Add helpful text to guide users
- [ ] Add "Add Transaction" button

### 6. All Transactions Screen - Graph
- [ ] Add fl_chart package dependency
- [ ] Create spending chart (pie chart or bar chart)
- [ ] Show expense breakdown by category
- [ ] Add date range filter

### 7. Navigation Flow Updates
- [ ] Update Splash -> Currency -> Enquire -> UserInput -> Home
- [ ] Add check in main.dart: if onboarding complete, go to Home
- [ ] Ensure back button behavior is correct

## Files to Create:
1. lib/screens/profile_screen.dart
2. lib/widgets/empty_transactions_widget.dart
3. lib/widgets/financial_education_card.dart
4. lib/data/financial_tips.dart

## Files to Modify:
1. lib/main.dart - Add Hive initialization and routing logic
2. lib/screens/homeScreen.dart - Dynamic user data
3. lib/screens/currency_selection_screen.dart - Save to Hive
4. lib/screens/enquire_screen.dart - Save to Hive
5. lib/screens/user_input_screen.dart - Save to Hive
6. lib/screens/learn_screen.dart - Add swipeable cards
7. lib/screens/AllTransactionsScreen.dart - Add graph
8. pubspec.yaml - Add fl_chart dependency

## Priority Order:
1. Hive integration (critical for data persistence)
2. Profile screen (user can update info)
3. Empty state UI (better UX)
4. Learn screen cards (educational value)
5. Transaction graph (data visualization)
