//
//  HTImagePickerUtil.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTImagePickerUtil: NSObject {
    
    static let share = HTImagePickerUtil()
    
    private var complete: ((UIImage)->Void)?
    
    func pickerPhoto(_ complete: @escaping (UIImage)->Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "相机拍照", style: .default) { (action) in
            self.pickPhoto(with: .camera, complete: complete)
        }
        let action1 = UIAlertAction(title: "相册选取", style: .default) { (action) in
            self.pickPhoto(with: .photoLibrary, complete: complete)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(cancel)
        visibleViewController?.present(alert, animated: true, completion: nil)
    }
    
    func pickPhoto(with type: UIImagePickerController.SourceType, complete: @escaping (UIImage)->Void) {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = false
        picker.modalPresentationStyle = .overFullScreen
        self.complete = complete
        visibleViewController?.present(picker, animated:true, completion:nil)
    }

}

extension HTImagePickerUtil: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                if let com = self.complete {
                    com(image)
                }
            }
        }
    }
}
