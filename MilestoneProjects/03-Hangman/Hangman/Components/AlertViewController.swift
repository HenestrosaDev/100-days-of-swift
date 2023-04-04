//
//  AlertViewController.swift
//  Hangman
//
//  Created by JC on 2/4/23.
//

import UIKit

class AlertViewController: UIViewController {

    // MARK: Properties
    
    private let alertTitle: String
    private let titleColor: UIColor
    private let message: String?
    private let buttonTitle: String
    private let completionButton: (() -> Void)?
    
    private lazy var containerView = UIView()
    private lazy var titleLb = UILabel()
    private lazy var messageLb = UILabel()
    private lazy var actionBt = UIButton()
    
    private let padding: CGFloat = 20
    
    // MARK: - Initializers
    
    init(
        title: String,
        titleColor: UIColor,
        message: String?,
        buttonTitle: String,
        completionButton: (() -> Void)? = nil
    ) {
        self.alertTitle = title
        self.titleColor = titleColor
        self.message = message
        self.buttonTitle = buttonTitle
        self.completionButton = completionButton
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundBlur()
        configureContainerView()
        
        configureTitleLb()
        configureActionBt()
        
        if message != nil {
            configureMessageLb()
        }
    }
    
    // MARK: - Methods
    
    private func configureBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        blurredEffectView.alpha = 0.75
        view.addSubview(blurredEffectView)
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .systemBlue
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        
        let maxHeight: CGFloat = 480
        let width: CGFloat = 280
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight),
            containerView.widthAnchor.constraint(equalToConstant: width),
        ])
    }
    
    private func configureTitleLb() {
        containerView.addSubview(titleLb)
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        
        titleLb.text = alertTitle
        titleLb.numberOfLines = 1
        titleLb.textAlignment = .center
        titleLb.textColor = titleColor
        titleLb.font = UIFont(name: "Marker Felt", size: 46)
        titleLb.adjustsFontForContentSizeCategory = true
        titleLb.adjustsFontSizeToFitWidth = true
        titleLb.minimumScaleFactor = 0.75
        titleLb.lineBreakMode = .byClipping
        
        NSLayoutConstraint.activate([
            titleLb.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLb.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLb.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureActionBt() {
        containerView.addSubview(actionBt)
        actionBt.translatesAutoresizingMaskIntoConstraints = false
        
        actionBt.tintColor = .systemIndigo
                
        actionBt.configuration = .filled()
        actionBt.configuration?.baseForegroundColor = .white
        actionBt.configuration?.title = title
        actionBt.configuration?.image = UIImage(systemName: "arrow.forward")!
        actionBt.configuration?.imagePadding = 6
        actionBt.configuration?.imagePlacement = .trailing
        actionBt.configuration?.cornerStyle = .medium
        
        var container = AttributeContainer()
        container.font = UIFont(name: "Marker Felt", size: 24)
        actionBt.configuration?.attributedTitle = AttributedString(buttonTitle, attributes: container)
        
        actionBt.layer.borderWidth = 1
        actionBt.layer.borderColor = UIColor.white.cgColor
        actionBt.layer.cornerRadius = 5
        
        actionBt.addTarget(self, action: #selector(didTapActionBt), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionBt.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionBt.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionBt.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureMessageLb() {
        containerView.addSubview(messageLb)
        messageLb.translatesAutoresizingMaskIntoConstraints = false
        
        messageLb.text = message
        messageLb.numberOfLines = 0
        messageLb.textColor = .white
        messageLb.font = UIFont(name: "Marker Felt", size: 28)
        messageLb.adjustsFontForContentSizeCategory = true
        messageLb.adjustsFontSizeToFitWidth = true
        messageLb.minimumScaleFactor = 0.75
        messageLb.lineBreakMode = .byWordWrapping
        messageLb.textAlignment = .center
        
        
        NSLayoutConstraint.activate([
            messageLb.topAnchor.constraint(equalTo: titleLb.bottomAnchor, constant: padding),
            messageLb.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLb.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLb.bottomAnchor.constraint(equalTo: actionBt.topAnchor, constant: -padding),
        ])
    }
    
    // MARK: Actions
    
    @objc private func didTapActionBt() {
        completionButton?()
        dismiss(animated: true)
    }
    
}
