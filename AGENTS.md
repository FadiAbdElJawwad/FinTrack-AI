# AGENTS.md — FinTrack AI

Portfolio-grade Flutter finance tracker. Quality metric = architectural clarity, explainable in a job interview.

## Stack
- Flutter + Dart, Clean Architecture, **feature-first**.
- State: Riverpod (`StreamNotifier`, `AsyncNotifier`) + `flutter_hooks` (`HookConsumerWidget`).
- Models: Freezed. Every Freezed class MUST keep the private constructor `const ClassName._();`.
- Routing: GoRouter, isolated in its own layer.
- Backend: Firebase **Spark plan only**.

<!-- TODO(Fadi): verify this matches the real tree before first run -->
## Layout
- `lib/core/` — shared: `widgets/`, theme/tokens, services.
- `lib/features/<feature>/domain|data|presentation/`

## Dependency rules (hard)
- Domain → nothing. **No `package:flutter/*` imports in domain**, no Firebase imports.
- Data → Domain only. Presentation → Domain (+ DI wiring).
- Firestore types (`DocumentSnapshot`, `Timestamp`) never leave the Data layer; map to domain entities.

## Riverpod rules
- After every `await` inside a Notifier: `if (!ref.mounted) return;`
- Real-time Firestore data → `StreamNotifier`. No `setState`, no `StatefulWidget` for business state.
- Optimistic updates must roll back on failure.

## UI rules
- **Reuse before create:** search `lib/core/widgets/` before creating any widget. If a match exists, extend it.
- No hardcoded `Color(0xFF...)`, no literal `EdgeInsets.all(16)`. Use `context.tokens` / `Theme.of(context)`.
- Network images: always set `cacheWidth` / `cacheHeight`.

## Firebase Spark constraints
- Forbidden: Cloud Functions, Cloud Storage, Firebase AI Logic, anything requiring Blaze.
- Substitutes: file storage → Google Drive API; server logic → Google Apps Script HTTP endpoint.
- Daily quota: 50k reads / 20k writes / 20k deletes. Avoid unbounded listeners; always `limit()` queries; no N+1 reads.

## Security
- Secrets are injected via `--dart-define` only. Never create `.env` files.
- Never read, print, or modify: `google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart` secrets, any keystore, any file containing API keys or the Apps Script URL.

## Workflow (mandatory loop)
1. Plan first: list files to touch, then wait for approval if >5 files or any Domain contract change.
2. Use the Dart MCP server for analysis, symbol lookup, tests, pub.
3. After Freezed/Riverpod-generator edits: `dart run build_runner build --delete-conflicting-outputs`.
4. Finish only when `dart analyze` reports zero issues and `flutter test` passes.

## Forbidden without explicit approval
- Adding/removing/upgrading packages in `pubspec.yaml`.
- Editing files outside the scope stated in the task prompt.
- `git push`, `firebase deploy`, deleting files.

## Output
- Summary: files changed + why, analyzer result, test result, open risks.
