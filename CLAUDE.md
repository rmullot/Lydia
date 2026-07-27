# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

An iOS app (`Test_Lydia`, scheme `Test_Lydia`) that lists random users (from the `randomuser.me`-style API) and shows a detail screen per user, with offline caching via Core Data. All project files live under `Romain_Mullot_lydia/`.

## Build / run / test

Open `Romain_Mullot_lydia/Romain_Mullot_Lydia.xcworkspace` in Xcode (not the `.xcodeproj` directly — the workspace is what ties the app project together with the local Swift packages).

Command-line build/test (from `Romain_Mullot_lydia/`):
```sh
xcodebuild -workspace Romain_Mullot_Lydia.xcworkspace -scheme Test_Lydia \
  -destination 'platform=iOS Simulator,name=<an available iPhone>' clean build

xcodebuild -workspace Romain_Mullot_Lydia.xcworkspace -scheme Test_Lydia \
  -destination 'platform=iOS Simulator,name=<an available iPhone>' test
```
List available simulators with `xcrun simctl list devices available | grep -i iphone`.

Per-module unit tests exist under each package too (e.g. `LydiaCore/LydiaCore/LydiaCoreTests`) — run the full app test target (`Test_LydiaTests`, `Test_LydiaUITests`) via the `test` action above; there's no separate `swift test` workflow since these packages target iOS/UIKit/CoreData, not macOS.

There is no CocoaPods in this project — it was fully migrated off CocoaPods to SPM. Don't reintroduce a `Podfile`.

## Architecture

The app is split into **one local Swift Package per module**, each with its own `Package.swift` at the module root (e.g. `LydiaAPI/Package.swift`), wired into `Test_Lydia.xcodeproj` as local package dependencies. This is a deliberate one-package-per-framework structure (not a single umbrella package) — when adding new modules or dependencies, preserve that separation rather than merging targets.

Dependency graph (arrows = "depends on"):
```
LydiaCore     (no internal deps — formatting, DI container, extensions)
LydiaNetwork  (no internal deps — reachability, network activity, cancellable dispatch)
LydiaUIKit    (no internal deps — UIKit view/layer extensions, custom nav controller)

LydiaAPI      -> LydiaCore, LydiaNetwork, SwiftMessages (remote)
LydiaCoreData -> LydiaAPI
LydiaBridge   -> LydiaAPI, LydiaCoreData

Test_Lydia (app) -> all six packages + Kingfisher (remote)
```
- **LydiaCore**: cross-cutting utilities — `InjectionMapService` (the app's IoC/service-locator container, via `.register`/`.resolve`), date/string/collection extensions, `FormatterService`.
- **LydiaNetwork**: reachability and network-activity plumbing, independent of any specific API.
- **LydiaAPI**: talks to the remote API (`APIService`, `ParserService`), JSON DTOs (`*JSON.swift`), and owns the SwiftMessages-based error/toast UI. Has localized strings (`Resources/en.lproj`, `fr.lproj`, generated `Strings.swift`).
- **LydiaCoreData**: Core Data persistence layer (`CoreDataService`, `*CoreData+CoreDataClass/Properties`), the local cache/mirror of API models. Depends on LydiaAPI for the domain types it persists.
- **LydiaBridge**: the app-facing domain layer — `User`/`Location` domain models and `UserService`, which is what view models actually call. Combines the network (LydiaAPI) and persistence (LydiaCoreData) layers behind one API.
- **LydiaUIKit**: shared, app-agnostic UIKit components (custom scroll/nav controllers, shadow/table-view helpers) with no dependency on the domain layers.
- **Test_Lydia** (app target): Coordinator pattern (`Coordinator` protocol, `ApplicationCoordinator`, `UserDescriptionCoordinator`) driving navigation between `UsersListViewController` and `UserDescriptionViewController`, each with its own ViewModel. View models talk to `UserService` (LydiaBridge), not directly to LydiaAPI/LydiaCoreData.

When changing a module, check both directions of the dependency graph above: what it depends on, and what depends on it (e.g. a change to `LydiaAPI`'s public API can ripple into `LydiaCoreData`, `LydiaBridge`, and the app).

## Tooling

- **SwiftGen** (`swiftgen.yml` at the workspace root) generates `LydiaAPI/Resources/Strings.swift` from `LydiaAPI/Resources/en.lproj/Localizable.strings`. Edit the `.strings` file and regenerate rather than hand-editing `Strings.swift`; it's currently invoked manually (`swiftgen`), not yet wired as a build phase/plugin.
- **SwiftLint** runs as an SPM build-tool plugin (`SwiftLintBuildToolPlugin`) on the `Test_Lydia` target, configured via `.swiftlint.yml` at the workspace root — `force_cast`, `line_length`, and `notification_center_detachment` are disabled; `empty_count` is opt-in. Note: third-party SPM plugins need a one-time "Trust & Enable" approval in Xcode.app before they run; until approved they're silently skipped, including in headless `xcodebuild`.
- Deployment target across the app and every package is **iOS 15**.

## Known benign console warnings

These appear in the console but are not caused by app code and don't need fixing:
- `Failed to locate resource named "default.csv"`, `CAMetalLayer ignoring invalid setDrawableSize width=0.000000 height=0.000000`, `clip: empty path.` — logged by MapKit/Metal when `MKMapView` (in `UserDescriptionViewController`) is first inserted into the view hierarchy, before Auto Layout resolves its frame. Transient, harmless.
- `Class UIAccessibilityLoaderWebShared is implemented in both ... WebCore.axbundle ... and ... WebKit.axbundle` — a duplicate-class conflict inside the iOS Simulator runtime's own accessibility bundles (seen on iOS 26.5 simulator), unrelated to this project. Try a different simulator runtime if it ever causes real crashes rather than just a log line.
