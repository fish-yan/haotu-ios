//
//  HTReportViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTReportViewController: UIViewController {
    @IBOutlet weak var pLab: UILabel!
    @IBOutlet weak var textV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        requestReport { (success) in
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

extension HTReportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = !textView.text.isEmpty
    }
}

extension HTReportViewController {
    func requestReport(complete: @escaping(Bool)->Void) {
        if textV.text.isEmpty {
            Toast("请填写举报内容")
            return
        }
        let params = ["content": textV.text!]
        FYNetWork.request(USER_REPORT, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("举报成功") {
                complete(true)
            }
        }
    }
}
