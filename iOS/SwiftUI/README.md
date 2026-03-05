# ReadyRemit Host

A sample iOS application demonstrating how to integrate the ReadyRemit SDK using different presentation patterns.

## Overview

This app serves as a reference implementation for integrating the ReadyRemit SDK into an iOS application. It demonstrates three integration approaches:

| Integration | Description |
|-------------|-------------|
| **SwiftUI - Sheet** | Present the SDK as a SwiftUI full-screen cover |
| **UIKit - Present** | Present the SDK modally from a UIKit view controller |
| **UIKit - Push** | Push the SDK onto a UIKit navigation stack |

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ReadyRemitHost
   ```

2. **Open in Xcode**
   ```bash
   open ReadyRemitHost.xcodeproj
   ```

3. **Resolve Swift Packages**
   
   Xcode will automatically resolve the ReadyRemit SDK dependency. If not, go to:
   `File > Packages > Resolve Package Versions`

4. **Configure credentials**
   
   Update the sandbox credentials in `ViewModel.swift` with your own:
   ```swift
   "client_id": "your_client_id",
   "client_secret": "your_client_secret",
   "sender_id": "your_sender_id"
   ```

5. **Build and run**

## Project Structure

```
ReadyRemitHost/
├── ReadyRemitHostApp.swift       # App entry point
├── ContentView.swift             # Main navigation view
├── ContentView-ViewModel.swift   # Navigation state management
├── ViewModel.swift               # SDK integration logic
├── SwiftUISheetView.swift        # SwiftUI sheet integration example
├── UIKitPresent.swift            # UIKit modal presentation example
├── UIKitPresentViewController.swift
├── UIKitPush.swift               # UIKit push navigation example
├── UIKitPushViewController.swift
├── CreateOAuthTokenResponse.swift    # API response models
├── CreateTransferResponse.swift
└── ReadQuoteDetailsResponse.swift
```

## SDK Integration

### Starting the SDK

```swift
import ReadyRemitSDK

ReadyRemit.shared.startSDK(
    configuration: .init(environment: .sandbox),
    fetchAccessTokenDetails: fetchAccessTokenDetails,
    verifyFundsAndCreateTransfer: verifyFundsAndCreateTransfer,
    onDismiss: {
        // Handle SDK dismissal
    }
) { readyRemitSDKView in
    // Present the SDK view
}
```

### Required Callbacks

#### 1. Fetch Access Token
```swift
func fetchAccessTokenDetails() async throws -> AccessTokenDetails {
    // Call your backend to get OAuth token
    // Return response conforming to AccessTokenDetails
}
```

#### 2. Verify Funds and Create Transfer
```swift
func verifyFundsAndCreateTransfer(
    transferRequest: TransferRequest
) async throws(ReadyRemitError) -> TransferDetails {
    // Verify funds availability
    // Create the transfer via API
    // Return response conforming to TransferDetails
}
```

## Integration Examples

### SwiftUI (Recommended)

```swift
struct MyView: View {
    @State private var sdkView: AnyView?
    
    var body: some View {
        Button("Start Transfer") {
            ReadyRemit.shared.startSDK(...) { view in
                sdkView = AnyView(view)
            }
        }
        .fullScreenCover(item: $sdkView) { view in
            view
        }
    }
}
```

### UIKit - Present

```swift
class MyViewController: UIViewController {
    func startSDK() {
        ReadyRemit.shared.startSDK(...) { [weak self] view in
            let hostingController = UIHostingController(rootView: view)
            hostingController.modalPresentationStyle = .fullScreen
            self?.present(hostingController, animated: true)
        }
    }
}
```

### UIKit - Push

```swift
class MyViewController: UIViewController {
    func startSDK() {
        ReadyRemit.shared.startSDK(...) { [weak self] view in
            let hostingController = UIHostingController(rootView: view)
            self?.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}
```

## Environment

The app is configured to use the **sandbox** environment by default:

```swift
configuration: .init(environment: .sandbox)
```

For production, change to:

```swift
configuration: .init(environment: .production)
```

## License

Copyright © 2025 Brightwell. All rights reserved.
