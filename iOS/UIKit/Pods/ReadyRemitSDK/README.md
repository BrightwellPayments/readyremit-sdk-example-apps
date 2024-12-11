
# Adding ReadyRemitSDK via Swift Package Manager and CocoaPods

## Information

- **URL**: [https://github.com/BrightwellPayments/readyremit-sdk-ios](https://github.com/BrightwellPayments/readyremit-sdk-ios)
- **Minimum iOS Version**: 16.0

---

## Step-by-Step Guide

### Using Swift Package Manager (SPM)

#### Method 1: Modifying the `Package.swift`

##### **Step 1: Modify the `Package.swift` File**

1. Open the `Package.swift` file in your preferred text editor.
2. Modify the file to include the ReadyRemitSDK dependency:

   ```swift
   // swift-tools-version:5.3
   import PackageDescription

   let package = Package(
       name: "MySwiftProject",
       platforms: [
           .iOS(.v16)
       ],
       dependencies: [
           .package(
               url: "https://github.com/BrightwellPayments/readyremit-sdk-ios",
               .branch("9.0")
           )
       ],
       targets: [
           .target(
               name: "MySwiftProject",
               dependencies: [
                   .product(name: "ReadyRemitSDK", package: "readyremit-sdk-ios")
               ]
           ),
           .testTarget(
               name: "MySwiftProjectTests",
               dependencies: ["MySwiftProject"]
           ),
       ]
   )
   ```

##### **Step 2: Resolve Dependencies**

1. In Terminal, navigate to your project directory if you aren't already there:

   ```bash
   cd MySwiftProject
   ```

2. Resolve the dependencies by running:

   ```bash
   swift package update
   ```

#### Method 2: Using Xcode

##### **Step 1: Open Your Project in Xcode**

1. Launch Xcode.
2. Open your existing project or create a new one.

##### **Step 2: Add Swift Package Dependency**

1. In Xcode's top menu, go to `File > Add Packages...`.
2. In the dialog that appears, enter the URL of the repository in the search bar:

   ```
   https://github.com/BrightwellPayments/readyremit-sdk-ios
   ```

##### **Step 3: Specify Version**

1. Choose the dependency rule:
    - Select `Branch` from the options.
    - Enter `9.0` as the branch name.
2. Click `Add Package`.

##### **Step 4: Add the Package to Your Targets**

1. Xcode will ask you to confirm which targets to add the package to. Make sure the correct targets are selected (usually your main app target).
2. Click `Add Package`.

---

### Using CocoaPods

#### **Step 1: Install CocoaPods (If Not Already Installed)**

1. Open Terminal.
2. Run the following command to install CocoaPods:

   ```bash
   sudo gem install cocoapods
   ```

#### **Step 2: Create a Podfile**

1. In Terminal, navigate to the root directory of your Xcode project:

   ```bash
   cd MySwiftProject
   ```

2. Create a Podfile by running:

   ```bash
   pod init
   ```

#### **Step 3: Edit the Podfile**

1. Open the `Podfile` in a text editor.
2. Add the following line, replacing `9.0` with the desired version of the SDK:

   ```ruby
   pod 'ReadyRemitSDK', :git => 'https://github.com/BrightwellPayments/readyremit-sdk-ios.git', :branch => '9.0'
   ```

3. Your `Podfile` should look like this:

   ```ruby
   platform :ios, '16.0'
   use_frameworks!

   target 'MySwiftProject' do
     pod 'ReadyRemitSDK', :git => 'https://github.com/BrightwellPayments/readyremit-sdk-ios.git', :branch => '9.0'
   end
   ```

#### **Step 4: Install the Pod**

1. In Terminal, run:

   ```bash
   pod install
   ```

2. CocoaPods will download the ReadyRemitSDK and its dependencies.

#### **Step 5: Open the Workspace**

1. After installation, open the generated `.xcworkspace` file:

   ```bash
   open MySwiftProject.xcworkspace
   ```

**Note**: Always use the `.xcworkspace` file from now on to work on your project.

---

## Next Steps

You can see how to configure ReadyRemitSDK in our [documentation](https://developer.readyremit.com/docs/ios).

---

**Notes:**

- Replace `9.0` with the actual version number you wish to use.
- Ensure that all URLs point to the correct locations in the GitHub repository.
- Always test the integration thoroughly in your development environment.
