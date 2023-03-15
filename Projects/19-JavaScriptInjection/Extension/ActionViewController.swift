//
//  ActionViewController.swift
//  Extension
//
//  Created by JC on 13/9/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        // Challenge 1 of instructor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(injectPrewrittenJs))
        
        // NotificationCenter catches all the notifications that the OS sends to the log. We can add observers for those notifications and handle them.
        
        // This observer will be sent when the keyboard has just finished hiding.
        // self is the object that should receive notifications
        // In the name we put the name of the notification that we want to receive.
        // The object (last parameter) means: "we son't care who sends the notification"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        // This will be sent when the keyboard changes to any state.
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        // extensionContext lets us control how our extension interacts with the parent  app. extensionContext?.inputItems.first returns an array of data the parent app is sending to our extension to use (NSExtensionItem).
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // inputItem contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item
            if let itemProvider = inputItem.attachments?.first {
                //loadItem() asks the item to provide us with the item asynchronously
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // dict provides the data that was provided to us by iOS. You can find it in the Action.js file of the Extension target. This dictonary will pass an URL and a title
                    
                    // NSDictionary is like a Swift dictionary but you don't have to know what data types it holds. We prefer it over the Swift's one because we don't know what's in the itemDictionary
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    
                    // itemDictionary holds the data we sent from JavaScript, which is stored in a special key called NSExtensionJavaScriptPreprocessingResultsKey. We pull out that value of the dictionary and put it into javaScriptValues
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageUrl = javaScriptValues["URL"] as? String ?? ""
                    
                    // We're changing a minor detail of the UI, so we load it on an async task in the main thread
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

    @IBAction func done() {
        // item will host our items
        let item = NSExtensionItem()
        // argument contains a dictionary with the key "customJavaScript" and the value (script.text) which has the code that the user input
        let argument: NSDictionary = ["customJavaScript": script.text]
        // put the argument into another dictionary with the key NSExtension...
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        // customJavaScript wraps the dictionary inside an NSItemProvider object with the type identifier kUTTypePropertyList
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        // place the NSItemProvider into our NSExtensionItem as its attachments
        item.attachments = [customJavaScript]
        // call completeRequest() returning our NSExtensionItem
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // notification parameter includes the name of the notification as well as a Dictionary containing notification-specific information called userInfo. Due to working with keyboards, the dictionary will contain  a key called UIResponser.keyboardFrameEndUserInfoKey telling us the frame of the keyboard after it has finished animating. This will be of type NSValue, which in turn is of type CGRect.
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // keyboardValue.cgRectValue tells us the size of the keyboard
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        // view.convert  is necessary in case that the user is in landscape
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        // contentInset sets a margin to the right part of the TextView
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            // - view.safeAreaInsets is because in Max devices, the inset doesn't go to the bottom because of the safe area.
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        // Finally, we make the TextView to scroll
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    // Challenge 1 of instructor
    @objc func injectPrewrittenJs(_ action: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Select an action", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Show alert", style: .default) {
            [weak self] _ in
            self?.script.text = "alert(document.title);"
            self?.done()
        })
        alertController.addAction(UIAlertAction(title: "Prompt box", style: .default) {
            [weak self] _ in
            self?.script.text = "var person = prompt(\"Please enter your name\", \"DJ\"); if (person != null) { alert(\"Hello \" + person + \"! How are you today?\"); }"
            self?.done()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
