//
//  ViewController.swift
//  iOSUIKitSample
//
//  Created by Lucas Araujo on 08/05/23.
//

import UIKit
import ReadyRemitSDK

class ViewController: UIViewController {
    
    @IBOutlet private weak var startSDKUIButton: UIButton!
    
    let senderId = "<Your Sender ID>"
    let clientId = "<Your Client ID>"
    let clientSecret = "<Your Client Secret>"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func onTapStartSDK(_ sender: UIButton) {
        guard let controller = self.navigationController else {
            // ERROR handling in case the navigation controller isn't available
            return
        }
        changeStyle()
        changeFont()
        ReadyRemit.shared.environment = .sandbox
        ReadyRemit.shared.launch(inNavigation: controller, delegate: self) {}
    }
    
    private func changeStyle() {
        let style = ReadyRemitColorScheme() //Create the style color scheme
        style.primaryShade1 = UIColor(lightHex: "#FF9800", darkHex: "#FF9800") //input line, clickable text, primary button
        style.primaryShade2 = UIColor(lightHex: "#B16B04", darkHex: "#B16B04") //Primary button hover
        style.secondaryShade1 = UIColor(lightHex: "#3E3E3E", darkHex: "#3E3E3E") //Secondary button hover
        style.secondaryShade2 = UIColor(lightHex: "#B7B7B8", darkHex: "#B7B7B8") //Primary button disabled
        style.secondaryShade3 = UIColor(lightHex: "#232323", darkHex: "#232323") //Secondary button border
        style.textPrimaryShade1 = UIColor(lightHex: "#3D4045", darkHex: "#3D4045") //Common text
        style.textPrimaryShade2 = UIColor(lightHex: "#55575A", darkHex: "#55575A") //Placeholders
        style.textPrimaryShade3 = UIColor(lightHex: "#47494A", darkHex: "#47494A") //List items, value texts
        style.textPrimaryShade4 = UIColor(lightHex: "#000000", darkHex: "#000000") //Titles, secondary button text color
        style.textPrimaryShade5 = UIColor(lightHex: "#000000", darkHex: "#000000") //Primary button text color
        style.backgroundColorPrimary = UIColor(lightHex: "#F3F0EF", darkHex: "#F3F0EF") //Window color
        style.backgroundColorSecondary = UIColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF") //Toolbar, cards and bottomsheet
        style.backgroundColorTertiary = UIColor(lightHex: "#FFF3E0", darkHex: "#FFF3E0") //Search bar background
        style.success = UIColor(lightHex: "#19AA81", darkHex: "#19AA81") //Success messages
        style.error = UIColor(lightHex: "#D53F3F", darkHex: "#D53F3F") //Error messages, error lines, error fields
        style.controlShade1 = UIColor(lightHex: "#898A8C", darkHex: "#898A8C") //Disabled inputs
        style.controlShade2 = UIColor(lightHex: "#DDDDDD", darkHex: "#DDDDDD") //Enabled inputs, search icon color
        style.controlAccessoryShade1 = UIColor(lightHex: "#9CA3AF", darkHex: "#9CA3AF") //Clear input button icon color
        style.controlAccessoryShade2 = UIColor(lightHex: "#1F2937", darkHex: "#1F2937") //Close button icon color
        ReadyRemit.shared.appearance = ReadyRemitAppearance(colors: style) //Set the new style
    }
    
    
    private func changeFont() {
        ReadyRemitFontScheme.defaultFamily = "Helvetica"
    }

}

extension ViewController: ReadyRemitDelegate {
    func onAuthTokenRequest(success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        API.onAuth(senderId: senderId, clientId: clientId, clientSecret: clientSecret, onSuccess: success, onFailure: failure)
    }
    
    func onSubmitTransfer(transferRequest: ReadyRemitSDK.ReadyRemit.TransferRequest, success: @escaping (String) -> Void, failure: @escaping (String, String) -> Void) {
        //Request transfer from your API
    }
}

