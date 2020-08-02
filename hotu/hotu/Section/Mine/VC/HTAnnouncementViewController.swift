//
//  HTAnnouncementViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAnnouncementViewController: UIViewController {

    @IBOutlet weak var announcementTV: UITextView!
    
    @IBOutlet weak var pLab: UILabel!
    @IBOutlet weak var publishBtn: UIButton!
    
    var vm = HTClubVM()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementTV.text = vm.model.remark
        pLab.isHidden = !announcementTV.text.isEmpty
        let isManager = vm.model.userId == HTUserInfo.share.userId
        announcementTV.isUserInteractionEnabled = isManager
        publishBtn.isHidden = !isManager
    }
    
    @IBAction func publishAction(_ sender: UIButton) {
        vm.model.notice = announcementTV.text
        vm.requestUpdateClubInfo { (success) in
            self.navigationController?.popViewController(animated: true)
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

extension HTAnnouncementViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = !textView.text.isEmpty
    }
}
