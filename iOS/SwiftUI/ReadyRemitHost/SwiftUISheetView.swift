//
//  SwiftUISheetView.swift
//  ReadyRemitHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

struct SwiftUISheetView: View {
    @State private var viewModel: ViewModel = .init()
    
    var body: some View {
        Button("ReadyRemit SDK v10.0.0") {
            viewModel.showReadyRemitSDK()
        }
        .fullScreenCover(item: $viewModel.readyRemitItem) {
            AnyView($0.view)
        }
        .navigationTitle("SwiftUI - Sheet")
    }
}

#Preview {
    SwiftUISheetView()
}
