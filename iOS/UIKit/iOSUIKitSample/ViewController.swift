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
        ReadyRemit.shared.environment = .sandbox
        ReadyRemit.shared.launch(inNavigation: controller, delegate: self) {}
    }
    
    private func changeStyle() {
        let style = ReadyRemitColorScheme() //Create the style color scheme
        style.background = RRMDynamicColor(light: "#F3F4F6", dark: "#111111")
        style.foreground = RRMDynamicColor(light: "#FFFFFF", dark: "#1F1F1F")
        style.buttonText = RRMDynamicColor(light: "#FFFFFF", dark: "#FFFFFF")
        style.danger = RRMDynamicColor(light: "#AA220F", dark: "#AA220F")
        style.dangerLight = RRMDynamicColor(light: "#ECDFDF", dark: "#201311")
        style.success = RRMDynamicColor(light: "#008761", dark: "#008761")
        style.divider = RRMDynamicColor(light: "#E2E2E2", dark: "#313131")
        style.inputLine = RRMDynamicColor(light: "#858585", dark: "#505050")
        style.icon = RRMDynamicColor(light: "#444444", dark: "#7E7E7E")
        style.primary = RRMDynamicColor(light: "#2563EB", dark: "#558CF4")
        style.primaryLight = RRMDynamicColor(light: "#6B8DD6", dark: "#83ACF7")
        style.text = RRMDynamicColor(light: "#0E0F0C", dark: "#E3E3E3")
        style.textSecondary = RRMDynamicColor(light: "#454545", dark: "#B0B0B0")
        ReadyRemit.shared.appearance = ReadyRemitAppearance(colors: style)
    }

}

extension ViewController: ReadyRemitDelegate {
    func onAuthTokenRequest(success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        API.onAuth(senderId: senderId, clientId: clientId, clientSecret: clientSecret, onSuccess: { token in
            DispatchQueue.main.async {
                success(token)
            }
        }, onFailure: {
            DispatchQueue.main.async {
                failure()
            }
        })
    }
    
    func onSubmitTransfer(transferRequest: ReadyRemitSDK.ReadyRemit.TransferRequest, success: @escaping (String) -> Void, failure: @escaping (String, String) -> Void) {
        //Request transfer from your API
    }
}

