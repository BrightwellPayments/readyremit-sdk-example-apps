//
//  UIKitPushViewController.swift
//  ReadyRemitHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

class UIKitPushViewController: UIViewController {
    private let viewModel: ViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupObservation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    private func setupCloseButton() {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", primaryAction: action)
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
                        self.navigationController?.pushViewController(hostingController, animated: true)
                    }
                }
            }
        }
    }
}
