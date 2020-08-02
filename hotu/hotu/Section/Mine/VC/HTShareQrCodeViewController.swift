//
//  HTShareQrCodeViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/26.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import SwiftyJSON

class HTShareQrCodeViewController: UIViewController {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var qrCodeImgV: UIImageView!
    @IBOutlet weak var notiLab: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var tLa: UILabel!
    var id = ""
    var type = ""
                
    @discardableResult
    static func show(_ id: String, type: String) -> HTShareQrCodeViewController {
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTShareQrCodeViewController") as! HTShareQrCodeViewController
        vc.hidesBottomBarWhenPushed = true
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        vc.id = id
        vc.type = type
        return vc
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if UMSocialManager.default()?.isInstall(.QQ) == false && !WXApi.isWXAppInstalled() {
            self.navigationItem.rightBarButtonItem = nil
        }
        request()
    }
    
    func request() {
        HTAppVM.share.requestShareUrl(id, type: type) { (model) in
            self.qrCodeImgV.sd_setImage(with: URL(string: model.erCodeUrl), completed: nil)
            self.titleLab.text = model.name
            self.desLab.text = model.remark
            self.notiLab.text = model.notify
            self.tLa.text = model.title
            self.logo.sd_setImage(with: URL(string: model.logo), completed: nil)
        }
    }

    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        if let image = screenshot() {
            let vc = FYShareViewController("", title: "", des: "", img: image)
            vc.type = .image
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContext(v.bounds.size)
        let ctx = UIGraphicsGetCurrentContext()!
        v.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
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
