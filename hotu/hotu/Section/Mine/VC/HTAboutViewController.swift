//
//  HTAboutViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAboutViewController: UIViewController {

    @IBOutlet weak var vLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            vLab.text = v
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
