//
//  CameraPickerController.swift
//  DefaultCameraApp
//
//  Created by Nazmul on 02/02/2023.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit
import Photos

class CameraPicker: NSObject{
    
    var pickerResult: (( _ object: Any)->Void)? = nil
    
    public func presentCameraPickerController() -> Void {
        if self.isAvailableCamera() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
            guard let vc = UIViewController.topMostViewController() else { return  }
            vc.present(imagePicker, animated: true, completion: nil)
        }
        else{
            self.showAlert(targetName: "", completion: nil)
        }
    }
    
    private func isAvailableCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            return true
        }
        return false
    }
    
    private func showAlert(targetName: String = "", completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute:{
            
            let alertVC = UIAlertController(title: "Not Found!!",
                                            message: "This device has no camera.",
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
}

//MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CameraPicker: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedVideo: URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                self.pickerResult?(selectedVideo)
            }
        }
        
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            pickerResult?(tempImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
