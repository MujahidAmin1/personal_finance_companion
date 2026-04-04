# Finsight - Personal Finance Companion App

A comprehensive personal finance companion application built with Flutter. Finsight helps you track your income and expenses, manage saving goals, and visualize your financial trends in a clean, elegant mobile interface.

## Features

### Dashboard and Setup
* **Onboarding Flow:** Welcomes new users and sets up an initial profile (Name and Initial Balance) which is saved locally.
* **Dashboard:** Gives a quick overview of your total balance, total income, and total expenses for the current period, along with a list of recent transactions.
* **Bottom Navigation:** A persistent custom bottom navigation bar for seamless switching between Dashboard, Transaction History, Goals, and Insights.

### Transactions Management
* **Add Transactions:** Seamlessly record expenses and income. Includes robust form validation, date picking, category selection, and optional notes.
* **Transaction History:** View all past transactions grouped intelligently by relative time (Today, Yesterday, Earlier).
* **Smart Filtering:** Filter transactions by All, Income, or Expense.
* **Swipe-to-Delete:** Easily remove unwanted or accidental transactions by swiping them away.
* **Transaction Receipt:** Tap any transaction to view its details presented elegantly in the form of a physical retail receipt.

### Savings Goals
* **Goal Tracking:** Set, edit, and contribute to targeted savings goals.
* **Progress Visualization:** Visual progress bars indicating completion percentage and target vs current saved funds.
* **Multiple Goals:** Support for tracking both a primary focus goal and multiple secondary goals simultaneously.

### Advanced Insights and Analytics
* **Spending Trends:** Visual line charts charting your weekly cash outflow using `fl_chart`.
* **Top Categories:** Automatically identifies and highlights the category you spend the most on.
* **Monthly Breakdown:** Detailed breakdowns of where your money is going with percentage analysis of lifestyle choices vs. essential costs.
* **Weekly Comparison:** Compare your current 7-day spending shifts against the previous 7 days to see if you are spending more or less.

## Architecture and Technologies

* **Framework:** Flutter (Dart ^3.11.4)
* **State Management:** Riverpod (`flutter_riverpod`) for managing application state reactively across screens.
* **Local Persistence:** Hive CE (`hive_ce`, `hive_ce_flutter`) for rapid, NoSQL offline storage of transactions, goals, and user settings.
* **Charts:** `fl_chart` for rendering beautiful and interactive spending graphs.
* **Routing:** Controlled navigation via Riverpod state providers and native Flutter Navigator methods extension.

## Project Structure

The project strictly follows a feature-first architecture, located under `lib/`:

* `core/`: Contains application-wide configurations, constants, custom color palettes (`appcolors.dart`), typography helpers, and Hive box initializers.
* `features/`: The core business logic and views, separated by domain:
  * `add_transaction/`: Screens and controllers for adding/managing transaction entries.
  * `btm_navbar/`: Controller and view for the custom bottom navigation system.
  * `dashboard/`: The main landing view and balance summaries.
  * `goals/`: Logic, repository, and views for the savings goals system.
  * `insights/`: Comprehensive analysis screens calculating metrics natively from repositories.
  * `onboarding/`: First-time setup screens and user credential setup.
  * `transaction_history/`: Screen displaying all logged transactions, filters, and detailed receipt views.
* `models/`: Plain Dart objects and Hive adapters for `Transaction`, `Goal`, `TransactionCategory`, etc.
* `widgets/`: Reusable, stateless or tightly scoped UI components used across multiple features (e.g., `TransactionViewCard`, `InsightSummaryCard`, `BalanceCard`).

## Getting Started

### Prerequisites
* Flutter SDK (Targeting ^3.11.4 or equivalent newer release)
* Dart SDK

### Installation

1. Clone the repository to your local machine.
2. Ensure you have Flutter installed and configured.
3. Open a terminal in the project root directory.
4. Fetch dependencies:
   ```bash
   flutter pub get
   ```
5. If modifying Hive models, you may need to regenerate the adapters:
   ```bash
   dart run build_runner build -d
   ```
6. Run the app on your preferred emulator or physical device:
   ```bash
   flutter run
   ```

## Development and Contribution

When extending the application, note the following patterns:
* **UI Components:** Do not over-abstract screens. If a widget is shared across multiple screens, place it in `lib/widgets`.
* **State Updates:** State changes reflect automatically using `Notifier` and `Provider` from Riverpod combined with Hive watch streams. Avoid `setState` and manual refreshing for global data.
* **Styling:** Adhere to the `AppColors` palette for maintaining the premium aesthetics of the app. Ensure consistent padding and typography.
