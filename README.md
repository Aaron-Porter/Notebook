# NotebookAI (iOS)

A SwiftUI iOS notes app that stores notes locally on your filesystem and includes a built-in AI-style agent command bar with full control over note CRUD operations.

## Features
- Local filesystem persistence (`Documents/NotebookAI/notes.json`).
- Add notes manually in the UI.
- Agent commands for full control:
  - `create title: <title> | content: <content>`
  - `update <note-id> title: <title> | content: <content>`
  - `delete <note-id>`
  - `summarize`
  - `clear all`
- Agent activity log shown in app.

## Build and test (core logic)
```bash
swift test
```

## Build and test on iPhone/iPad device

### Prerequisites
- macOS with Xcode 15+.
- Apple ID added in Xcode (`Xcode > Settings > Accounts`).
- iOS device in Developer Mode and trusted by your Mac.

### 1) Open as a Swift Package in Xcode
```bash
open Package.swift
```
Xcode will load the package and create schemes.

### 2) Configure signing for device builds
1. In Xcode, select the `NotebookAIApp` scheme.
2. Set destination to your connected iPhone/iPad.
3. In **Signing & Capabilities**:
   - Set a unique bundle identifier (for example `com.yourname.NotebookAI`).
   - Select your Team.
   - Keep `Automatically manage signing` enabled.

### 3) Run on device
- Press **Run** in Xcode.
- The first run may require confirming trust prompts on the device.

### Optional: CLI build for a connected device
Use this once signing is configured in Xcode:
```bash
xcodebuild \
  -scheme NotebookAIApp \
  -destination 'generic/platform=iOS' \
  -configuration Debug \
  build
```

## Notes about local storage
- Notes are persisted to app sandbox documents under `NotebookAI/notes.json`.
- On device, inspect with Xcode: **Window > Devices and Simulators > [Your Device] > Installed Apps > Download Container**.
