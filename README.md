# prontu_ai

A new Flutter project.

# ChangeLog

## 2025/06/20 splash-suh - by Suelen

### Add animated splash screen and update initial routing

Implemented a new animated splash screen to enhance the app’s startup experience. Updated routing to launch the splash view first, registered the splash view and its ViewModel, and included new assets for icons. Adjusted asset declarations in `pubspec.yaml` to ensure proper bundling.

### Modified Files

* **lib/routing/router.dart**

  * Switched `initialLocation` from `Routes.home.path` to `Routes.splash.path`.
  * Refactored imports for internal packages to use absolute paths (`/data/...`, `/domain/...`).
  * Added imports for `SplashLogoView` and `SplashViewModel`.
  * Inserted a `GoRoute` entry for the splash screen before the home route.

* **lib/routing/routes.dart**

  * Introduced `static const splash = Route('splash', '/splash');` to define the splash route.

* **pubspec.yaml**

  * Expanded the `assets` section to include the new `assets/icons/` directory alongside existing images.

### New Files

* **lib/ui/view/splash/splash\_view\.dart**
  Implements `SplashLogoView`, a stateful widget that:

  * Controls a 3-second `AnimationController` with a `Tween` scaling from 0.30 to 1.6.
  * Uses `ScaleTransition` to animate the logo asset based on current theme.
  * Waits 500 ms after the animation and then navigates to the home route.

* **lib/ui/view/splash/splash\_view\_model.dart**
  Defines `SplashViewModel`, wrapping `AppThemeMode` to expose an `isDark` flag for asset selection.

### Assets and Test Data

* **assets/icons/**

  * New directory registered for application icons.

### Conclusion

All changes complete—splash screen flow is now integrated and the app starts with the animated view successfully.


## 2025/06/20 ia_service-04 - by rudsonalves

### Refactor AI summary workflow, add MedicalRecord DTO, upsert support, and UI polish

This set of changes restructures the AI-driven summarization to consume a unified `MedicalRecord` DTO, enhances database support with a `set` (upsert) operation, makes clinical fields nullable to reflect optional inputs, and polishes the UI with icons, age display, and improved date formatting. The AI prompt now includes episode details, sessions, and attachments for richer context.

### Modified Files

* **ARCHITECTURE.md**

  * Fixed checklist formatting by replacing raw hyphens with checked bullets for patient and session registration.

* **lib/data/services/database/database\_service.dart**

  * Added `set<T>(table, map)` method with `ConflictAlgorithm.replace` to upsert records requiring a known `id`.

* **lib/data/services/database/tables/sql\_tables.dart**

  * Made `history` and `anamnesis` columns in `episodes` nullable.
  * Removed redundant `episode_id` from `ai_summaries` table, retaining only `id`, `summary`, `specialist`, and timestamps.

* **lib/data/services/open\_ia/open\_ia\_service.dart**

  * Changed `analyze` to accept `MedicalRecord` instead of `EpisodeModel`.
  * Generated a detailed, multi-section prompt listing episode info, sessions, attachments, and formatting instructions.
  * Preserved JSON parsing logic but now handles optional fields and alternative keys.

* **lib/domain/dtos/episode\_analysis.dart**

  * Made `recommendedSpecialist` and `clinicalSummary` nullable to handle partial or missing AI outputs.

* **lib/domain/dtos/medical\_record.dart** *(new)*

  * Defines `MedicalRecord` containing an `EpisodeModel`, its `SessionModel` list, and its `AttachmentModel` list.

* **lib/domain/models/ai\_summary\_model.dart**

  * Switched `id` to non-nullable, removed `episodeId` (now embedded in the key), and simplified `toMap`/`fromMap`.

* **lib/domain/models/episode\_model.dart**

  * Updated `fromMap` to load `history` and `anamnesis` as nullable strings.

* **lib/domain/models/user\_model.dart**

  * Added `age` getter calculating the user’s age from their birth date.

* **lib/domain/user\_cases/episode\_ai\_summary\_user\_case.dart**

  * Injected `ISessionRepository` and `IAttachmentRepository` to assemble a `MedicalRecord` by loading sessions and attachments before calling AI analysis.
  * Changed `analiseEpisode` signature to accept an `EpisodeModel` and return a tuple `(AiSummaryModel, EpisodeModel)`.

* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**

  * Adapted `analiseEpisode` to take a `MedicalRecord`, guard initialization, cache by record ID, and use `DatabaseService.set` for upserts.

* **lib/data/repositories/ai\_summary/i\_ai\_summary\_repository.dart**

  * Updated `analiseEpisode` to accept `MedicalRecord` parameter.

* **lib/routing/router.dart**

  * Expanded `EpisodeAiSummaryUserCase` instantiation with `sessionRepository` and `attachmentRepository`.

* **lib/ui/core/ui/texts/parse\_rich\_text.dart**

  * Added trim and empty-string guard before switching on leading characters to avoid index errors.

* **lib/ui/view/home/home\_view\.dart**

  * Cleaned imports, replaced raw date subtitle with `user.age` and gender icon, and ensured `simple_dialog` uses root-relative imports.

* **lib/ui/view/session/session\_view\.dart**

  * Added leading stethoscope icon to each session card, used `toBrDateTime()` extension for timestamp display, and cleaned route navigation.

* **lib/utils/extensions/date\_time\_extensions.dart**

  * Introduced `toBrDateTime()` to render `"DD/MM/YYYY - HH:MMh"` format.

* **Various form views**

  * In **FormEpisodeView**, trimmed and conditionally assigned nullable `history`/`anamnesis`, and commented out now-redundant validators.
  * In **FormSessionView** and **FormAttachmentView**, ensured `SingleChildScrollView` wraps body, removed premature `super.dispose()`, and updated save logic to trim inputs.

### New Files

* **docs/mvvm.png**
  Added MVVM architecture diagram to the `docs` folder.

* **lib/domain/dtos/medical\_record.dart**
  Defines the composite DTO passed to AI analysis.

### Assets and Test Data

*None beyond the MVVM diagram.*

### Conclusion

The AI assistant now leverages full episode context, database operations support reliable upserts, domain models reflect optional data, and the UI offers clearer icons, age display, and localized timestamps—delivering a robust, end-to-end medical record summarization feature.


## 2025/06/20 ia_service-03 - by rudsonalves

### Implement AI summary caching, database set operation, and UI integration

This commit enhances the AI summary feature by adding caching in `AiSummaryRepository`, introducing a generic `set` method to `DatabaseService`, refining SQL schema for optional fields, and updating the episode view and view model to display detailed AI results through a dialog. Composition root and service initialization are aligned for dependency injection of OpenAI and summary repositories.

### Modified Files

* **lib/config/composition\_root.dart**

  * Moved AI summary and OpenIA imports to root-relative paths.

* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**

  * Guard initialization in `analiseEpisode`, return cached summary if exists.
  * Wrap AI analysis in `try`/`catch` and log errors.
  * Use `DatabaseService.set` instead of `insert` for upserts, and populate `_cache` consistently.
  * Adjusted cache merging in `fetchAll` and removed null-check on `id` for updates.

* **lib/data/services/database/database\_service.dart**

  * Added `set<T>(table, map)` method to perform inserts requiring an existing `id`.

* **lib/data/services/database/tables/sql\_tables.dart**

  * Made `history` and `anamnesis` nullable in episodes table.
  * Added `specialist` column to the `ai_summaries` table schema.

* **lib/data/services/open\_ia/open\_ia\_service.dart**

  * Removed hard-coded fallback, left commented examples.

* **lib/domain/models/ai\_summary\_model.dart**

  * Switched `id` to non-nullable, removed `episodeId` field, and simplified `toMap`/`fromMap`.

* **lib/domain/models/episode\_model.dart**

  * Made `history` and `anamnesis` nullable in the DTO to match the database.

* **lib/domain/user\_cases/episode\_ai\_summary\_user\_case.dart**

  * Changed `analiseEpisode` to return a tuple `(AiSummaryModel, EpisodeModel)` on success.

* **lib/ui/view/episode/episode\_view\.dart**

  * Updated `_showIAAssistant` to unpack the tuple and display a `simple_dialog` with specialist and summary.
  * Imported `Symbols` and `simple_dialog.dart`; enhanced the AI button and dialog formatting.

* **lib/ui/view/episode/episode\_view\_model.dart**

  * Renamed injected field to `_episodeAiUserCase` and updated `analise` command type to match the tuple return.

### Conclusion

AI summaries are now cached and persisted via the new `set` operation, the schema supports nullable clinical fields, and the episode view cleanly presents specialist recommendations and summaries in a dialog.


## 2025/06/20 ia_service-02 - by rudsonalves

### Integrate AI-driven episode summaries and register summary repository

This commit adds AI-powered medical episode analysis by introducing `AiSummaryRepository`, integrating `OpenIaService`, and wiring an `EpisodeAiSummaryUserCase` into the routing and view models. The composition root is updated to provide AI services, repository methods now check fetch results, and UI snackbars and dialogs are enhanced for consistency.

### Modified Files

* **lib/config/composition\_root.dart**

  * Imported and provided `OpenIaService` and `IAiSummaryRepository` with `AiSummaryRepository`.

* **lib/data/repositories/ai\_summary/ai\_summary\_repository.dart**

  * Wired `DatabaseService` and `OpenIaService` into `AiSummaryRepository`.
  * Updated `initialize` to fetch existing summaries and invoke AI service initialization.
  * Added `analiseEpisode` to call AI analysis, map JSON response into `AiSummaryModel`, and persist it.
  * Replaced hard-coded table names with `TableNames.aiSummaries` in all CRUD methods.

* **lib/data/repositories/ai\_summary/i\_ai\_summary\_repository.dart**

  * Added `analiseEpisode(EpisodeModel)` to the interface.

* **lib/data/services/open\_ia/open\_ia\_service.dart**

  * Changed `initialize` to return `Result<void>` with error handling and select the `gpt-3.5-turbo` model.
  * Refactored `analyze` to use the chat endpoint with JSON formatting instructions, parse the returned JSON, and wrap results in `Result<EpisodeAnalysis>`.

* **lib/domain/models/ai\_summary\_model.dart**

  * Added `specialist` field, default `createdAt`, and updated `toMap`/`fromMap` to include it.

* **lib/domain/user\_cases/episode\_ai\_summary\_user\_case.dart** *(new)*

  * Created `EpisodeAiSummaryUserCase` to coordinate episode initialization, deletion, and AI analysis through repositories.

* **lib/routing/router.dart**

  * Imported `EpisodeAiSummaryUserCase` and injected it into `EpisodeViewModel` instead of the raw episode repository.

* **lib/ui/core/ui/dialogs/app\_snack\_bar.dart**

  * Enhanced `showSnackSuccess` signature to accept named `message`, optional icon, and configurable duration.

* **lib/ui/view/episode/episode\_view\.dart**

  * Added help icon to AppBar, bind `analise` command listener, show progress indicator on AI button, and display results via snackbars.
  * Imported `simple_dialog.dart` and `Symbols` for help dialog content.

* **lib/ui/view/episode/episode\_view\_model.dart**

  * Swapped raw repository for `EpisodeAiSummaryUserCase`, added `analise` command alongside `load` and `delete`.

### New Files

* **lib/domain/user\_cases/episode\_ai\_summary\_user\_case.dart**
  Encapsulates the workflow for loading episodes, initializing AI summary service, deleting episodes, and performing AI analysis.

### Conclusion

AI-driven episode summarization is now fully integrated—from dependency provision to UI triggers—enabling concise specialist recommendations and clinical summaries in the app.


## 2025/06/20 make_a_simple_routing-01 - by rudsonalves

### Ensure fetchAll results are checked, clean imports, and refine form behaviors

This commit adds failure handling for `fetchAll` in all repositories, standardizes import paths, fixes disposal order in forms, adjusts scrolling behavior, and corrects navigation in the session view for a more robust and consistent codebase.

### Modified Files

* **lib/data/repositories/ai\_summary/i\_ai\_summary\_repository.dart**

  * Updated imports to use root-relative paths (`/domain/models` and `/utils/result`).

* **lib/data/repositories/attachment/attachment\_repository.dart**

  * After setting `_sessionId`, now awaits `fetchAll()` and returns on failure.
  * In `delete()`, checks delete result for failure before removing from cache.

* **lib/data/repositories/attachment/i\_attachment\_repository.dart**

  * Cleaned imports to root-relative.

* **lib/data/repositories/episode/episode\_repository.dart**

  * Wrapped `fetchAll()` in failure check in `initialize`.
  * In `delete()`, returns on failure before cache removal.

* **lib/data/repositories/episode/i\_episode\_repository.dart**

  * Cleaned imports.

* **lib/data/repositories/session/session\_repository.dart**

  * Added failure-handling around `fetchAll()` in `initialize`.
  * In `delete()`, returns on failure before cache removal.

* **lib/data/repositories/user/user\_repository.dart**

  * Checks `fetchAll()` result and returns on failure in `initialize`.

* **lib/main.dart**

  * Updated `composition_root` import to use root-relative path.

* **lib/ui/core/ui/dialogs/botton\_sheet\_message.dart.dart**

  * Adjusted import of `parse_rich_text.dart` to root-relative.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Cleaned import paths to root-relative and removed redundant import.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart**

  * Removed premature `super.dispose()` so listeners are removed before `super.dispose()`.

* **lib/ui/view/episode/episode\_view\.dart**

  * Converted all imports to root-relative.
  * Added `maxLines: null` on long text form fields to allow dynamic height.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Added `maxLines: null` on multiline fields for unbounded expansion.

* **lib/ui/view/home/form\_user/form\_user\_view\.dart**

  * Cleaned back-button import path to root-relative.

* **lib/ui/view/session/form\_session/form\_session\_view\.dart**

  * Changed body to `SingleChildScrollView` to support scrolling.
  * Moved listener removal before `super.dispose()`.
  * Added `maxLines: null` and corrected `textCapitalization` and trimmed field values on save.

* **lib/ui/view/session/session\_view\.dart**

  * Updated session title to include phone number.
  * Fixed navigation to attachment view using `Routes.attachment.path`.

* **lib/utils/command.dart**

  * Standardized import of `result.dart` to root-relative.

### Conclusion

All repositories now guard against fetch failures, imports are unified, and form views properly handle scrolling, disposal, and navigation—ensuring improved stability and user experience.


## 2025/06/20 make_a_simple_routing - by rudsonalves

### Standardize repository initialization, simplify routing, and add back-button component

This commit refactors dependency injection and routing to use provider-scoped repositories with parameterized `initialize` methods, replaces nested `ShellRoute` blocks with flat `GoRoute` definitions, and introduces a reusable `IconBackButton` widget. ViewModels now expose `load` commands accepting IDs, ensuring data fetches occur only when needed.

### Modified Files

* **lib/config/composition\_root.dart**

  * Registered `IEpisodeRepository`, `ISessionRepository`, and `IAttachmentRepository` in the provider list without requiring ID parameters at construction.
  * Consolidated provider `create` closures to use consistent `ctx` naming.

* **lib/data/repositories/attachment/attachment\_repository.dart**

  * Removed constructor `sessionId` parameter and introduced a nullable `_sessionId` field.
  * Updated `initialize` signature to `initialize(String sessionId)`, guarding against redundant initializations.

* **lib/data/repositories/attachment/i\_attachment\_repository.dart**

  * Changed `initialize()` to `initialize(String sessionId)` in the interface.

* **lib/data/repositories/episode/episode\_repository.dart**

  * Removed `userId` constructor argument in favor of an internal nullable `_userId`.
  * Updated `initialize` to accept `String userId` and fetch all episodes only on first call per user.

* **lib/data/repositories/episode/i\_episode\_repository.dart**

  * Updated interface to `initialize(String userId)`.

* **lib/data/repositories/session/session\_repository.dart**

  * Removed `episodeId` constructor argument; added nullable `_episodeId` field.
  * Changed `initialize()` to `initialize(String episodeId)` with single-call guard.

* **lib/data/repositories/session/i\_session\_repository.dart**

  * Updated interface to `initialize(String episodeId)`.

* **lib/routing/router.dart**

  * Flattened route hierarchy by replacing `ShellRoute` sections with top-level `GoRoute` entries for Episodes, Sessions, and Attachments.
  * Injected repositories via `context.read<…>()` and unpacked `state.extra` maps directly in each route builder.
  * Removed legacy `repository_scope` imports and manual repository instantiations.

* **lib/ui/core/ui/buttons/icon\_back\_button.dart**

  * Added new `IconBackButton` widget for consistent back-navigation in AppBars.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Replaced manual back-button icon with `IconBackButton`, and invoked `viewModel.load.execute(sessionId)` in `initState`.

* **lib/ui/view/attachment/attachment\_view\_model.dart**

  * Changed `load` command from `Command0` to `Command1<void, String>` to pass the session ID.

* **lib/ui/view/episode/episode\_view\.dart**

  * Swapped manual back-icon for `IconBackButton`, triggered `viewModel.load.execute(userId)` in `initState`, and updated the AppBar title.
  * Adjusted delete listener placement to `initState`/`dispose`.

* **lib/ui/view/episode/episode\_view\_model.dart**

  * Converted `load` from `Command0` to `Command1<void, String>`.

* **lib/ui/view/session/session\_view\.dart**

  * Added `viewModel.load.execute(episodeId)` in `initState`, swapped manual back button for `IconBackButton`, and updated the AppBar title to "Consultas".
  * Adjusted `_navFormSessionView` to pass extra `episode` ID.

* **lib/ui/view/session/session\_view\_model.dart**

  * Changed `load` from `Command0` to `Command1<void, String>`.

### New Files

* **lib/ui/core/ui/buttons/icon\_back\_button.dart**
  Provides a reusable `IconBackButton` for consistent AppBar back navigation across views.

### Conclusion

Dependency injection and routing are now streamlined, form and view models support parameterized data loading, and navigation components are unified for a cleaner codebase.


## 2025/06/20 merge_and_bug_fix-01 - by rudsonalves

### Refine routing sections and streamline episode editing logic

These changes enhance the router definition by adding clear separation between route groups, improve the `EpisodeView` UI and navigation handlers, and optimize the episode form to use preformatted values and the `CurrencyEditingController`’s `currencyValue`.

### Modified Files

* **lib/routing/router.dart**

  * Inserted blank lines before each `ShellRoute` block for Episodes, Sessions, and Attachments to visually separate route groups.

* **lib/ui/view/episode/episode\_view\.dart**

  * Updated the subtitle to display weight in kilograms (`kg`) and height in meters (`m`).
  * Renamed `editAttachment`/`_removeAttachment` methods to `editEpisode`/`removeEpisode` and updated their handlers to push the `formEpisode` route with the correct `extra` map.
  * Added `delete` listener in `initState`/`dispose`, and integrated success/error snackbars for episode removal.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Pre-calculated formatted `weight` and `height` strings in `_initializeForm()` using `toStringAsFixed(2)` before setting controller text.
  * Revised `_saveForm()` to derive integer `weight` and `height` by multiplying `currencyValue` from the `CurrencyEditingController`.
  * Ensured focus is unfocused before save and consolidated parsing logic for clarity.

### Conclusion

Routing clarity, episode view consistency, and form value handling are now fully refined and functional.


## 2025/06/20 merge_and_bug_fix - by rudsonalves

### Update application ID, refactor table definitions, and enhance form controllers

This commit updates the Android application namespace and package path to `br.dev.rralves.prontu_ai`, refines local database table ordering, reverts vertical spacing to its original value, and introduces a new `CurrencyEditingController` for formatted numeric inputs. Forms across episodes, sessions, and attachments have been adjusted to leverage this controller, improve spacing, and wire up save/delete listeners for a smoother UX.

### Modified Files

* **android/app/build.gradle.kts**

  * Changed `namespace` and `applicationId` from `com.example.prontu_ai` to `br.dev.rralves.prontu_ai` to match project convention.

* **android/app/src/main/kotlin/.../MainActivity.kt**

  * Renamed package path and updated `package` declaration to `br.dev.rralves.prontu_ai` after directory relocation.

* **lib/data/repositories/episode/episode\_repository.dart**

  * Invoked `await fetchAll()` immediately after initialization to preload all episodes.

* **lib/data/services/database/tables/sql\_tables.dart**

  * Re-ordered the `sessions` table definition below `episodes` for consistency.

* **lib/ui/core/theme/dimens.dart**

  * Reverted `spacingVertical` from `24.0` back to `6.0` in `_DimensMobile` to restore original vertical gaps.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Added a blank line for readability before `ListView.builder`.
  * Updated `_navFormAttachmentView` to push `extra: {'session': widget.session}`.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart**

  * Introduced a `_formKey` and wrapped form in a `Form` widget.
  * Increased column spacing by multiplying `spacingVertical` by 3.
  * Removed unused `user`/`episode` imports and parameters.

* **lib/ui/view/episode/episode\_view\.dart**

  * Restructured imports and replaced `ListTile` with `DismissibleCard<EpisodeModel>`.
  * Added `delete` listener in `initState`/`dispose`, snackbars for removal outcomes, and renamed “Episódios” to “Eventos.”
  * Implemented `_navToSessionView` passing both `user` and `episode` in `extra`.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Swapped plain `TextFormField` controllers for `CurrencyEditingController` on weight and height.
  * Added validation helpers, prefix icons, and updated button section to use listeners on `viewModel.insert`/`update`.
  * Adjusted form spacing (`spacingVertical * 3`) and moved save logic into `_saveForm`.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\_model.dart**

  * Removed commented-out delay stubs and streamlined `insert`/`update` commands.

* **lib/utils/validates/generic\_validations.dart**

  * Introduced `isDouble` validator to enforce numeric input with optional decimal.

* **pubspec.yaml**

  * Added `intl: ^0.20.2` for number formatting support (currency controller).

### New Files

* **lib/ui/core/ui/editing\_controllers/currency\_editing\_controller.dart**
  Implements `CurrencyEditingController`, formatting input as localized currency without symbol, providing a `currencyValue` getter/setter and automatic mask application.

### Conclusion

Namespace alignment, database definitions, and UI spacing are restored, while the new currency controller and form enhancements deliver a consistent and validated input experience.


## 2025/06/19 ia_service-01 - by rudsonalves

### Implement masked input controller and refine session & attachment flows

This commit adds a reusable `MaskedEditingController` for formatted text input and enhances session and attachment views with consistent navigation, data handling, and validation. Route extras are repacked as maps, form initialization logic is improved, and session listings now support create, edit, and delete interactions. ViewModels are updated to expose insert/update/delete commands and session collections.

### Modified Files

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Updated `_editAttachment` to push both `session` and `attachment` in a map via `extra`.
  * Corrected import paths to use root-relative imports for domain models and UI components.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart**

  * Removed unused `user` and `episode` parameters from constructor.
  * Guarded `_initializeForm()` call to only run when `attachment` is non-null.
  * Streamlined form field population and `_isEditing` flag setup.

* **lib/ui/view/session/form\_session/form\_session\_view\.dart**

  * Switched from `Placeholder` to a full form scaffold with `BasicFormField`, `MaskedEditingController` for phone input, and `BigButton`.
  * Added `_formKey`, controllers for doctor, phone, and notes, and generic validation.
  * Implemented `initState`/`dispose` listeners for `insert` and `update` commands.
  * Defined `_initializeForm`, `_isSaved`, and `_saveForm` to handle edit vs. create flows, validation, and navigation.

* **lib/ui/view/session/form\_session/form\_session\_view\_model.dart**

  * Renamed `save` command to `insert` for clarity, matching repository API.

* **lib/ui/view/session/session\_view\.dart**

  * Imported routing, dialogs, theme, and extensions.
  * Re-enabled `delete` listener in `initState`/`dispose`.
  * Added floating action button to navigate to form, passing no extra.
  * Wrapped `body` in `ListenableBuilder` to show loading state, empty message, or `DismissibleCard` list.
  * Implemented `_editSession`, `_navFormSessionView`, `_isDeleted`, and `_removeSession` with confirmation dialog and snackbars.

* **lib/ui/view/session/session\_view\_model.dart**

  * Imported `SessionModel` and exposed `sessions` getter from the repository.

### New Files

* **lib/ui/core/ui/editing\_controllers/masked\_editing\_controller.dart**
  Provides `MaskedEditingController` to enforce input masks (e.g., phone numbers) by filtering digits and injecting mask characters automatically.

### Conclusion

All input masking and session/attachment workflows are now robustly implemented with clear form handling and navigation.


## 2025/06/19 ia_service - by rudsonalves

### Add OpenAI integration, dotenv support, and view refinements

This commit integrates an `OpenIaService` using `dart_openai` with environment-based API key loading via `flutter_dotenv`, refines session and attachment view imports and lifecycle methods, and updates dependency configuration and ignore rules to support secure key management.

### Modified Files

* **.gitignore**

  * Added `.env` to prevent local environment files from being committed.

* **pubspec.yaml**

  * Introduced `flutter_dotenv: ^5.2.1` and `dart_openai: ^5.1.0` under dependencies for secure configuration and AI model access.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Corrected import statements to use root-relative paths for `episode_model.dart` and `user_model.dart`.

* **lib/ui/view/session/session\_view\.dart**

  * Imported `Dimens` to access layout constants.
  * Moved `SessionViewModel` initialization into `initState` and disposed listeners in `dispose`.
  * Updated `AppBar` title formatting and added padding placeholder in `body`.

* **lib/ui/view/session/session\_view\_model.dart**

  * Added a `delete` command (`Command1<void, String>`) alongside the existing `load` command.

### New Files

* **lib/data/services/open\_ia/open\_ia\_service.dart**
  Defines `OpenIaService` to initialize the OpenAI client, load the API key from `.env`, list available models, and perform episode analysis prompts with concise technical responses.

* **lib/domain/dtos/episode\_analysis.dart**
  Declares `EpisodeAnalysis` DTO containing `recommendedSpecialist` and `clinicalSummary` fields to encapsulate AI-generated insights.


### Conclusion

All core AI service and configuration updates are complete, views are cleaned up, and secure environment handling is in place.


## 2025/06/19 routing-02 - by rudsonalves

### Add new tables to initialization, extend attachments schema, and increase vertical spacing

This commit enhances database setup by including sessions, episodes, attachments, and AI summaries tables in the batch creation, updates the attachments table to store a `name` field, and refines the mobile UI spacing by increasing the vertical gap. These changes ensure all core models persist locally and improve layout consistency.

### Modified Files

* **lib/data/services/database/database\_service.dart**

  * Added execution of `SqlTables.sessions`, `SqlTables.episodes`, `SqlTables.attachments`, and `SqlTables.aiSummaries` in the batch initialization to create these tables on startup.

* **lib/data/services/database/tables/sql\_tables.dart**

  * Introduced a required `name TEXT NOT NULL` column in the `attachments` table definition to store a human-readable identifier alongside `path` and `type`.

* **lib/ui/core/theme/dimens.dart**

  * Increased `spacingVertical` from `6.0` to `24.0` in the mobile dimensions class to provide more generous vertical padding across UI elements.


### Conclusion

All core tables are now initialized, the attachments schema is extended with names, and vertical spacing is improved—local persistence and UI layout are fully updated.


## 2025/06/19 database-01 - by rudsonalves

### Add new tables to initialization, extend attachments schema, and increase vertical spacing

This commit enhances database setup by including sessions, episodes, attachments, and AI summaries tables in the batch creation, updates the attachments table to store a `name` field, and refines the mobile UI spacing by increasing the vertical gap. These changes ensure all core models persist locally and improve layout consistency.

### Modified Files

* **lib/data/services/database/database\_service.dart**

  * Added execution of `SqlTables.sessions`, `SqlTables.episodes`, `SqlTables.attachments`, and `SqlTables.aiSummaries` in the batch initialization to create these tables on startup.

* **lib/data/services/database/tables/sql\_tables.dart**

  * Introduced a required `name TEXT NOT NULL` column in the `attachments` table definition to store a human-readable identifier alongside `path` and `type`.

* **lib/ui/core/theme/dimens.dart**

  * Increased `spacingVertical` from `6.0` to `24.0` in the mobile dimensions class to provide more generous vertical padding across UI elements.

### Conclusion

All core tables are now initialized, the attachments schema is extended with names, and vertical spacing is improved—local persistence and UI layout are fully updated.


## 2025/06/19 routing-01 - by rudsonalves

### Refactor GoRouter to use Map extras and remove legacy route bases

This commit standardizes route handling by unpacking `state.extra` as `Map<String, dynamic>` for all GoRouter navigations, ensuring explicit extraction of `UserModel` and `EpisodeModel`. Legacy `routes_base/*` files have been removed, and navigation methods have been updated to pass and receive structured route parameters consistently.

### Modified Files

* **lib/routing/router.dart**

  * Replaced direct casts of `state.extra` to model types with map unpacking (`final map = state.extra as Map<String, dynamic>`).
  * Extracted `user` and `episode` from the map for `EpisodeView`, `FormEpisodeView`, and other routes.
  * Simplified builder closures to read `user` once and pass it into view constructors.

* **lib/ui/view/episode/episode\_view\.dart**

  * Renamed `_navEpisodeView` to `_navFormEpisodeView` for clarity.
  * Updated `context.push` to include `extra: {'user': widget.user}` when navigating to the form.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Changed constructor parameter from `String userId` to `UserModel user`.
  * Added import of `user_model.dart` and updated all references to use `widget.user.id`.

* **lib/ui/view/home/home\_view\.dart**

  * Modified `_navToEpisode` to push `extra: {'user': user}` instead of raw model.
  * Corrected `_navFormUserView` to navigate to `Routes.formUser.path` instead of `formEpisode`.

* **Deleted legacy route files**

  * Removed `lib/routing/routes_base/attachment_routes.dart`, `episodes_routes.dart`, and `sessions_routes.dart` to eliminate duplicated route definitions.

### Conclusion

All route definitions now use structured maps for parameters, and legacy base files have been cleaned up — navigation flows remain fully functional.


## 2025/06/19 attachments-02 - by rudsonalves

### Add file picker support and extend attachment/session route parameters

This commit enhances attachment handling by introducing a `name` field to the `AttachmentModel`, integrates the `file_picker` package for file selection, and refactors routing to pass additional identifiers (`userId`, `episodeId`, `sessionId`). Validation and UI elements have been updated accordingly to improve the form interaction and maintain consistency across views.

### Modified Files

* **lib/domain/models/attachment\_model.dart**

  * Introduced a new `name` property and required it in the constructor.
  * Made `createdAt` optional with a default of `DateTime.now()`.
  * Updated `copyWith`, `toMap`, and `fromMap` methods to include `name`.

* **lib/routing/router.dart**

  * Refactored `formEpisode`, `formSession`, and `formAttachment` routes to read `state.extra` as a `Map<String, dynamic>`.
  * Extracted and passed `userId`, `episodeId`, and `sessionId` to their respective views.
  * Simplified builder signatures and removed old `state.extra as Model` casts.

* **lib/routing/routes\_base/attachment\_routes.dart**

  * Mirrored the router changes: now unpacks `sessionId` and optional `attachment` from `state.extra`.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Corrected import paths to use root-relative (`/routing` and `/ui/core`) instead of package prefixes.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart**

  * Added `file_picker` import and declared a required `sessionId` parameter on `FormAttachmentView`.
  * Replaced plain button with `BigButton` and wrapped the file path field in an `InkWell` to trigger `_selectFile()`.
  * Inserted an `EnumFormField` for selecting `AttachmentType`.
  * Implemented `_initializeForm()`, `_isSaved()`, and `_saveForm()` methods to handle edit/save logic and error reporting.
  * Integrated `FilePicker` to allow users to choose files with specific extensions.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Added a required `userId` field to the `FormEpisodeView` constructor.

* **lib/ui/view/home/form\_user/form\_user\_view\.dart**

  * Made the `SnackBar` constant and removed the inline error interpolation for consistency.

* **lib/ui/view/session/form\_session/form\_session\_view\.dart**

  * Changed `session` to be nullable and introduced a required `episodeId` parameter.

* **lib/utils/validates/generic\_validations.dart**

  * Added a new `attachmentType` validator to ensure a file type is selected.

* **pubspec.yaml**

  * Added `file_picker: ^10.2.0` to dependencies for file selection functionality.

### Conclusion

### All changes complete – attachment forms now support naming and file selection, and routing carries the correct identifiers.


## 2025/06/19 attachments-01 - by rudsonalves

### Implement Attachment feature and refine routing, forms, and validations

This commit adds full support for managing attachments within the app—including list, create, edit, and delete flows—while also tightening up routing and form behavior for episodes and users. Validations are extended, UI padding and spacing now use the shared `Dimens`, and error messaging is standardized across views.

### Modified Files

* **lib/routing/router.dart**

  * Changed `FormEpisodeView`’s `episode` parameter to be nullable, preventing downstream cast errors when no `EpisodeModel` is provided.

* **lib/ui/view/attachment/attachment\_view\.dart**

  * Imported routing, theming, dialogs, and dismissible card utilities.
  * Initialized and disposed `delete` listener on `AttachmentViewModel`.
  * Added FAB to navigate to the attachment form.
  * Wrapped body in a `ListenableBuilder` to show loading state, empty placeholder, or a `ListView` of `DismissibleCard`s.
  * Implemented `_isDeleted()`, `_navFormAttachmentView()`, `_editAttachment()`, and `_removeAttachment()` methods for delete confirmation and navigation.

* **lib/ui/view/attachment/attachment\_view\_model.dart**

  * Imported `AttachmentModel`.
  * Added `delete` `Command1` for removal operations.
  * Exposed `attachments` getter from repository.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart**

  * Replaced placeholder with a `Scaffold` containing a form.
  * Added text controllers, init/dispose listeners for `insert` and `update` commands.
  * Built form fields for name and file path, using `BasicFormField` and generic validations.

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\_model.dart**

  * Renamed `save` command to `insert` to clarify its purpose.

* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart**

  * Made `episode` parameter nullable to match router change.

* **lib/ui/view/home/form\_user/form\_user\_view\.dart**

  * Imported `Dimens` and applied consistent padding and spacing.
  * Disposed `_nameController` and `_dateController` properly.
  * Removed custom `OutlineInputBorder` in favor of default styling.

* **lib/ui/view/home/home\_view\.dart**

  * Cleaned up commented-out removal dialog code.
  * Standardized error snack messages and removed redundant `return`.

* **lib/utils/validates/generic\_validations.dart**

  * Introduced `notEmpty` validator to enforce non-empty strings of minimum length.

### Conclusion

All changes are complete and the attachment workflow, form refinements, and routing updates are now functional.


## 2025/06/19 messages_and_dialogs - by rudsonalves

### Add global snackbars, bottom-sheet dialogs, and rich-text support

This commit introduces a set of reusable UI utilities for displaying feedback and prompts throughout the app: a global snackbar component (`AppSnackBar`), a versatile bottom-sheet confirmation dialog (`BottonSheetMessage`), a simple alert dialog wrapper (`showSimpleMessage`), and a rich-text parser for markdown-style formatting. The HomeView has been updated to leverage these new components for user removal confirmation and feedback.

### Modified Files

* **lib/ui/view/home/home\_view\.dart**

  * imported `BottonSheetMessage`, `ButtonSignature`, `showSnackError` / `showSnackSuccess`, and `Sex` enum
  * refactored `_removeUser` to present a bottom-sheet confirmation with gender-aware copy and replaced direct `ScaffoldMessenger` calls with `showSnackError` / `showSnackSuccess`
  * ensured the removal flow respects the user’s choice before invoking the deletion command

### New Files

* **lib/ui/core/ui/dialogs/app\_snack\_bar.dart**
  Provides `showSnackError` / `showSnackSuccess` wrappers and a configurable `AppSnackBar` for error/success feedback with custom icons and durations.

* **lib/ui/core/ui/dialogs/botton\_sheet\_message.dart.dart**
  Defines `BottonSheetMessage` and `ButtonSignature` to display a modal bottom sheet with rich-text body, platform-adaptive button styles, and return values.

* **lib/ui/core/ui/dialogs/simple\_dialog.dart**
  Implements `showSimpleMessage`, a lightweight `AlertDialog` wrapper that accepts rich-text bodies and custom action buttons.

* **lib/ui/core/ui/texts/parse\_rich\_text.dart**
  Introduces `parseRichText` to convert `*italic*`, `**bold**`, and line-prefix icons (`-`, `>`, `<`) into a Flutter `RichText` or icon-prefixed row.

### Conclusion

These enhancements centralize user feedback and confirmation flows, ensure consistent styling, and enable rich-text formatting across dialogs and snackbars.


## 2025/06/18 small_adjustments - by rudsonalves

### Refactor Enums, Route Naming, and Validation Identifiers

This commit streamlines enum declarations, unifies route naming for the user form, and renames the Brazilian date validator for clarity. It also corrects import paths for extensions and updates navigation calls in the home view to reflect the new `formUser` route identifier.

### Modified Files

* **docs/Diagrama de Classes.drawio**

  * refreshed file index to reflect the latest Draw\.io export (no structural changes)

* **lib/domain/enums/enums\_declarations.dart**

  * commented out unused `EnumLabel` interface
  * retained `Sex` enum without interface implementation annotations
  * added `AttachmentType` enum with label semantics

* **lib/domain/models/attachment\_model.dart**

  * removed inline `AttachmentType` definition and imported it from `enums_declarations.dart`

* **lib/routing/router.dart**

  * updated the user-form route to use `Routes.formUser` (renamed constant)
  * adjusted `GoRoute` entry for the form-user screen to match the new path and name

* **lib/routing/routes.dart**

  * renamed `user` → `formUser` constant for consistency with other form routes

* **lib/ui/view/home/home\_view\.dart**

  * renamed `_navUserView` → `_navFormUserView` and updated its call site on the FAB
  * changed navigation pushes from `Routes.user` → `Routes.formUser`
  * updated the edit handler to push the `formUser` path

* **lib/ui/view/home/form\_user/form\_user\_view\.dart**

  * updated validator reference from `GenericValidations.brBirthDate` → `GenericValidations.brDate`

* **lib/utils/extensions/string\_extentions.dart**

  * corrected absolute import path to `date_time_extensions.dart` using the project root prefix

* **lib/utils/validates/generic\_validations.dart**

  * renamed static method `brBirthDate` → `brDate` for broader applicability
  * cleaned up import paths to use root-prefixed syntax

### Conclusion

Enum management is now consolidated, route identifiers for user forms are consistent, and validation naming has been clarified—improving overall code readability and maintainability.


## 2025/06/18 route_view_files-01 - by rudsonalves

### Support Scoped Repositories with Filtering and Shell Routes

This commit refactors dependency provisioning to use scoped repositories per feature, adds record-level filtering to `fetchAll`, and restructures routing with nested `ShellRoute` wrappers. Database table column constants are grouped into `Table*` classes for stronger typing. UI layout tweaks ensure consistent spacing, and view/view-model pairs now execute an initial load command.

### Modified Files

* **lib/config/composition\_root.dart**

  * switched `Provider<DatabaseService>` to reuse the single initialized `database` instance instead of creating a new one

* **lib/data/repositories/attachment/attachment\_repository.dart**

  * injected `sessionId` in constructor; imported `TableAttachments.sessionId`;
  * applied `filter: { session_id: _sessionId }` to `fetchAll` calls for scoped attachment lists

* **lib/data/repositories/episode/episode\_repository.dart**

  * injected `userId` in constructor; imported `TableEpisodes.userId`;
  * applied `filter: { user_id: _userId }` to `fetchAll` for user-specific episodes

* **lib/data/repositories/session/session\_repository.dart**

  * injected `episodeId` in constructor; imported `TableSessions.episodeId`;
  * applied `filter: { episode_id: _episodeId }` to `fetchAll` for session-specific lists

* **lib/data/services/database/database\_service.dart**

  * added optional `filter` parameter to `fetchAll`; builds `WHERE` clause dynamically when provided

* **lib/data/services/database/tables/sql\_tables.dart**

  * defined new classes `TableSessions`, `TableEpisodes`, `TableAttachments`, `TableAiSummaries`, and `TableUsers` with static column names;

* **lib/routing/router.dart**

  * replaced flat `GoRoute` definitions with nested `ShellRoute` wrappers that create and provide scoped repositories (`EpisodeRepository`, `SessionRepository`, `AttachmentRepository`) via a new `RepositoryScope` inherited widget;
  * updated route builders to retrieve the scoped repository and inject into corresponding view-models;

* **lib/routing/routes\_base/attachment\_routes.dart**, **episodes\_routes.dart**, **sessions\_routes.dart**

  * factored out route definitions for attachments, episodes, and sessions into their own lists for modular imports

* **lib/routing/utils/repository\_scope.dart**

  * introduced `RepositoryScope<T>` inherited widget for passing repository instances down the widget tree

* **lib/ui/core/theme/dimens.dart**

  * adjusted `spacingVertical` for mobile to `6.0` for more compact lists

* **lib/ui/core/ui/dismissibles/dismissible\_card.dart**

  * wrapped each `Dismissible` in a bottom padding using `Dimens.spacingVertical * 2` and removed default card margin for tighter grouping

* **lib/ui/view/ai\_summary/ai\_summary\_view\_model.dart**

  * injected `IAiSummaryRepository` and triggered `initialize()` via `Command0<void> load`

* **lib/ui/view/attachment/attachment\_view\.dart** & **attachment\_view\_model.dart**

  * updated to accept a full `SessionModel`, show a `Scaffold` with session context in the `AppBar`, and execute `load` command on init

* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\_model.dart**

  * injected `IAttachmentRepository` and exposed `save`/`update` commands

* **lib/ui/view/episode/episode\_view\.dart** & **episode\_view\_model.dart**

  * updated to accept `UserModel`, display user name in `AppBar`, and execute `load` command

* **lib/ui/view/episode/form\_episode/form\_episode\_view\_model.dart**

  * injected `IEpisodeRepository` and exposed `save`/`update` commands

* **lib/ui/view/home/home\_view\.dart**

  * restored full `paddingScreenAll` on body padding; changed `_navToEpisode` to pass a `UserModel` extra instead of ID

* **lib/ui/view/home/home\_view\_model.dart**

  * cleaned import order and kept existing logic

* **lib/ui/view/session/form\_session/form\_session\_view\_model.dart**

  * injected `ISessionRepository` and exposed `save`/`update` commands

* **lib/ui/view/session/session\_view\.dart** & **session\_view\_model.dart**

  * updated to accept `EpisodeModel`, display episode title in `AppBar`, and execute `load` command

### Conclusion

Routing, data access, and UI flows are now fully scoped per feature, ensuring repository instances are correctly provisioned with context-specific filters. The new `RepositoryScope` and `ShellRoute` patterns establish a robust foundation for modular feature development.


## 2025/06/18 route_view_files - by rudsonalves

### Extend App Routing with Episode, Session, Attachment and AI Summary

This commit enhances the navigation layer by adding routes for episodes, sessions, attachments, and AI summaries. Corresponding view and view-model placeholders are introduced to scaffold each feature. The home view’s episode navigation call is updated to use the new router paths, ensuring end-to-end flow readiness.

### Modified Files

* **lib/routing/router.dart**

  * imported domain models (`EpisodeModel`, `SessionModel`, `AttachmentModel`) and their view/view-model widgets
  * added `GoRoute` entries for `episode`, `formEpisode`, `session`, `formSession`, `attachment`, `formAttachment`, and `aiSummary`
* **lib/routing/routes.dart**

  * renamed `user` route to `form_user`
  * added constants for `episode`, `formEpisode`, `attachment`, `formAttachment`, `session`, `formSession`, and `aiSummary`
* **lib/ui/view/home/home\_view\.dart**

  * updated `_navToEpisode` to push `Routes.episode.path` with the selected user’s ID

### New Files

* **lib/ui/view/ai\_summary/ai\_summary\_view\.dart** & **ai\_summary\_view\_model.dart**
  placeholder screen and view-model for AI summary feature
* **lib/ui/view/attachment/attachment\_view\.dart** & **attachment\_view\_model.dart**
  placeholder screen and view-model for listing attachments
* **lib/ui/view/attachment/form\_attachment/form\_attachment\_view\.dart** & **form\_attachment\_view\_model.dart**
  placeholder form screen and view-model for creating/editing an attachment
* **lib/ui/view/episode/episode\_view\.dart** & **episode\_view\_model.dart**
  placeholder for listing or displaying episodes
* **lib/ui/view/episode/form\_episode/form\_episode\_view\.dart** & **form\_episode\_view\_model.dart**
  placeholder form for creating/editing an episode
* **lib/ui/view/session/session\_view\.dart** & **session\_view\_model.dart**
  placeholder for listing or displaying sessions
* **lib/ui/view/session/form\_session/form\_session\_view\.dart** & **form\_session\_view\_model.dart**
  placeholder form for creating/editing a session

### Conclusion

Routing now supports all core entities—episodes, sessions, attachments, and AI summaries—with scaffolded view modules ready for feature implementation.


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