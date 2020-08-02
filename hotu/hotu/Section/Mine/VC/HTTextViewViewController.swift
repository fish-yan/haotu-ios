//
//  HTTextViewViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/20.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

class HTTextViewViewController: UIViewController, YYTextViewDelegate {
    @IBOutlet weak var tv: YYTextView!
    
    var complete: ((String)->Void)?
    
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.text = text
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
        if let c = complete {
            c(tv.text)
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
    
    func textViewDidChange(_ textView: YYTextView) {
        if textView.text.count >= 200 {
            textView.text = textView.text.subString(from: 0, to: 200)
        }
    }

}
