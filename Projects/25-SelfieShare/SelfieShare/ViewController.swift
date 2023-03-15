//
//  ViewController.swift
//  SelfieShare
//
//  Created by JC on 21/9/21.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name) // Refers to how the current user is shown on other devices
    var mcSession: MCSession?
    var mcAdvertisserAssistant: MCAdvertiserAssistant?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(showConnectionPrompt)
            ),
            UIBarButtonItem(
                title: "Peers",
                style: .plain,
                target: self,
                action: #selector(showConnectedPeers)
            )
        ]
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .camera,
                target: self,
                action: #selector(importPicture)
            ),
            // Challenge 2
            UIBarButtonItem(
                barButtonSystemItem: .compose,
                target: self,
                action: #selector(showMessage)
            )
        ]
        
        // encryptionPreference: .required ensures that any data transfered is kept safe
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        // Tells us when something happen
        mcSession?.delegate = self
    }
    
    // MARK: - Overriden Methods
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageView",
            for: indexPath
        )
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - Methods
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Challenge 2
    @objc func showMessage() {
        let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let text = ac.textFields?[0].text {
                self.sendMessage(text)
            }
        })
        
        present(ac, animated: true)
    }
    
    // Challenge 2
    func sendMessage(_ message: String) {
        let data = Data(message.utf8)
        sendData(data)
    }
    
    func hostSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        /**
         serviceType must be 1-15 long
         Identifies the service in order to avoid connection with other services nearby.
         Only letters, numbers and - (hyphens)
         */
        mcAdvertisserAssistant = MCAdvertiserAssistant(
            serviceType: "dj-txtserv",
            discoveryInfo: nil,
            session: mcSession
        )
        
        // Starts looking for connections to join our session
        mcAdvertisserAssistant?.start()
        
        print("Hosting session...")
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "dj-txtserv", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        
        print("Searching sessions...")
    }
    
    func sendData(_ data: Data) {
        guard let mcSession = mcSession else { return }
        
        if !mcSession.connectedPeers.isEmpty {
            do {
                // .reliable: Ensures in-order delivery
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // Challenge 3 of instructor
    @objc func showConnectedPeers() {
        var peersText = "There are no peers available"
        var peersAvailable = false
        
        if let mcSession = mcSession {
            if !mcSession.connectedPeers.isEmpty {
                peersAvailable = true
                mcSession.connectedPeers.forEach { peer in
                    peersText += "\n\(peer.displayName)"
                }
            }
        }
        
        if !peersAvailable {
            peersText = "No peers connected"
        }
        
        let ac = UIAlertController(
            title: "Connected peers",
            message: peersText,
            preferredStyle: .actionSheet
        )
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showAlertController(
        title: String,
        message: String,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            ac.addAction(action)
        }
        present(ac, animated: true)
    }
    
}

extension ViewController: MCBrowserViewControllerDelegate {

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // Shares the image that we picked to the session
        if let imageData = image.pngData() {
            sendData(imageData)
        }
    }
    
}

extension ViewController: MCSessionDelegate {
    
    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        
    }
    
    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        
    }
    
    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: Error?
    ) {
            
    }
    
    // When there is a data changed on the session
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            [weak self] in
            if let image  = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    // Called when someone dis/connected to the session. Useful for debugging
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            
            // Challenge 1 of instructor
            showAlertController(
                title: "\(peerID.displayName) has disconnnected",
                message: "",
                actions: [UIAlertAction(title: "OK", style: .cancel)]
            )
        
        // For unknown future cases that are not one of these
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
}
