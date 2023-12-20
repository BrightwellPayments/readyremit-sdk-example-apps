# Scan Forensics Plus Release Notes v1.9.4

# How to use CocoaPods
* In order to use the ScanForensics SDK with your cocoa pods implementation, please refer to the **Podfile** in the sample project.
* You will need 2 files in order to make ```pod install``` work properly.
  * ```ScanForensicsPlus.podspec``` and ```Frameworks/ScanForensicsPlus.xcframework```
* You will need to copy and paste all the xcframeworks in the Frameworks folder to your projects Framework folder
* If you copy the ScanForensicsPlus.xcframework to a different location you will need to update this location in the podspec file
* In order to get all the dependencies of subprojects used in the ScanForensicsPlus.xcframework your ending podfile should look like this: 

```
target 'MyiOSProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  # Pods for MyiOSProject
  use_frameworks!

  pod 'ScanForensicsPlus', :path => '.'

  pod 'AcuantiOSSDKV11/AcuantCamera', '11.6.2'

  pod 'AcuantiOSSDKV11/AcuantFaceCapture', '11.6.2'

  pod 'AcuantiOSSDKV11/AcuantCommon', '11.6.2'

  pod 'AcuantiOSSDKV11/AcuantImagePreparation', '11.6.2'

  pod 'AcuantiOSSDKV11/AcuantPassiveLiveness', '11.6.2'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if ['AcuantiOSSDKV11', 'Socket.IO-Client-Swift', 'Starscream'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
      end
    end
  end
end
```

# How to integrate without CocoaPods
* Request the manual XCFrameworks in order to integrate without cocoapods
* Copy and paste the following required frameworks into your project directory
`AcuantCamera, AcuantFaceCapture, AcuantCommon, AcuantImagePreparation, AcuantPassiveLiveness, libtesseract, ScanForensicsPlus`

### If you are building for an app
* Add these xcframeworks to your targets `Frameworks, Libraries, and Embedded Content` section in the General tab.
* Make sure all the frameworks are marked to be embedded and signed

### Follow the same process for adding to your own SDK
* Only this time mark these frameworks with "do not embed"

## Localization
- To use localization please override the following strings in your localization.strings file,
```
/* AcuantCamera */
"acuant_camera_align" = "ALIGN";
"acuant_camera_manual_capture" = "ALIGN & TAP";
"acuant_camera_move_closer" = "MOVE CLOSER";
"acuant_camera_hold_steady" = "HOLD STEADY";
"acuant_camera_capturing" = "CAPTURING";
"acuant_camera_outside_view" = "TOO CLOSE!";

/* AcuantFaceCapture/AcuantPassiveLiveness */
"acuant_face_camera_initial" = "Align face to start capture";
"acuant_face_camera_face_too_close" = "Too Close! Move Away";
"acuant_face_camera_face_too_far" = "Move Closer";
"acuant_face_camera_face_has_angle" =  "Face has Angle. Do not tilt";
"acuant_face_camera_face_not_in_frame" =  "Move in Frame";
"acuant_face_camera_face_moved" = "Hold Steady";
"acuant_face_camera_capturing_2" = "Capturing\n2...";
"acuant_face_camera_capturing_1" = "Capturing\n1...";

"idology_header_title" = "Please capture the front of the ID";
"idology_start" = "Start";
"idology_retry" = "Retry";
"idology_cancel" = "Cancel";
"idology_confirm" = "Confirm";
"idology_captureBack" = "If you are satisfied please confirm and capture the back of the document";
"idology_captureSelfie" = "If you are satisfied please confirm and please take a selfie";
"idology_thankYou" = "If your satisfied with all images, please confirm";

```

## Usage
- Copy `ScanForensicsPlus.xcframework` to your xcode project folder under a Frameworks folder for example: 
  - ```~/MyXcodeProject/Frameworks/ScanForensicsPlus.xcframework``` 
- Also copy the `ScanForensicsPlus.podspec` file to the root of your project for example:
  - ```~/MyXcodeProject/ScanForensicsPlus.podspec```
- Add ```pod 'ScanForensicsPlus', :path => '.' # or add your local path where the podspec file is saved```

Alternatively you can add the `ScanForensicsPlus.xcframework` under the "Embedded binaries" section, in the General tab of your target project.

## Permissions
- Define these permissions in your apps info.plist
```
Privacy - Camera Usage Description 
```

## Api Reference
### In order to receive results from the scan you must adopt this protocol `ScanForensicsResults` 
```func completedScan(frontImage: ScannedImage?, backImage: ScannedImage?, selfieImage:.ScannedImage?, barcode: String?, liveness: Bool)```
- This method is called once the last image is confirmed by the user

### `ScannedImage` has the following properties that will be useful when analyzing an image
- base64: will give you a base64 version of the image
- image: will give you the UIImage for presentation purposes
- acuantImage: will give you the AcuantImage that has more information about the image 
- isBadImage: will check the current image to see if it is likely to fail our api services like ExpectID Scan Onboard, etc.

### `AcuantImage` has the following properties 
-  data: a NSData representation of the image taken
-  sharpness: an integer value indicating the sharpness of the image
-  glare: an integer value indicating how much glare was in the image
-  dpi: the approximate dots per inch for the image use to judge resolution
-  isPassport: determines whether we were able to determine the type of the ID, either a passport or some other ID
   -  Note for this to work accurately you need to scan a real passport and not off a phone or laptop screen

`public func launchSDK(username: String,
                          password: String,
                          environment: IDEnvironment? = .production,
                          scanDelegate: ScanForensicsResults,
                          showAdvanced: Bool? = false,
                          confirmButtonColors: Dictionary<String, String>? = nil,
                          cancelButtonColors: Dictionary<String, String>? = nil,
                          backgroundColor: String? = nil)`
```
    Changes for 1.2 Adding dictionaries that allow you to customize the button and background view colors
    Calls the IDology activation service to activate the AcuantSDK and then launches the SDK
     - username: your username associated with your IDology account
     - password: the password associated with your IDology account
     - environment: an optional variable describing which environment you wish to target, defaults to production but you can use staging as well
     - scanDelegate: the delegate method that returns all the results of scanning, this includes front, back, selfie image capture, barcode, and a liveness boolean
     - showAdvanced: if true, after capturing an image you will see more information on the screen to help determine if its a good image or not
     - confirmButtonColors: hex string colors needed to customize the color of the confirm / start button
     - cancelButtonColors: hex string colors needed to customize the color of the cancel / retry button
     - backgroundColor: hex string to modify the background color of the launch view
     - Note
     ```
     let imageCaptureController = ImageCaptureViewController()
     let confirmColors = ["backgroundColor": "#FFF000",
                          "highlightedColor": "#FFF000",
                          "titleNormal": "#FFF000",
                          "titleHighlighted": "#FFF000"]
     
     let cancelColors = ["backgroundColor": "#FFF000",
                         "highlightedColor": "#FFF000",
                         "titleNormal": "#FFF000",
                         "titleHighlighted": "#FFF000"]
     
     let backgroundColors = "#000FFF"
     
     imageCaptureController.launchSDK(username: username, password: password, environment: environment,  scanDelegate: context.coordinator, showAdvanced: true, confirmButtonColors: confirmColors, cancelButtonColors: cancelColors, backgroundColor: hexViewBackground)
     
     self.navigationController?.pushViewController(imageCaptureController, animated: false)
     ```
     - version 1.2
```

`public func callApi(service: Service, environment: Environment, parameters: [String: String], completion: @escaping (XMLResponse?, Swift.Error?) -> Void)`
```
    Calls an idology service, returning a parsed response to later use
    - service: enum of the service being called, could be: idScan, scanOnboard, scanVerify, expectID, token
    - environment: enum of the environment, could be: production, staging
    - body parameters: dictionary [String:String] of the body of the URLRequest
    - completion: closure that returns the result of the service call, if successful it will return an XMLResponse instance or a Swift.Error
    - Note
     ```
     let bodyDictionary = ["username": "myUsername", "password": "myPassword"]
     IDologyRequest.callApi(service: Service.token, environment: Environment.staging, parameters: bodyDictionary, completion: handleResult)
     ```
    - Version: 1.0
```

`public func initialize(_ token: IDologyToken, completion:@escaping(Bool) -> Void)`
```
    Change for 1.2: Removing compression constant and calculating that internally to the SDK as it was problematic
    Change for 1.1: Added internet connection check using NWPathMonitor(), and send back errors in the completion handler
    Calls the IDology activation service to activate the AcuantSDK and then launch the SDK
     - token: IDologyToken instance created by calling the token class
     - completion: closure block that returns the result of calling the service, with a boolean indicating success or failure
     - Note
     ```
     let tokenService = IDologyTokenService(environment: Environment(rawValue: pref.environment) ?? .undefined)
     // environment is optional, it will default to production if not passed in
     let tokenService2 = IDologyTokenService()
     addSpinner()

     tokenService.getToken(pref.login, pref.password) { (token, _) in
         DispatchQueue.main.async { [unowned self] in
             self.actInd.stopAnimating()
         }

         self.scanForensicsController.initialize(token) { (ready) in
             if (ready) {
                // Take needed steps to use camera sdk
             } else {
                 self.showError()
             }
         }
     }
     ```
     - version 1.2
```

`public static func versionNumber() -> String`
```
     - returns a string representation of the current version of the SDK
     - Note
    ```
    print(ScanForensicsPlusController.versionNumber()
    ```
    - version 1.1
```

`static public func imageSpecs(acuantImage: AcuantImage?) -> [String: Int]?`
```
    Returns some information about a given AcuantImage, this will return a dictionary containing
     sharpness, glare, dpiValue and if its a passport or not
     - acuantImage: the AcuantImage given to get specs for
     - Note
     ```
     let imageInformation = ScanForensicsPlusController.imageSpecs(acuantImage: myAcuantImage)
     print(imageInformation)
     ```
     - version 1.0
```

`public func expectID(environment: IDEnvironment? = .production, username: String, password: String, address: String, city: String, state: String, countryCode: String, zipcode: String, firstName: String, lastName: String, completion: @escaping (XMLResponse?, Swift.Error?) -> Void)`
```
    Specialized method to call the ExpectID
    - environment: (Optional) enum of the environment, could be: production, staging
    - username: the username you have with idology
    - password: the password for the associated username
    - address: the address you want to lookup
    - city: the city you want to lookup
    - state: the state you want to lookup
    - countryCode: the country code, e.g. USA you'd like to lookup
    - zipcode: the zipcode associated with your lookup
    - firstName: the name of the person
    - lastName: the last name of the person
    - completion: closure that returns the result of the service call, if successful it will return an XMLResponse instance or a Swift.Error
    - Note
     ```
     
     expectID(username: "myusername", password: "password", address: "123 street", city: "atlanta", state: "GA", countryCode: "USA", zipcode: "14232", firstName: "Joe", lastName: "Smith", completion: {response, error in
        // use results here
     })
     ```
    - Version: 1.0
```

`public func expectIDScanOnboard(environment: IDEnvironment? = .production, username: String, password: String, countryCode: String, liveness: String, documentType: String, frontImage: String, backImage: String?, selfieImage: String?, completion: @escaping (XMLResponse?, Swift.Error?) -> Void)`
```
    Specialized method to call the ExpectID Scan Onboard service
    - environment: (Optional) enum of the environment, could be: production, staging
    - username: the username you have with idology
    - password: the password for the associated username
    - liveness: (Optional) Indicates the result of the image capture's liveness meta information, check if your enterprise has this enabled
    - documentType: Indicates the documentType you are scanning,either a passport or driversLicense
    - frontImage: front image of the id or passport
    - backImage: (Optional) back image of an id
    - selfie: (Optional) selfie image taken from your front camera, only needed if this feature is enabled in your enterprise
    - completion: closure that returns the result of the service call, if successful it will return an XMLResponse instance or a Swift.Error
    - Note
     ```
     expectIDScanVerify(environment: .production,username: "myUsername", password: "password", countryCode: "USA", liveness: "true", documentType: "driversLicense", frontImage: "base64encodedstring", backImage: "base64encodedstring", selfieImage: "base64encodedstring", completion: { response, error in
        // use results here
     })
     ```
    - Version: 1.0
```

`public func expectIDScanVerify(environment: IDEnvironment? = .production, username: String, password: String, queryId: String, countryCode: String, liveness: String, documentType: String, frontImage: String, backImage: String?, selfieImage: String?, completion: @escaping (XMLResponse?, Swift.Error?) -> Void)`
```
    Specialized method to call the ExpectID Scan Verify service
    - environment: (Optional) enum of the environment, could be: production, staging
    - queryId: the queryId generated by an assciated ExpectID call (Idiq.svc)
    - username: the username you have with idology
    - password: the password for the associated username
    - liveness: (Optional) Indicates the result of the image capture's liveness meta information, check if your enterprise has this enabled
    - documentType: Indicates the documentType you are scanning,either a passport or driversLicense
    - frontImage: front image of the id or passport
    - backImage: (Optional) back image of an id
    - selfie: (Optional) selfie image taken from your front camera, only needed if this feature is enabled in your enterprise
    - completion: closure that returns the result of the service call, if successful it will return an XMLResponse instance or a Swift.Error
    - Note
     ```
     expectIDScanVerify(environment: .production,username: "myUsername", password: "password", queryId: "123412312", countryCode: "USA", liveness: "true", documentType: "driversLicense", frontImage: "base64encodedstring", backImage: "base64encodedstring", selfieImage: "base64encodedstring", completion: { response, error in
     // use results here)
     ```
    - Version: 1.0
```
