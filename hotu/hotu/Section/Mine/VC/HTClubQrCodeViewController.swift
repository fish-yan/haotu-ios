//
//  HTClubQrCodeViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTClubQrCodeViewController: UIViewController {

    @IBOutlet weak var logoImgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var qrcodeImgV: UIImageView!
    
    var name = ""
    
    var logo = ""
    
    var qrcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLab.text = name
        logoImgV.sd_setImage(with: URL(string: logo), completed: nil)
        qrcodeImgV.sd_setImage(with: URL(string: qrcode), completed: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if let img = qrcodeImgV.image {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            Toast("保存成功")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
