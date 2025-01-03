import SwiftUI
import ReadyRemitSDK

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Start ReadyRemitSDK", action: {
                    viewModel.onTapStartSDK()
                })
                .frame(width: 200, height: 50)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
            }.fullScreenCover(isPresented: $viewModel.openReadyRemitSDK, content: { viewModel.readyRemitSDKView })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
