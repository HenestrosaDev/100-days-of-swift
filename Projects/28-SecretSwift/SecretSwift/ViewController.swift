//
//  ViewController.swift
//  SecretSwift
//
//  Created by JC on 18/3/23.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var secret: UITextView!
    let lockedTitle = "Nothing to see here"
    let unlockedTitle = "Secret stuff!"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = lockedTitle
        addObservers()
        
        // Challenge 2
        KeychainWrapper.standard.set("Bocad!yoDeNosilla", forKey: KeychainKeys.appPassword)
    }

    // MARK: - Private Methods
    
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        
        // Necessary for knowing when the keyboard is hidden
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Necessary for knowing when the keyboard is prompted
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        /**
         Triggered when the app has been backgrounded or the user has switched to multitasking
         mode.
         Useful for automatically saving the text view's text.
         */
        notificationCenter.addObserver(
            self,
            selector: #selector(saveSecretMessage),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    private func unlockSecretMessage() {
        // Challenge 1
        showDoneBarItem()
        
        secret.isHidden = false
        title = unlockedTitle
        
        secret.text = KeychainWrapper.standard.string(forKey: KeychainKeys.secretMessage) ?? ""
    }
    
    @objc private func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: KeychainKeys.secretMessage)
        
        // Hides the keyboard
        secret.resignFirstResponder()
        
        secret.isHidden = true
        title = lockedTitle
        
        // Challenge 1
        navigationItem.rightBarButtonItem = nil
    }
    
    /**
     Makes the text view adjust its content and scroll insets when the keyboard
     appears and disappears.
     */
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else {
            return
        }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    @IBAction func didTapAuthenticate(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        /**
         &error => LocalAuthentication framework uses Objective-C (that's why the type of the
         error variable is NSError). We pass the error argument as a reference to our error
         variable, which then changes its value inside the canEvaluatePolicy() method. It's similar
         to inout parameters in Swift.
         */
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "To access sensible content, you must identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        // Challenge 2
                        self.askForPassword()
                    }
                }
            }
        } else {
            showAlertController(
                title: "Biometry unavailable",
                message: "Your device is not configured for biometric authentication"
            )
        }
    }
    
    private func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Challenge 1
    private func showDoneBarItem() {
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(saveSecretMessage)
        )

        navigationItem.rightBarButtonItem = doneButton
    }
    
    // Challenge 2
    private func askForPassword() {
        let alertController = UIAlertController(
            title: "Enter the password",
            message: nil,
            preferredStyle: .alert
        )

        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let password = alertController.textFields?[0].text else { return }
            
            if password == KeychainWrapper.standard.string(forKey: KeychainKeys.appPassword) ?? "" {
                self.unlockSecretMessage()
            } else {
                self.showAlertController(title: "Error", message: "The password is not correct")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
}
