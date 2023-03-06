//
//  ViewController.swift
//  DefaultCameraApp
//
//  Created by Nazmul on 31/01/2023.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class ViewController: UIViewController {
    
    let cameraPicker = CameraPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraPickerBindingResult()
    }
    
    //MARK: - showPickerButtonAction
    @IBAction func showPickerButtonAction(_ sender: UIButton) {
        PrivacyPermission.cameraAsscessRequest { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Success")
                    self.cameraPicker.presentCameraPickerController()
                }
            }
        }
    }
    
    private func cameraPickerBindingResult() -> Void {
        self.cameraPicker.pickerResult = { [weak self] res in
            guard let _ = self else { return }
            if let videoUrl = res as? URL {
                let asset = AVURLAsset(url: videoUrl)
                print("Asset Duration",asset.duration)
            }
            if let image = res as? UIImage {
                print("image ",image.size)
            }
        }
    }
}

extension ViewController {
   
}
