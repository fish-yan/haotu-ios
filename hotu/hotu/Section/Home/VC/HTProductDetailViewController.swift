//
//  HTProductDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

class HTProductDetailViewController: UIViewController {

    
    @IBOutlet weak var imgV: UIImageView!
       
    @IBOutlet weak var titleLab: UILabel!

    @IBOutlet weak var tagsLab: YYLabel!
       
    @IBOutlet weak var priceLab: UILabel!
    
    var vm = HTProductVM()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    private func configView() {
        imgV.sd_setImage(with: URL(string: vm.productModel.img), completed: nil)
        titleLab.text = vm.productModel.name
        tagsLab.attributedText = vm.productModel.tag.toTags(SCREEN_WIDTH - 40)
        if vm.productModel.discountPrice.isEmpty {
            priceLab.text = "￥" +  vm.productModel.price
        } else {
            priceLab.text = "￥" +  vm.productModel.discountPrice
        }
    }
    
    private func request() {
        vm.requestProductDetail { (success) in
            self.configView()
        }
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        if let url = URL(string: "tel:\(vm.productModel.phoneNo)") {
            UIApplication.shared.openURL(url)
        } else {
            Toast("未获取到联系方式")
        }
    }

    @IBAction func rightItemAction(_ sender: Any) {
        HTShareQrCodeViewController.show(self.vm.productId, type: "4")
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
