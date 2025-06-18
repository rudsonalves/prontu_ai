# prontu_ai

A new Flutter project.

# ChangeLog

## 2025/06/18 home_view - by rudsonalves

### Add User Form Flow, UI Components, Enums, Extensions, and Validation

This commit enhances the **ProntuAI** application by introducing a full user-management workflow: form screens for creating/editing users, domain enums for labels, layout constants, reusable UI widgets (buttons, cards, fields), and validation. Utility extensions for date formatting and string handling support the new form, while minor fixes improve toggle behavior and repository insert logic.

### Modified Files

* **docs/.\$Diagrama de Classes.drawio.dtmp**

  * removed obsolete temporary export

* **lib/app\_theme\_mode.dart**

  * changed `toggle()` from `Future<void>` to synchronous `void` method

* **lib/data/repositories/*/*\_repository.dart** (all four repositories)

  * simplified `insert` to assign `result.value` to a local copy before caching and return that new instance

* **lib/domain/models/episode\_model.dart**

  * adjusted inline comments spacing for consistency

* **lib/domain/models/user\_model.dart**

  * removed embedded `Sex` enum declaration; now imports from `enums_declarations.dart`

* **lib/routing/router.dart**

  * reordered imports and added a new `/user` route mapped to `FormUserView` with `FormUserViewModel`

* **lib/routing/routes.dart**

  * added `user` route constant (`/user`)

* **lib/ui/core/theme/theme.dart**

  * standardized import quoting and trimmed trailing list initializers

* **lib/ui/view/home/home\_view\.dart**

  * switched theme-icon action to listen on `HomeViewModel.themeMode`
  * refactored body to display user list via `DismissibleCard`, loading indicator, empty state, and navigation to user form

* **lib/ui/view/home/home\_view\_model.dart**

  * injected `AppThemeMode`, added `delete` command, updated load/delete logic, and exposed `users`, `toggleTheme`, and `isDark` getters

* **test/data/services/database/database\_service\_test.dart**

  * added import for `enums_declarations.dart` to support new `Sex` enum

### New Files

* **lib/domain/enums/enums\_declarations.dart**
  defines `EnumLabel` interface and `Sex` enum with labels

* **lib/ui/core/theme/dimens.dart**
  responsive padding, spacing, radius, and border-radius constants

* **lib/ui/core/ui/buttons/big\_button.dart**
  customizable full-width button with loading state

* **lib/ui/core/ui/dismissibles/dismissible\_card.dart**
  swipe-to-edit/remove card wrapper

* **lib/ui/core/ui/dismissibles/dismissible\_container.dart**
  styled background container for dismissible actions

* **lib/ui/core/ui/form\_fields/basic\_form\_field.dart**
  styled `TextFormField` wrapper with validation handling

* **lib/ui/core/ui/form\_fields/date\_form\_field.dart**
  date picker field that formats Brazilian dates

* **lib/ui/core/ui/form\_fields/enum\_form\_field.dart**
  toggle-buttons-based enum selector

* **lib/ui/core/ui/form\_fields/widgets/toggle\_buttons\_text.dart**
  text widget used inside enum toggle buttons

* **lib/ui/view/home/form\_user/form\_user\_view\.dart**
  form screen for creating and editing `UserModel`

* **lib/ui/view/home/form\_user/form\_user\_view\_model.dart**
  view model wiring insert/update commands with simulated delays

* **lib/utils/extensions/date\_time\_extensions.dart**
  extension to format `DateTime` as `DD/MM/YYYY` and parse back

* **lib/utils/extensions/string\_extentions.dart**
  extension to strip non-digits and detect Brazilian date format

* **lib/utils/validates/generic\_validations.dart**
  common validation methods for name, phone, birth date, and sex

### Conclusion

The user-management feature is now complete with form-driven creation, editing, and deletion flows—powered by shared UI components, robust validation, and clear domain abstractions.

## 2025/06/17 repository-02 - by rudsonalves

### Rename Tables to TableNames and Propagate Across Repositories

This commit renames the central `Tables` class to `TableNames` to better align with its purpose and updates all repository implementations, imports, and tests accordingly. It also fixes a typo in the `EpisodeModel` (`wieght` → `weight`), ensures theming widgets rebuild on mode changes, and tidies up SQL table definitions.

### Modified Files

* **lib/data/common/table\_names.dart**

  * renamed from `tables.dart` and changed class `Tables` → `TableNames`

* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**

  * updated import from `…/common/tables.dart` → `…/common/table_names.dart`
  * replaced all `Tables.*` references with `TableNames.*`

* **lib/data/repositories/attachment/attachment\_repository.dart**

  * updated import path to `../../common/table_names.dart`
  * replaced `Tables.attachments` and `Tables.users` with `TableNames.attachments` / `TableNames.users`

* **lib/data/repositories/episode/episode\_repository.dart**

  * updated import to `../../common/table_names.dart`
  * switched all `Tables.episodes` and `Tables.sessions` calls to `TableNames.episodes` / `TableNames.sessions`
  * fixed deletion to call `TableNames.sessions` per existing logic

* **lib/data/repositories/session/session\_repository.dart**

  * updated import to `../../common/table_names.dart`
  * replaced `Tables.sessions` references with `TableNames.sessions`

* **lib/data/repositories/user/user\_repository.dart**

  * updated import to `../../common/table_names.dart`
  * replaced all `Tables.users` with `TableNames.users`

* **lib/data/services/database/database\_service.dart**

  * corrected batch execution from `SqlTables.user` → `SqlTables.users`

* **lib/data/services/database/tables/sql\_tables.dart**

  * renamed SQL constant `user` → `users` to match table name
  * added multi‐table definitions (`sessions`, `episodes`, `attachments`, `aiSummaries`)

* **lib/domain/models/episode\_model.dart**

  * fixed property and map key spelling: `wieght` → `weight`

* **lib/ui/core/theme/theme.dart**

  * standardized import quotation marks
  * trimmed trailing blank lines and ensured `List<ExtendedColor>` is an empty list

* **lib/ui/view/home/home\_view\.dart**

  * replaced raw `Icon` in the AppBar action with a `ListenableBuilder` around `widget.themeMode` so the icon updates when theme changes

* **test/data/services/database/database\_service\_test.dart**

  * updated import to `package:prontu_ai/data/common/table_names.dart`
  * replaced `Tables.users` with `TableNames.users` in all test calls

### Conclusion

All table references have been consolidated under `TableNames`, domain typos corrected, and UI theming behaviors improved—ensuring consistency and correctness across the codebase.


## 2025/06/17 repository-01 - by rudsonalves

### Scaffold Core Architecture with DI, Theming, Routing, and Data Repositories

This commit establishes the foundational architecture for **ProntuAI** by introducing dependency injection in a composition root, transforming the application entrypoint to support async initialization, integrating dynamic theming and GoRouter-based navigation, and scaffolding comprehensive repository layers with SQLite-backed CRUD operations. Domain models, interfaces, and concrete implementations for Affiliates, AI summaries, Attachments, Episodes, Sessions, and Users are added alongside updated documentation and diagrams to reflect these enhancements.

### Modified Files

* **README.md**

  * renamed “Getting Started” to “ChangeLog” and structured entries by date and feature
  * consolidated two separate commit descriptions into a unified changelog format
* **android/app/build.gradle.kts**

  * replaced `ndkVersion = flutter.ndkVersion` with fixed `"27.0.12077973"` for reproducible builds
* **lib/config/composition\_root.dart**

  * added `DatabaseService.initialize` in the root, registered `AppThemeMode`, `DatabaseService`, and `IUserRepository` with Provider
* **lib/data/services/database/database\_service.dart**

  * introduced `forceRemote` parameter in fetch methods
  * ensured `_db` null-safety checks remain consistent
* **lib/main.dart**

  * converted `main()` to `async`, initialized Flutter bindings, awaited DI composition, and wrapped `MainApp` with `MultiProvider`
* **lib/main\_app.dart**

  * refactored `MainApp` from `StatelessWidget` to `StatefulWidget`
  * wired `GoRouter`, applied dynamic theming via `AppThemeMode`, and removed boilerplate home view import
* **lib/ui/view/home/home\_view\.dart**

  * injected `AppThemeMode` and `HomeViewModel`
  * added theme-toggle button, `FloatingActionButton`, and wrapped text in a `Card` with padding
* **test/data/services/database/database\_service\_test.dart**

  * updated import path for `UserModel` under `domain/models`
  * clarified cache lookup comment

### New Files

* **lib/data/common/tables.dart**
  centralizes table name constants (users, sessions, episodes, attachments, aiSummaries, affiliates)
* **lib/data/repositories/affiliate/i\_affiliate\_repository.dart**
  defines composite-key CRUD interface for `Affiliate` entities
* **lib/data/repositories/affiliate/affiliate\_repository.dart**
  implements `IAffiliateRepository` with role-aware local cache and database service flows
* **lib/data/repositories/ai\_summary/i\_ai\_summary\_repository.dart**
  interface for AI summary lifecycle (initialize, insert, fetch, fetchAll, update, delete)
* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**
  concrete `AiSummaryRepository` with in-memory cache, startup guard, and SQLite CRUD
* **lib/data/repositories/attachment/i\_attachment\_repository.dart**
  interface for Attachment CRUD operations
* **lib/data/repositories/attachment/attachment\_repository.dart**
  implements `IAttachmentRepository` with caching and error logging
* **lib/data/repositories/episode/i\_episode\_repository.dart**
  interface for Episode CRUD operations
* **lib/data/repositories/episode/episode\_repository.dart**
  implements `IEpisodeRepository` with in-memory cache and database error handling
* **lib/data/repositories/session/i\_session\_repository.dart**
  interface for Session CRUD operations
* **lib/data/repositories/session/session\_repository.dart**
  implements `ISessionRepository` with cache synchronization and logging
* **lib/data/repositories/user/i\_user\_repository.dart**
  updated `IUserRepository` to expose `List<UserModel> get users` and support force-remote fetch
* **lib/data/repositories/user/user\_repository.dart**
  enhanced to return `UserModel` on insert, support optional remote fetch, and rename cache getter to `users`
* **lib/domain/models/ai\_summary\_model.dart**
  data class with `toMap()`, `fromMap()`, and `copyWith()` for AI summaries
* **lib/domain/models/attachment\_model.dart**
  includes enum `AttachmentType`, mapping methods, and copy semantics
* **lib/domain/models/episode\_model.dart**
  domain model for clinical episodes with weight/height fields and timestamp handling
* **lib/domain/models/session\_model.dart**
  session model capturing doctor, phone, and notes with mapping logic
* **lib/domain/models/user\_model.dart**
  renamed path, fixed `Sex.byName` static call, and expanded `copyWith` syntax
* **lib/routing/router.dart**
  defines `GoRouter` setup with a home route and dependency injection of view model
* **lib/routing/routes.dart**
  centralizes route name/path definitions
* **lib/ui/core/theme/fonts.dart**
  declares font families and responsive text style interfaces
* **lib/ui/core/theme/theme.dart**
  implements `MaterialTheme` wrapping full light/dark/color-contrast `ColorScheme`s with M3 theming
* **lib/ui/core/theme/util.dart**
  provides `createTextTheme()` to merge Google Fonts into Flutter’s `TextTheme`
* **lib/ui/view/home/home\_view\_model.dart**
  simple `HomeViewModel` with `Command0` to initialize the user repository
* **docs/mvvm\_draw\.svg**
  added illustrative MVVM class diagram asset

### Assets and Test Data

* **docs/mvvm\_draw\.svg**
  high-fidelity SVG diagram illustrating the MVVM architecture used across the app

### Conclusion

The application now features a robust architecture with dependency injection, dynamic theming, modular navigation, and fully scaffolded data-access layers—ready for further feature development and testing.


## 2025/06/16 repository - by rudsonalves

### Implement AffiliateRepository with Composite-Key CRUD and Update Diagrams

This commit adds full support for athlete–club affiliations by introducing `AffiliateRepository` and its interface, extends the database service with composite-key CRUD methods, refactors address cache key generation for consistency, and refines the class diagrams to reflect nullable semantics and improved layout.

### Modified Files

* **doc/images/Estudo de Interface para o App.excalidraw**

  * changed the `sex` field label to `enum Sex?` to indicate nullability.
* **docs/Diagrama de Classes.drawio**

  * updated the graph model dimensions (`dx`, `dy`) and added explicit route points in edge geometry for clearer connections.
* **lib/data/repositories/address/address\_repository.dart**

  * replaced the hard-coded cache key string with the `_cacheKey(addressId)` helper for uniform cache access.
* **lib/data/repositories/common/server\_names.dart**

  * added `Tables.affiliate` constant and `AffiliatesTableColumns` for composite keys (`club_id`, `athlete_id`).
* **lib/data/services/database/database\_service.dart**

  * implemented new methods:

    * `fetchByCompositeKey` to query a single row by multiple key fields,
    * `addRegister`, `updateRegister`, and `deleteRegister` for insert/update/delete operations using a key map.
* **lib/data/services/database/i\_database\_service.dart**

  * declared the composite-key and register methods in the interface.

### New Files

* **lib/data/repositories/affiliate/i\_affiliate\_repository.dart**
  interface defining initialization and CRUD operations for `Affiliate` entities.
* **lib/data/repositories/affiliate/affiliate\_repository.dart**
  concrete implementation of `IAffiliateRepository` that manages local caching via `ICacheService` and remote persistence via `IDatabaseService`, handling initialization, fetch, add, update, and delete flows with proper role checks.

### Conclusion

Affiliate management is now fully supported, with robust composite-key database operations, consistent caching, and updated documentation visuals to match the new data model.


2025/06/16 affiliate - by rudsonalves

### Introduce Workflow Automation, Lint Rules, Common Tables, and Scaffold Core Repositories

This commit adds project-wide tooling and conventions—including a Makefile for common commands and stricter lint rules—defines shared table names, and scaffolds repository interfaces and implementations for AI summaries, attachments, episodes, sessions, and users. It also refactors the SQLite-based `DatabaseService` to guard initialization and use named parameters for update/delete operations.

### Modified Files

* **analysis\_options.yaml**

    * enabled `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, and `prefer_single_quotes` lint rules for more consistent Dart style
* **lib/data/services/database/database\_service.dart**

    * added `_started` flag to prevent reinitialization
    * refactored `update` and `delete` methods to use named parameters (`id`, `map`) and return `const Result.success(null)`
    * reorganized imports for `Result`

### New Files

* **Makefile**

    * defines targets: `diff`, `push`, `push_branch`, `rebuild`, `test_coverage`, `test_serial`, and `update_splash` to streamline development workflows
* **lib/data/common/tables.dart**

    * centralizes table name constants (`users`, `sessions`, `episodes`, `attachments`, `aiSummaries`)
* **lib/data/repositories/ai\_summary/i\_ai\_summary\_repository.dart**

    * interface with `initialize()` and `delete(String uid)` methods for AI summaries
* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**

    * basic implementation of `IAiSummaryRepository`, with initialization guard and `delete` via `DatabaseService`
* **lib/data/repositories/attachment/i\_attachment\_repository.dart**

    * interface with `initialize()` and `delete(String uid)` for attachments
* **lib/data/repositories/attachment/attachment\_repository.dart**

    * implementation of `IAttachmentRepository` using `DatabaseService.delete`
* **lib/data/repositories/episode/i\_episode\_repository.dart**

    * interface with `initialize()` and `delete(String uid)` for episodes
* **lib/data/repositories/episode/episode\_repository.dart**

    * implementation of `IEpisodeRepository`
* **lib/data/repositories/session/i\_session\_repository.dart**

    * interface with `initialize()` and `delete(String uid)` for sessions
* **lib/data/repositories/session/session\_repository.dart**

    * implementation of `ISessionRepository`
* **lib/data/repositories/user/i\_user\_repository.dart**

    * full CRUD interface (`initialize`, `insert`, `fetch`, `fetchAll`, `update`, `delete`) for users
* **lib/data/repositories/user/user\_repository.dart**

    * implementation of `IUserRepository` with startup guard and methods backed by `DatabaseService`

### Conclusion

Development tasks are now automated via the Makefile, code style is enforced consistently, shared table names are centralized, and the core data-access layers for AI summaries, attachments, episodes, sessions, and users have been scaffolded and integrated with the SQLite service.