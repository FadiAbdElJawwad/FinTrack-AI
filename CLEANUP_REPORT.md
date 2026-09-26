# Codebase Audit Report: FinTrack AI

**Date:** 2026-09-26  
**Scope:** Complete `lib/` tree audit  
**Analyzer Diagnostics:** `dart analyze lib` reports **0 issues**  
**Execution Mode:** Read-Only Audit (No application code modified or deleted)

---

## Executive Summary

A comprehensive architectural and quality audit of the FinTrack AI Flutter application was performed across all 73 classes, 31 Riverpod providers, 24 widget screens/components, and localization assets. 

The audit focused on five core pillars:
1. **Dead Code & Unused Elements:** Verifying flagged candidates (`UserModel.totalBalance`, superseded wallet l10n keys, empty services, dead routes, and no-op UI handlers).
2. **Duplicated UI & Logic Patterns:** Detecting structurally near-identical ChoiceChip rendering, copy-pasted transaction list builders, repeated auth components, and redundant data structures.
3. **Design-Token Violations:** Documenting every instance of hardcoded colors, built-in Material `Colors.*`, explicit `EdgeInsets.*`, and explicit `BorderRadius.*` that bypass project design tokens.
4. **Long & Mixed-Responsibility Functions/Widgets:** Pinpointing monolithic `build()` methods (>80–100 lines) and services mixing presentation, state management, HTTP parsing, and database transactions.
5. **Architectural Ambiguities & Risks:** Flagging potential rule conflicts (e.g. `.env` vs `--dart-define`, `StatefulWidget` usage in state layers, and hardcoded UI mocks).

---

## 1. Confirmed Dead Code

Every candidate below was verified with a full-repository AST / token scan across both `lib/` and `test/` trees.

### 1.1 `UserModel.totalBalance` Field
* **Locations:**
  * [`lib/features/auth/domain/models/user_model.dart:28`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/domain/models/user_model.dart#L28): `@Default(0.0) double totalBalance,`
  * [`lib/features/auth/data/repositories/auth_repository_impl.dart:72`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/data/repositories/auth_repository_impl.dart#L72): `'totalBalance': 0.0,` (written to Firestore at registration)
  * Generated files: `user_model.freezed.dart`, `user_model.g.dart`
* **Why it is provably unused:**
  * Full-repo grep confirms `user.totalBalance` is **never read or accessed** anywhere in application logic, domain use cases, or presentation widgets.
  * In earlier iterations, the user document held a cached balance. This architecture was superseded by the multi-wallet feature: user net worth is now dynamically computed in `DashboardController` (`ref.watch(walletListProvider)` summing `wallet.balance`).
  * Note: `lib/features/dashboard/presentation/screens/home_screen.dart:98` contains `context.loc.totalBalance`, which references the **localization string** `"Total Balance"`, NOT the `UserModel` model property.
* **Safe Removal Path:** Deprecate/remove `totalBalance` from `UserModel`, remove `'totalBalance': 0.0` from `auth_repository_impl.dart`, and regenerate code via `build_runner`.

---

### 1.2 Superseded & Dead Localization (l10n) Keys
* **Candidate Keys Investigated:** `bank`, `cash`, `paypal`, `creditCard`, `bankAccount` (specifically targeted), plus an exhaustive scan of all 141 keys in `intl_en.arb` / `intl_ar.arb`.
* **Confirmed 100% Unreferenced Keys in Non-Generated Dart Code:**
  1. `bank` (`lib/l10n/intl_en.arb:98` / `intl_ar.arb:98`)
  2. `cash` (`lib/l10n/intl_en.arb:99` / `intl_ar.arb:99`)
  3. `paypal` (`lib/l10n/intl_en.arb:100` / `intl_ar.arb:100`)
  4. `creditCard` (`lib/l10n/intl_en.arb:101` / `intl_ar.arb:101`)
  5. `bankAccount` (`lib/l10n/intl_en.arb:83` / `intl_ar.arb:83`)
  6. `confirmPassword` (`lib/l10n/intl_en.arb:40` / `intl_ar.arb:40`) — Sign-up form does not implement a confirm password field.
  7. `emptyConfirmPassword` (`lib/l10n/intl_en.arb:41` / `intl_ar.arb:41`) — Associated validator error string with no form input.
  8. `unlock` (`lib/l10n/intl_en.arb:60` / `intl_ar.arb:60`) — `LockScreen` exclusively uses `context.loc.fingerPrintLogin`.
  9. `defaultWalletName` (`lib/l10n/intl_en.arb:138` / `intl_ar.arb:138`) — `WalletMigrationService` hardcodes `'Cash'` as a string literal rather than reading `context.loc.defaultWalletName`.
* **Why they are provably unused:**
  * AST search for `.bank`, `.cash`, `.paypal`, `.creditCard`, `.bankAccount`, `loc.<key>`, and `S.of(context).<key>` across all `.dart` files in `lib/` and `test/` (excluding generated `l10n.dart` and `messages_*.dart`) returns exactly **0 references**.
  * The wallet feature now resolves wallet names directly from user-created or migrated `WalletModel.name` strings stored in Firestore, rendering the static category translations obsolete.

---

### 1.3 `SecureStorageService` and `secureStorageServiceProvider`
* **Location:** [`lib/core/services/secure_storage_service.dart:3-10`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/services/secure_storage_service.dart#L3-L10)
  ```dart
  final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
    return SecureStorageService();
  });

  class SecureStorageService {
    // Storage ready for future secure tokens (e.g. API keys, refresh tokens).
    // Raw user credentials (email/password) have been removed for security.
  }
  ```
* **Why it is provably unused:**
  * The class body contains zero fields and zero methods.
  * `secureStorageServiceProvider` is never read or watched in any controller, notifier, or widget.
  * Credentials and biometric states are handled via `BiometricService`, `SharedPreferences`, and Firebase Auth directly.

---

### 1.4 `AppRoutes.transactionDetails` Static Constant
* **Location:** [`lib/core/routing/app_routes.dart:10`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/routing/app_routes.dart#L10)
  ```dart
  static const String transactionDetails = '/transactionDetails';
  ```
* **Why it is provably unused:**
  * In `RouteGenerator` ([`lib/core/routing/router_generator.dart:123`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/routing/router_generator.dart#L123)), the route is registered with `AppRoutes.transactionDetailsWithId` (`'/transactionDetails/:id'`).
  * In navigation calls throughout `home_screen.dart` and `transactions_screen.dart`, navigation uses `context.pushNamed(AppRoutes.transactionDetailsName, pathParameters: {'id': tx.id!})`.
  * The parameterless route constant `AppRoutes.transactionDetails` has 0 references.

---

### 1.5 Dead UI Placeholders / Empty Event Handlers
1. **"More" ActionChip in CategorySelector:**
   * **Location:** [`lib/features/transactions/presentation/widgets/category_selector.dart:49-60`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/category_selector.dart#L49-L60)
   * **Code:** `ActionChip(label: Text(context.loc.more), onPressed: () {}, ...)`
   * **Issue:** Displays an interactive chip that invokes an empty callback without opening any modal or expansion.
2. **"Scan" HomeActionCard in HomeScreen:**
   * **Location:** [`lib/features/dashboard/presentation/screens/home_screen.dart:148-152`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/dashboard/presentation/screens/home_screen.dart#L148-L152)
   * **Code:** `HomeActionCard(icon: Icons.camera_alt, label: context.loc.scan, onTap: () {})`
   * **Issue:** Tap handler is a no-op placeholder.
3. **Search Icon in TransactionsScreen:**
   * **Location:** [`lib/features/transactions/presentation/screens/transactions_screen.dart:29`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/transactions_screen.dart#L29)
   * **Code:** `IconButton(onPressed: () {}, icon: const Icon(Icons.search))`
   * **Issue:** Tap handler is a no-op placeholder.

---

## 2. Duplicated Patterns Worth Extracting

### 2.1 Pattern: ChoiceChip Selector (`WalletSelector` vs `CategorySelector`)
* **Location 1:** [`lib/features/transactions/presentation/widgets/wallet_selector.dart:23-50`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/wallet_selector.dart#L23-L50)
* **Location 2:** [`lib/features/transactions/presentation/widgets/category_selector.dart:22-48`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/category_selector.dart#L22-L48)
* **Side-by-Side Comparison:**

```dart
// WalletSelector (Lines 28-48)
Padding(
  padding: const EdgeInsets.only(right: 8),
  child: ChoiceChip(
    label: Text(wallet.name),
    selected: isSelected,
    onSelected: (_) => onSelect(wallet.id!),
    selectedColor: ColorManager.primaryBlue,
    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
    labelStyle: context.labelSmall.copyWith(
      color: isSelected ? Colors.white : ColorManager.secondaryColor,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide.none,
    ),
    showCheckmark: false,
  ),
);

// CategorySelector (Lines 28-48)
Padding(
  padding: const EdgeInsets.only(right: 8),
  child: ChoiceChip(
    label: Text(cat.getLocalizedName(context)),
    selected: isSelected,
    onSelected: (_) => onSelect(cat),
    selectedColor: ColorManager.primaryBlue,
    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
    labelStyle: context.labelSmall.copyWith(
      color: isSelected ? Colors.white : ColorManager.secondaryColor,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide.none,
    ),
    showCheckmark: false,
  ),
);
```
* **Extraction Plan:** Create a reusable generic widget in `lib/core/widgets/app_chip_selector.dart`:
  ```dart
  class AppChipSelector<T> extends StatelessWidget {
    final List<T> items;
    final T? selectedItem;
    final String Function(T) labelBuilder;
    final void Function(T) onSelected;
    final Widget? trailing;
    // ...
  }
  ```

---

### 2.2 Pattern: Transaction Card / Grouped List Tile (`HomeScreen` vs `TransactionsScreen`)
* **Location 1:** [`lib/features/dashboard/presentation/screens/home_screen.dart:208-256`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/dashboard/presentation/screens/home_screen.dart#L208-L256)
* **Location 2:** [`lib/features/transactions/presentation/screens/transactions_screen.dart:174-220`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/transactions_screen.dart#L174-L220)
* **Description:** Both screens copy-paste the exact same 45-line `ListView.separated` block rendering transaction items:
  * StadiumBorder leading `Card` with `ColorManager.primaryBlue.withValues(alpha: 0.1)`.
  * Category icon via `tx.categoryIcon`.
  * Title with `context.labelMedium`.
  * Formatted date with `ColorManager.secondaryColor`.
  * Formatted amount with `tx.amountColor`.
  * `GestureDetector` pushing `AppRoutes.transactionDetailsName`.
* **Extraction Plan:** Extract a dedicated `TransactionListTile` widget into `lib/features/transactions/presentation/widgets/transaction_list_tile.dart` (or `lib/core/widgets/transaction_list_tile.dart`).

---

### 2.3 Pattern: Full-Screen Loading Overlay (`LoginScreen`, `SignUpScreen`, `ResetPassword`)
* **Location 1:** [`lib/features/auth/presentation/screens/login_screen.dart:214-218`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/login_screen.dart#L214-L218)
* **Location 2:** [`lib/features/auth/presentation/screens/sign_up_screen.dart:205-209`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/sign_up_screen.dart#L205-L209)
* **Location 3:** [`lib/features/auth/presentation/screens/reset_password.dart:121-125`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/reset_password.dart#L121-L125)
* **Existing Canonical Widget:** [`lib/core/widgets/loading_overlay.dart:3-15`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/widgets/loading_overlay.dart#L3-L15)
* **Description:** Despite `LoadingOverlay` existing in `lib/core/widgets/`, all three auth screens duplicate an inline container:
  ```dart
  if (authState.isLoading) // or isLoading.value
    Container(
      color: Colors.black54,
      child: const Center(child: CircularProgressIndicator()),
    ),
  ```
* **Extraction Plan:** Remove the inline duplicate containers and reuse `const LoadingOverlay()`, obeying the FinTrack rule: *"Reuse before create: search `lib/core/widgets/` before creating any widget"*.

---

### 2.4 Pattern: Bottom Sheet Drag Handle (Pill)
* **Location 1:** [`lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart:145-154`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart#L145-L154)
* **Location 2:** [`lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart:79-88`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart#L79-L88)
* **Code:**
  ```dart
  Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  )
  ```
* **Extraction Plan:** Extract `BottomSheetDragHandle` into `lib/core/widgets/bottom_sheet_drag_handle.dart`.

---

### 2.5 Pattern: Auth "OR" Divider
* **Location 1:** [`lib/features/auth/presentation/screens/login_screen.dart:144-160`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/login_screen.dart#L144-L160)
* **Location 2:** [`lib/features/auth/presentation/screens/sign_up_screen.dart:133-149`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/sign_up_screen.dart#L133-L149)
* **Description:** Identical row containing `Expanded(child: Divider(...))`, `Text(context.loc.or).padSymmetric(16)`, and `Expanded(child: Divider(...))`.
* **Extraction Plan:** Extract `AuthOrDivider` into `lib/features/auth/presentation/widgets/auth_or_divider.dart`.

---

### 2.6 Pattern: Outlined Google Sign-In Button
* **Location 1:** [`lib/features/auth/presentation/screens/login_screen.dart:162-200`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/login_screen.dart#L162-L200)
* **Location 2:** [`lib/features/auth/presentation/screens/sign_up_screen.dart:152-190`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/sign_up_screen.dart#L152-L190)
* **Description:** Identical button styling (`ElevatedButton` with `backgroundColor: Colors.transparent`, blue border, Google logo image asset, and `context.loc.continueWithGoogle`).
* **Extraction Plan:** Extract `GoogleSignInButton` into `lib/features/auth/presentation/widgets/google_sign_in_button.dart`.

---

### 2.7 Pattern: Duplicate Seed Wallets List
* **Location 1:** [`lib/features/wallets/data/services/wallet_migration_service.dart:46-62`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/wallets/data/services/wallet_migration_service.dart#L46-L62)
* **Location 2:** [`lib/features/wallets/data/services/wallet_migration_service.dart:106-122`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/wallets/data/services/wallet_migration_service.dart#L106-L122)
* **Description:** Verbatim duplicate list of default secondary `WalletModel` entities (`'Bank Account'`, `'PayPal'`, `'Other'`) instantiated inside the same file in two separate branches of migration logic.
* **Extraction Plan:** Extract to a static const list `WalletMigrationService._defaultSecondaryWallets`.

---

## 3. Design-Token Violations

FinTrack AI mandates that all presentation code avoid raw hex colors, raw Material constants (`Colors.*`), and unscaled padding/borders. All styling must resolve from `Theme.of(context)`, `ColorManager`, or `context.space*` / `app_sizes`.

**Violation Summary:**
* **Total Violations:** 106
* **Material Colors Constants (`Colors.*`):** 54
* **Explicit `EdgeInsets.*`:** 28
* **Explicit `BorderRadius.*`:** 24
* **Hardcoded `Color(0x...)` Hex Literals in Widgets:** 0 *(Clean! All hex values are encapsulated inside `ColorManager`)*

Below is the complete file-and-line register of all 106 violations across 24 files:


#### [lib/core/extension/snackbar_extension.dart](file:///lib/core/extension/snackbar_extension.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L8 | Material Colors Constant | `Colors.white` | `content: Text(message, style: const TextStyle(color: Colors.white)),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L9 | Material Colors Constant | `Colors.red` | `backgroundColor: Colors.red,` | `ColorManager.errorColor` or `colorScheme.error` |
| L18 | Material Colors Constant | `Colors.white` | `content: Text(message, style: const TextStyle(color: Colors.white)),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L19 | Material Colors Constant | `Colors.green` | `backgroundColor: Colors.green,` | `ColorManager.successColor` |

#### [lib/core/widgets/loading_overlay.dart](file:///lib/core/widgets/loading_overlay.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L10 | Material Colors Constant | `Colors.black` | `color: Colors.black.withValues(alpha: 0.1),` | `Theme.of(context).colorScheme.scrim` / `ColorManager.darkBackground` |

#### [lib/features/auth/presentation/screens/login_screen.dart](file:///lib/features/auth/presentation/screens/login_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L133 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L137 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(12),` | `context.space...` or `context.pad...` |
| L164 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L216 | Material Colors Constant | `Colors.black` | `color: Colors.black54,` | `Theme.of(context).colorScheme.scrim` / `ColorManager.darkBackground` |

#### [lib/features/auth/presentation/screens/reset_password.dart](file:///lib/features/auth/presentation/screens/reset_password.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L123 | Material Colors Constant | `Colors.black` | `color: Colors.black54,` | `Theme.of(context).colorScheme.scrim` / `ColorManager.darkBackground` |

#### [lib/features/auth/presentation/screens/sign_up_screen.dart](file:///lib/features/auth/presentation/screens/sign_up_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L106 | Explicit EdgeInsets | `EdgeInsets.zero` | `contentPadding: EdgeInsets.zero,` | `context.space...` or `context.pad...` |
| L153 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L155 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(vertical: 16),` | `context.space...` or `context.pad...` |
| L206 | Material Colors Constant | `Colors.black` | `color: Colors.black54,` | `Theme.of(context).colorScheme.scrim` / `ColorManager.darkBackground` |

#### [lib/features/auth/presentation/screens/splash_screen.dart](file:///lib/features/auth/presentation/screens/splash_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L71 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |

#### [lib/features/auth/presentation/widgets/slider_indicator.dart](file:///lib/features/auth/presentation/widgets/slider_indicator.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L25 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(25),` | `context.circularRadius(...)` or `Theme.of(context)...` |

#### [lib/features/currency/presentation/screens/exchange_rate_gate_screen.dart](file:///lib/features/currency/presentation/screens/exchange_rate_gate_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L60 | Material Colors Constant | `Colors.white` | `style: context.labelLarge.copyWith(color: Colors.white),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/currency/presentation/widgets/currency_selector_dialog.dart](file:///lib/features/currency/presentation/widgets/currency_selector_dialog.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L43 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: EdgeInsets.symmetric(vertical: 24),` | `context.space...` or `context.pad...` |

#### [lib/features/dashboard/presentation/screens/home_screen.dart](file:///lib/features/dashboard/presentation/screens/home_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L89 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(24),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L116 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(` | `context.space...` or `context.pad...` |
| L121 | Material Colors Constant | `Colors.white` | `color: Colors.white.withValues(alpha: 0.2),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L122 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(20),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L129 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L136 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L169 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L232 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(12.0),` | `context.space...` or `context.pad...` |

#### [lib/features/dashboard/presentation/widgets/home_action_card.dart](file:///lib/features/dashboard/presentation/widgets/home_action_card.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L24 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L26 | Explicit EdgeInsets | `EdgeInsets.zero` | `margin: EdgeInsets.zero,` | `context.space...` or `context.pad...` |
| L34 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(12.0),` | `context.space...` or `context.pad...` |

#### [lib/features/dashboard/presentation/widgets/home_skeleton.dart](file:///lib/features/dashboard/presentation/widgets/home_skeleton.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L11 | Material Colors Constant | `Colors.grey[800]` | `? Colors.grey[800]!` | `ColorManager.secondaryColor` / `colorScheme.outline` |
| L12 | Material Colors Constant | `Colors.grey[300]` | `: Colors.grey[300]!;` | `ColorManager.secondaryColor` / `colorScheme.outline` |
| L14 | Material Colors Constant | `Colors.grey[700]` | `? Colors.grey[700]!` | `ColorManager.secondaryColor` / `colorScheme.outline` |
| L15 | Material Colors Constant | `Colors.grey[100]` | `: Colors.grey[100]!;` | `ColorManager.secondaryColor` / `colorScheme.outline` |
| L30 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L31 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(24),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L41 | Explicit EdgeInsets | `EdgeInsets.only` | `margin: EdgeInsets.only(right: index == 2 ? 0 : 12),` | `context.space...` or `context.pad...` |
| L44 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L45 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L55 | Material Colors Constant | `Colors.white` | `Container(height: 20, width: 150, color: Colors.white),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L56 | Material Colors Constant | `Colors.white` | `Container(height: 16, width: 60, color: Colors.white),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L68 | Explicit EdgeInsets | `EdgeInsets.zero` | `margin: EdgeInsets.zero,` | `context.space...` or `context.pad...` |
| L75 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L83 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L84 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(4),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L88 | Explicit EdgeInsets | `EdgeInsets.only` | `margin: const EdgeInsets.only(top: 8),` | `context.space...` or `context.pad...` |
| L92 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L93 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(4),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L100 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L101 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(4),` | `context.circularRadius(...)` or `Theme.of(context)...` |

#### [lib/features/transactions/presentation/screens/transaction_details.dart](file:///lib/features/transactions/presentation/screens/transaction_details.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L125 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: EdgeInsets.symmetric(horizontal: 16),` | `context.space...` or `context.pad...` |
| L155 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L162 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L202 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(20),` | `context.space...` or `context.pad...` |
| L211 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(26.0),` | `context.space...` or `context.pad...` |

#### [lib/features/transactions/presentation/screens/transactions_screen.dart](file:///lib/features/transactions/presentation/screens/transactions_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L80 | Explicit BorderRadius | `BorderRadius.vertical` | `borderRadius: BorderRadius.vertical(` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L113 | Material Colors Constant | `Colors.white` | `? Colors.white` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L121 | Material Colors Constant | `Colors.white` | `? Colors.white` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L140 | Material Colors Constant | `Colors.green` | `color: Colors.green,` | `ColorManager.successColor` |
| L148 | Material Colors Constant | `Colors.red` | `color: Colors.red,` | `ColorManager.errorColor` or `colorScheme.error` |
| L197 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(12.0),` | `context.space...` or `context.pad...` |
| L258 | Material Colors Constant | `Colors.white` | `color: isSelected ? Colors.white : null,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/transactions/presentation/screens/voice_entry_screen.dart](file:///lib/features/transactions/presentation/screens/voice_entry_screen.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L97 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |

#### [lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart](file:///lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L133 | Explicit BorderRadius | `BorderRadius.vertical` | `borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L135 | Explicit EdgeInsets | `EdgeInsets.only` | `padding: EdgeInsets.only(` | `context.space...` or `context.pad...` |
| L151 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(2),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L196 | Explicit EdgeInsets | `EdgeInsets.only` | `padding: const EdgeInsets.only(bottom: 12),` | `context.space...` or `context.pad...` |
| L233 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(16),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L239 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L247 | Material Colors Constant | `Colors.white` | `? Colors.white` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/transactions/presentation/widgets/amount_input_area.dart](file:///lib/features/transactions/presentation/widgets/amount_input_area.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L74 | Material Colors Constant | `Colors.transparent` | `fillColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L82 | Material Colors Constant | `Colors.transparent` | `backgroundColor: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L87 | Explicit EdgeInsets | `EdgeInsets.zero` | `contentPadding: EdgeInsets.zero,` | `context.space...` or `context.pad...` |

#### [lib/features/transactions/presentation/widgets/category_selector.dart](file:///lib/features/transactions/presentation/widgets/category_selector.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L29 | Explicit EdgeInsets | `EdgeInsets.only` | `padding: const EdgeInsets.only(right: 8),` | `context.space...` or `context.pad...` |
| L38 | Material Colors Constant | `Colors.white` | `? Colors.white` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L42 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(8),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L57 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(8),` | `context.circularRadius(...)` or `Theme.of(context)...` |

#### [lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart](file:///lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L70 | Material Colors Constant | `Colors.transparent` | `color: Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L74 | Explicit EdgeInsets | `EdgeInsets.fromLTRB` | `padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),` | `context.space...` or `context.pad...` |
| L85 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(2),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L104 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(8),` | `context.space...` or `context.pad...` |
| L235 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(` | `context.space...` or `context.pad...` |
| L240 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L276 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),` | `context.space...` or `context.pad...` |
| L280 | Material Colors Constant | `Colors.white` | `: Colors.white.withValues(alpha: 0.05),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L281 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L285 | Material Colors Constant | `Colors.white` | `: Colors.white.withValues(alpha: 0.1),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L293 | Material Colors Constant | `Colors.white` | `const Icon(Icons.check, color: Colors.white, size: 18),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L299 | Material Colors Constant | `Colors.white` | `color: isSelected ? Colors.white : ColorManager.secondaryColor,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L337 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),` | `context.space...` or `context.pad...` |
| L339 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(16),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L341 | Material Colors Constant | `Colors.white` | `color: Colors.white.withValues(alpha: 0.1),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L344 | Material Colors Constant | `Colors.white` | `color: Colors.white.withValues(alpha: 0.02),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L352 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/transactions/presentation/widgets/transaction_metadata_row.dart](file:///lib/features/transactions/presentation/widgets/transaction_metadata_row.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L56 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `contentPadding: const EdgeInsets.symmetric(` | `context.space...` or `context.pad...` |
| L61 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L103 | Explicit EdgeInsets | `EdgeInsets.symmetric` | `padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),` | `context.space...` or `context.pad...` |
| L106 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |

#### [lib/features/transactions/presentation/widgets/transaction_type_toggle.dart](file:///lib/features/transactions/presentation/widgets/transaction_type_toggle.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L22 | Explicit EdgeInsets | `EdgeInsets.all` | `padding: const EdgeInsets.all(4),` | `context.space...` or `context.pad...` |
| L25 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(12),` | `context.circularRadius(...)` or `Theme.of(context)...` |
| L63 | Material Colors Constant | `Colors.transparent` | `color: isSelected ? Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.1) : Colors.transparent,` | `Colors.transparent` token or `colorScheme.surface.withValues(alpha: 0)` |
| L64 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(8),` | `context.circularRadius(...)` or `Theme.of(context)...` |

#### [lib/features/transactions/presentation/widgets/voice_action_button.dart](file:///lib/features/transactions/presentation/widgets/voice_action_button.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L62 | Material Colors Constant | `Colors.white` | `style: context.labelLarge.copyWith(color: Colors.white),` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/transactions/presentation/widgets/voice_mic_button.dart](file:///lib/features/transactions/presentation/widgets/voice_mic_button.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L55 | Material Colors Constant | `Colors.white` | `color: Colors.white,` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |

#### [lib/features/transactions/presentation/widgets/wallet_selector.dart](file:///lib/features/transactions/presentation/widgets/wallet_selector.dart)

| Line | Violation Type | Current Value | Code Snippet | Recommended Fix |
|---|---|---|---|---|
| L29 | Explicit EdgeInsets | `EdgeInsets.only` | `padding: const EdgeInsets.only(right: 8),` | `context.space...` or `context.pad...` |
| L38 | Material Colors Constant | `Colors.white` | `? Colors.white` | `ColorManager.white` or `colorScheme.surface` / `onPrimary` |
| L42 | Explicit BorderRadius | `BorderRadius.circular` | `borderRadius: BorderRadius.circular(8),` | `context.circularRadius(...)` or `Theme.of(context)...` |


---

## 4. Long / Mixed-Responsibility Functions or Widgets Worth Splitting

Per project standards, methods or widgets exceeding 80–100 lines that combine data transformation, layout composition, and asynchronous workflow execution should be decomposed into cohesive single-responsibility units.

### 4.1 `HomeScreen.build()` (237 lines: lines 31–267)
* **File:** [`lib/features/dashboard/presentation/screens/home_screen.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/dashboard/presentation/screens/home_screen.dart#L31-L267)
* **Mixed Responsibilities:**
  1. *Side Effects & Listeners:* Listens to `authControllerProvider` for errors and triggers SnackBars.
  2. *Data Shaping:* Reads and formats active currency code with `NumberFormat.currency`.
  3. *App Bar & Profile Header:* Builds custom header with user photo, greeting title, notification button, and currency change modal trigger.
  4. *Total Balance Card:* Custom styled card with hardcoded mockup trend pill (`+2.5% this month`).
  5. *Action Cards Row:* Orchestrates routing/modals for Scan, Voice, and Manual entries.
  6. *Transaction List Presentation:* Direct nested `ListView.separated` with complex inline `ListTile` construction.
* **Recommended Extractions:**
  * `HomeHeader`
  * `TotalBalanceCard`
  * `HomeActionRow`
  * `RecentTransactionsSection` (using extracted `TransactionListTile`)

---

### 4.2 `TransactionsScreen.build()` (217 lines: lines 19–235)
* **File:** [`lib/features/transactions/presentation/screens/transactions_screen.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/transactions_screen.dart#L19-L235)
* **Mixed Responsibilities:**
  1. *Filter State Synchronization:* Directly watches 4 separate providers and mutates notifier state inline via `ref.read(...).state = ...`.
  2. *Date Range Picker Integration:* Imperatively invokes `showModalBottomSheet` for `DateRangeBottomSheet`.
  3. *Financial Aggregation Layout:* Calculates and presents total income, total expense, and net balance summary banner.
  4. *List Rendering:* Full duplicate of `HomeScreen` transaction card mapping.
* **Recommended Extractions:**
  * `TransactionFilterChipsBar`
  * `TransactionFinancialSummaryCard`
  * `TransactionGroupedListView`

---

### 4.3 `AddTransactionBottomSheet.build()` (231 lines: lines 32–262)
* **File:** [`lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart#L32-L262)
* **Mixed Responsibilities:**
  1. *Form State & Lifecycle:* Manages 8 individual state hooks (`selectedType`, `selectedCategory`, `selectedWalletId`, `selectedDate`, `amountController`, `notesController`, `isLoading`, `selectedInputCurrency`).
  2. *Async Currency Conversion Logic:* Inlines exchange rate loading (`rateService.ensureLoaded()`) and multi-currency conversion calculation.
  3. *Transaction Mutation Dispatch:* Builds domain entities and invokes `addTransaction` / `updateTransaction`.
  4. *Heavy Layout:* Bottom sheet decoration, drag handle, type toggle, amount input, category picker, wallet picker, metadata row, notes field, save action button, and loading overlay.
* **Recommended Extractions:**
  * Extract form state management to a dedicated form controller / notifier.
  * Extract `AddTransactionFormContent` from the bottom sheet shell.

---

### 4.4 `DateRangeBottomSheet.build()` (237 lines: lines 21–257)
* **File:** [`lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/widgets/date_range_bottom_sheet.dart#L21-L257)
* **Mixed Responsibilities:**
  1. *Date Math & Clamping:* Inlines 31-day boundary validation logic, date clamping, and SnackBar alerts inside `selectDate`.
  2. *Preset Calculations:* Defines range math for Today, This Week, This Month, etc.
  3. *Layout Hierarchy:* Custom preset chip buttons, start/end date display cards, and action buttons.
* **Recommended Extractions:**
  * Move date range clamping and preset calculation to a domain/utility helper.
  * Extract `DateRangePresetChips` and `DateRangeInputCards`.

---

### 4.5 `TransactionDetails.build()` (191 lines: lines 91–281)
* **File:** [`lib/features/transactions/presentation/screens/transaction_details.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/transaction_details.dart#L91-L281)
* **Mixed Responsibilities:**
  1. *State Management Violation:* Uses `StatefulWidget` and imperatively calls `setState()` for `_isLoading` and `_isSharing` (violating FinTrack's Hook/Riverpod rule).
  2. *Receipt Layout:* `RepaintBoundary` containing receipt cards, badges, metadata rows, and note sections.
  3. *Bottom Action Flow:* Inlines edit bottom sheet launching and delete confirmation dialog with async repository calls.
* **Recommended Extractions:**
  * Convert from `ConsumerStatefulWidget` to `HookConsumerWidget`.
  * Extract `TransactionReceiptCard` (under `RepaintBoundary`).
  * Extract `TransactionDetailsActionButtons`.

---

### 4.6 `VoiceEntryScreen.build()` (164 lines: lines 46–209)
* **File:** [`lib/features/transactions/presentation/screens/voice_entry_screen.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/voice_entry_screen.dart#L46-L209)
* **Mixed Responsibilities:**
  1. *Speech Lifecycle Orchestration:* Handles speech error reason mapping, auto-listening effects, and pulse animation triggering.
  2. *AI Parsing Business Flow:* `processTranscript` invokes Gemini HTTP service, parses JSON to transaction draft, handles navigation pop, and opens pre-filled bottom sheet.
* **Recommended Extractions:**
  * Move `processTranscript` workflow and speech error mapping to an `AsyncNotifier` (`VoiceEntryController`).

---

### 4.7 `HomeSkeleton.build()` (104 lines: lines 9–112)
* **File:** [`lib/features/dashboard/presentation/widgets/home_skeleton.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/dashboard/presentation/widgets/home_skeleton.dart#L9-L112)
* **Mixed Responsibilities:**
  1. Monolithic 104-line layout mirroring `HomeScreen` structure using raw un-tokenized `Container` widgets (20 token violations in one file).
* **Recommended Extractions:**
  * Extract a reusable `SkeletonBox` / `SkeletonItem` widget in `lib/core/widgets/`.

---

### 4.8 `LoginScreen.build()` (203 lines) & `SignUpScreen.build()` (193 lines)
* **Files:**
  * [`lib/features/auth/presentation/screens/login_screen.dart:20-222`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/login_screen.dart#L20-L222)
  * [`lib/features/auth/presentation/screens/sign_up_screen.dart:20-212`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/sign_up_screen.dart#L20-L212)
* **Mixed Responsibilities:**
  * Both screens manage 6+ form state hooks, listen to auth notifier SnackBars, build headers, form inputs, toggle buttons, biometric checkboxes, social buttons, and duplicate overlays in a single file.
* **Recommended Extractions:**
  * Extract shared auth layout shell (`AuthScaffold` or `AuthCardContainer`).

---

### 4.9 `GeminiService.parseTransactionText()` (109 lines: lines 27–135)
* **File:** [`lib/core/services/gemini_service.dart:27-135`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/services/gemini_service.dart#L27-L135)
* **Mixed Responsibilities:**
  * Single function handles HTTP POST dispatch, 3xx redirect location extraction and follow-up GET request, JSON string decoding, error body inspection, HTTP status code translation, and low-level socket/timeout exception mapping.
* **Recommended Extractions:**
  * Split into `_sendWithRedirect(Uri uri, Map body)` and `_handleApiResponse(http.Response response)`.

---

### 4.10 `WalletMigrationService.runIfNeeded()` (94 lines: lines 35–128)
* **File:** [`lib/features/wallets/data/services/wallet_migration_service.dart:35-128`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/wallets/data/services/wallet_migration_service.dart#L35-L128)
* **Mixed Responsibilities:**
  * Checks wallet existence, creates default cash wallet, duplicates creation of secondary wallets, queries user transaction documents, chunks documents into 500-item slices, and writes Firestore batches.
* **Recommended Extractions:**
  * Split into `_seedDefaultWallets()` and `_backfillTransactionWalletIds(String defaultWalletId)`.

---

## 5. Uncertain Items Needing Manual Confirmation

The following findings represent architectural ambiguities, potential rule violations, or unconfirmed behaviors that require developer or stakeholder alignment before modifying:

### 5.1 Environment Configuration: `.env` / `flutter_dotenv` vs `--dart-define`
* **Rule in `AGENTS.md`:** *"Secrets are injected via `--dart-define` only. Never create `.env` files."*
* **Observed Reality:**
  * [`lib/main.dart:20`](file:///D:/D_StudioProjects/fin_track_ai/lib/main.dart#L20): `await dotenv.load(fileName: ".env");`
  * [`lib/core/services/gemini_service.dart:10-11`](file:///D:/D_StudioProjects/fin_track_ai/lib/core/services/gemini_service.dart#L10-L11): reads `dotenv.env['APPS_SCRIPT_PROXY_URL']` and `dotenv.env['APP_SHARED_SECRET']`.
* **Ambiguity:** Is `flutter_dotenv` legacy code slated to be refactored into `const String.fromEnvironment(...)`, or is the `--dart-define` constraint in `AGENTS.md` a future milestone? 
* **Recommendation:** Clarify before removing `flutter_dotenv` and `.env` bootstrap.

---

### 5.2 Hardcoded Dashboard Metric: `+2.5% this month`
* **Location:** [`lib/features/dashboard/presentation/screens/home_screen.dart:134`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/dashboard/presentation/screens/home_screen.dart#L134)
* **Code:** `Text('+2.5% this month', style: context.labelSmall.copyWith(color: Colors.white))`
* **Ambiguity:** This percentage trend is hardcoded in English, not localized in `intl_en.arb`, and not computed from transaction history.
* **Recommendation:** Confirm whether this should be backed by an analytics/calculation provider or removed until financial analytics are implemented.

---

### 5.3 `TransactionDetails` State Management Architecture
* **Location:** [`lib/features/transactions/presentation/screens/transaction_details.dart:82`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/transactions/presentation/screens/transaction_details.dart#L82)
* **Rule in `AGENTS.md`:** *"No setState, no StatefulWidget for business state. Hooks + Riverpod (`HookConsumerWidget`)."*
* **Observed Reality:** `TransactionDetails` is a `ConsumerStatefulWidget` holding `_isLoading` and `_isSharing` flags via `setState()`.
* **Recommendation:** Confirm whether local transient UI flags (sharing loading spinner) are permitted in `StatefulWidget`, or if the screen must strictly be converted to `HookConsumerWidget` using `useState`.

---

### 5.4 Single-Use Widget: `SliderIndicator`
* **Location:** [`lib/features/auth/presentation/widgets/slider_indicator.dart`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/widgets/slider_indicator.dart)
* **Usage:** Used only in [`lib/features/auth/presentation/screens/onboarding_screen.dart:107`](file:///D:/D_StudioProjects/fin_track_ai/lib/features/auth/presentation/screens/onboarding_screen.dart#L107).
* **Ambiguity:** Placed under `lib/features/auth/presentation/widgets/` rather than `core/widgets/`. If no other sliders are planned, consider whether it should stay a feature widget or be folded into `onboarding_screen.dart`.

---

### 5.5 Inconsistent Modal Radius Token
* **Location:** `AddTransactionBottomSheet` uses `Radius.circular(32)` while `date_range_bottom_sheet.dart` and `home_screen.dart` alternate between `20`, `24`, and `32`.
* **Recommendation:** Unify modal and card radius tokens in `AppTheme`.

---

## 6. Actionable Next Steps (Prioritized Roadmap)

When approval is granted to proceed with cleanup and refactoring, the following phased approach is recommended:

| Phase | Task | Impact / Benefit | Risk Level |
|---|---|---|---|
| **Phase 1** | Clean dead l10n keys (`intl_en.arb` / `intl_ar.arb`) & remove `AppRoutes.transactionDetails` | Reduces translation bundle & route confusion | Zero risk |
| **Phase 2** | Extract `AppChipSelector<T>` to unify `WalletSelector` and `CategorySelector` | Eliminates duplicated ChoiceChip logic | Low risk |
| **Phase 3** | Extract `TransactionListTile` to unify `HomeScreen` and `TransactionsScreen` | Eliminates 45+ lines of identical UI code | Low risk |
| **Phase 4** | Replace inline black54 overlays with canonical `LoadingOverlay` | Standardizes loading UX across auth screens | Low risk |
| **Phase 5** | Token audit pass: Replace 106 token violations with `Theme` / `ColorManager` / `AppSizes` | Establishes full light/dark theme compliance | Low-medium risk |
| **Phase 6** | Split `HomeScreen`, `TransactionsScreen`, and `AddTransactionBottomSheet` | Enhances readability and interview architectural clarity | Medium risk |
| **Phase 7** | Align `UserModel.totalBalance` and `.env` with `AGENTS.md` guidelines | Domain contract cleanup (requires `build_runner`) | Medium risk |

