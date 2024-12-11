import SwiftUI
import UIKit
import ReadyRemitSDK
import Combine

internal protocol MainViewState  {
    var openReadyRemitSDK: Bool { get set }
}

internal class MainViewModel: ObservableObject, MainViewState {
    
    @Published var openReadyRemitSDK: Bool = false
    @Published var readyRemitSDKView = AnyView(Color.white)
    
    private let senderId = "<Your Sender ID>"
    private let clientId = "<Your Client ID>"
    private let clientSecret = "<Your Client Secret>"
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func onTapStartSDK() {
        changeStyle()
        ReadyRemit.shared.environment = .sandbox
        ReadyRemit.shared.launch(onLoad: { view in
            self.readyRemitSDKView = view
            self.openReadyRemitSDK = true
        }, delegate: self) { }
    }
    
    @MainActor
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

extension MainViewModel: ReadyRemitDelegate {
    func onAuthTokenRequest(success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        API.onAuth(senderId: senderId, clientId: clientId, clientSecret: clientSecret)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    DispatchQueue.main.async {
                        failure()
                    }
                }
            }, receiveValue: { token in
                DispatchQueue.main.async {
                    success(token)
                }
            }).store(in: &cancellables)
    }
    
    func onSubmitTransfer(transferRequest: ReadyRemitSDK.ReadyRemit.TransferRequest, success: @escaping (String) -> Void, failure: @escaping (String, String) -> Void) {
        //Request transfer from your API
    }
}
