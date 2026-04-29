//
//  UIKitPresentViewController.swift
//  ReadyRemitHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

class UIKitPresentViewController: UIViewController {
    private let viewModel: ViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupObservation()
    }

    private func setupButton() {
        let action = UIAction { _ in
            self.viewModel.showReadyRemitSDK()
        }
        
        let button = UIButton(primaryAction: action)
        button.setTitle("ReadyRemit SDK v10.2.0", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupObservation() {
        withObservationTracking {
            _ = viewModel.readyRemitItem
        } onChange: { [weak self] in
            guard let self else { return }
            Task {
                await MainActor.run {
                    if let readyRemitItem = self.viewModel.readyRemitItem {
                        let hostingController = UIHostingController(rootView: AnyView(readyRemitItem.view))
                        hostingController.modalPresentationStyle = .fullScreen
                        self.present(hostingController, animated: true)
                    }
                }
            }
        }
    }
}
