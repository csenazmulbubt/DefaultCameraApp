//
//  PrivacyPermission.swift
//  DefaultCameraApp
//
//  Created by Nazmul on 02/02/2023.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit
import Photos


class PrivacyPermission: NSObject {

    class func cameraAsscessRequest(completionHandler: @escaping CompletionHandler) {
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            PrivacyPermission.showMicroPhonePermission(completionHandler: completionHandler)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    PrivacyPermission.showMicroPhonePermission(completionHandler: completionHandler)
                } else {
                    completionHandler(false)
                    PrivacyPermission.showAlert(targetName: "Camera", completion: nil)
                }
            }
        }
    }
    
    private class func showAlert(targetName: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{
            
            let alertVC = UIAlertController(title: "Access to the \(targetName)",
                                            message: "Please provide access to your \(targetName)",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(settingsUrl) else { completion?(false); return }
                UIApplication.shared.open(settingsUrl, options: [:]) { _ in
                    //.showAlert(targetName: targetName, completion: completion)
                }
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion?(false) }))
            guard let vc = UIViewController.topMostViewController() else { return }
            vc.present(alertVC, animated: true, completion: nil)
        })
    }
    
    private class func showMicroPhonePermission(completionHandler: @escaping CompletionHandler) -> Void {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completionHandler(true)
        case .denied:
            completionHandler(false)
            PrivacyPermission.showAlert(targetName: "Microphone", completion: nil)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ isGranted in
                // Handle granted
                print("Granted",isGranted)
                if isGranted {
                    completionHandler(true)
                }
                else{
                    completionHandler(false)
                    PrivacyPermission.showAlert(targetName: "Microphone", completion: nil)
                }
            })
        @unknown default:
            print("Unknown case")
        }
    }
}
