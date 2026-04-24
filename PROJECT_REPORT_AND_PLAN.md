# Track Birr: Project Status Report & Development Plan

## 1. Project Overview & Current State Analysis

### 1.1 Summary
**Track Birr** is an Android application designed to track financial transactions (expenses and incomes). Based on the codebase review, it currently features a fundamental local architecture built on modern Android development standards.

### 1.2 Current Architecture & Tech Stack
- **Language**: Kotlin
- **UI Framework**: Jetpack Compose (Material Design 3)
- **Dependency Injection**: Dagger Hilt
- **Local Database**: Room Database (SQLite wrapper)
- **Asynchronous Operations**: Kotlin Coroutines & Flow
- **Architecture Pattern**: MVVM (Model-View-ViewModel) with Clean Architecture principles (Separation of UI, Domain/Repository, and Data layers).

### 1.3 Existing Functionalities
- **Local Data Persistence**:
  - A Room database is set up with an `Expense` entity containing fields for `amount`, `merchantName`, `timestamp`, `bankOrTelecom`, and an `isIncome` boolean.
  - Basic DAO operations exist for fetching all expenses ordered by timestamp, inserting, and deleting transactions.
- **Dependency Injection**: Hilt modules (`DatabaseModule`, `RepositoryModule`) are successfully implemented to provide DAOs and Repositories.
- **Basic UI**:
  - `HomeScreen` contains a rudimentary interface with a button to add a hardcoded mock expense and a `LazyColumn` that displays a list of recorded expenses.
  - `HomeViewModel` handles state management via `StateFlow`, actively listening to database changes.

### 1.4 Missing Core Functionalities (Gap Analysis)
Based on your requirements and standard expense tracking features, the following core features are currently missing:
1. **Dynamic Input**: The "Add Expense" button currently injects hardcoded mock data. A form to dynamically input amount, merchant, type (income/expense), and category is needed.
2. **Dashboard & Graphical Status**: No charts or visual summaries of spending over time exist.
3. **Data Import/Export (CSV)**: Functionality to write to and read from CSV files is completely absent.
4. **Categorization**: The `Expense` model lacks a `category` field (e.g., Food, Transport, Utilities).
5. **Profile/Settings**: No profile screen exists to manage user preferences, export data, or view app info.
6. **Navigation**: The app currently only has one screen (`HomeScreen`). Jetpack Navigation Compose needs to be implemented to support moving between Dashboard, Profile, and other screens.
7. **SMS Parsing Automation**: The model mentions "parsed from an SMS message", but there is currently no `BroadcastReceiver` or background service capturing and parsing incoming SMS messages from banks/telecoms.

---

## 2. Structured Development Plan

This plan outlines the steps required to expand Track Birr into a fully functional, polished application.

### Phase 1: Database Expansion & Navigation Setup
1. **Update `Expense` Entity**:
   - Add a `category: String` (or Enum) field to the `Expense` data class to allow grouping of expenses.
   - Run a database migration (or simply clear app data during this early dev stage) to apply the schema change.
2. **Implement Navigation**:
   - Introduce `androidx.navigation:navigation-compose`.
   - Set up a `NavHost` in `MainActivity` or `TrackBirrApp`.
   - Create routes for `DashboardScreen`, `AddTransactionScreen`, and `ProfileScreen`.
   - Add a `BottomNavigationBar` for easy navigation between Dashboard, Transactions list, and Profile.

### Phase 2: Building Core UI Screens
1. **`AddTransactionScreen`**:
   - Create a form with TextFields for Amount, Merchant Name, and Bank/Telecom.
   - Use a Dropdown or RadioButtons for Income vs. Expense.
   - Use a Dropdown for Category selection.
   - Implement date/time picking (optional, can default to current time).
2. **`TransactionsListScreen`**:
   - Refine the current `LazyColumn` to show beautiful cards for each transaction.
   - Add visual indicators (e.g., green text for income, red for expense).
   - Implement swipe-to-delete functionality.

### Phase 3: Dashboard & Graphical Status
1. **Data Aggregation**:
   - Update `ExpenseDao` with queries to calculate total income, total expense, and balance (e.g., `SELECT SUM(amount) FROM expenses WHERE isIncome = 1`).
   - Group expenses by category for charts (e.g., `SELECT category, SUM(amount) FROM expenses WHERE isIncome = 0 GROUP BY category`).
2. **Chart Integration**:
   - Introduce a Compose charting library (like Vico or YCharts).
   - Create a `DashboardScreen` displaying the total balance, monthly summary, and a Pie Chart or Bar Chart showing expenses by category.

### Phase 4: CSV Export/Import (File I/O)
1. **Permissions Setup**:
   - Ensure necessary file storage permissions or use the Android Storage Access Framework (SAF) via `ActivityResultContracts.CreateDocument` and `OpenDocument`.
2. **Export to CSV**:
   - Create a use case `ExportTransactionsToCsvUseCase`.
   - Fetch all data from the database.
   - Format data into a comma-separated string format.
   - Write the string to a `.csv` file using `java.io` or `java.nio`.
3. **Import from CSV**:
   - Create a use case `ImportTransactionsFromCsvUseCase`.
   - Read the selected `.csv` file line by line.
   - Parse each line back into an `Expense` object.
   - Insert new records into the Room database.

### Phase 5: Profile Screen
1. **`ProfileScreen` Implementation**:
   - Display basic user info (can be local preferences).
   - Add actionable buttons for the previously built Export CSV and Import CSV functionalities.
   - Add options for settings (e.g., dark/light mode toggle).

### Phase 6 (Optional/Future): SMS Parsing Automation
1. **SMS Receiver**:
   - Implement a `BroadcastReceiver` listening for `android.provider.Telephony.SMS_RECEIVED`.
2. **Regex Parsing**:
   - Write Regex patterns to extract amounts and merchants from common Ethiopian banks (CBE, Telebirr, Awash, etc.).
3. **Auto-Insertion**:
   - Automatically save parsed transactions to the local database.

---
