import SwiftUI
import UIKit
import ReadyRemitSDK

internal protocol MainViewState  {
    var showNextScreen: Bool { get set }
}

internal class MainViewModel: ObservableObject, MainViewState {
    
    @Published var showNextScreen: Bool = false
    
    var destView = AnyView(Color.white)
    
    let senderId = "<Your Sender ID>"
    let clientId = "<Your Client ID>"
    let clientSecret = "<Your Client Secret>"
    
    func onTapStartSDK() {
        changeFont()
        changeStyle()
        ReadyRemit.shared.environment = .sandbox
        ReadyRemit.shared.launch(onLoad: { view in
            self.destView = view
            self.showNextScreen = true
        }, delegate: self) { }
    }
    
    private func changeStyle() {
        let style = ReadyRemitColorScheme() //Create the style color scheme
        style.background = UIColor(lightHex: "#F3F4F6", darkHex: "#111111")
        style.foreground = UIColor(lightHex: "#FFFFFF", darkHex: "#1F1F1F")
        style.buttonText = UIColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF")
        style.danger = UIColor(lightHex: "#AA220F", darkHex: "#AA220F")
        style.dangerLight = UIColor(lightHex: "#ECDFDF", darkHex: "#201311")
        style.success = UIColor(lightHex: "#008761", darkHex: "#008761")
        style.divider = UIColor(lightHex: "#E2E2E2", darkHex: "#313131")
        style.inputLine = UIColor(lightHex: "#858585", darkHex: "#505050")
        style.icon = UIColor(lightHex: "#444444", darkHex: "#7E7E7E")
        style.primary = UIColor(lightHex: "#2563EB", darkHex: "#558CF4")
        style.primaryLight = UIColor(lightHex: "#6B8DD6", darkHex: "#83ACF7")
        style.text = UIColor(lightHex: "#0E0F0C", darkHex: "#E3E3E3")
        style.textSecondary = UIColor(lightHex: "#454545", darkHex: "#B0B0B0")
        ReadyRemit.shared.appearance = ReadyRemitAppearance(colors: style)
    }
    
    private func changeFont() {
        ReadyRemitFontScheme.defaultFamily = "Helvetica"
    }
}

extension MainViewModel: ReadyRemitDelegate {
    func onAuthTokenRequest(success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        API.onAuth(senderId: senderId, clientId: clientId, clientSecret: clientSecret, onSuccess: success, onFailure: failure)
    }
    
    func onSubmitTransfer(transferRequest: ReadyRemitSDK.ReadyRemit.TransferRequest, success: @escaping (String) -> Void, failure: @escaping (String, String) -> Void) {
        //Request transfer from your API
    }
}
