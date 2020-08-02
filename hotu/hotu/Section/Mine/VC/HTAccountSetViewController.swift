//
//  HTAccountSetViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAccountSetViewController: UIViewController {
    @IBOutlet weak var accountLab: UILabel!
    
    @IBOutlet weak var isRealLab: UILabel!
    @IBOutlet weak var telLab: UILabel!
    
    var vm = HTMineVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountLab.text = HTUserInfo.share.userName
        telLab.text = HTUserInfo.share.tel
        vm.requestUserCount { (success) in
            self.isRealLab.text = HTUserInfo.share.isReal ? "已认证" : "未认证"
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
