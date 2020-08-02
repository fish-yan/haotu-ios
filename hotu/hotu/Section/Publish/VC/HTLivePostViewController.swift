//
//  HTLivePostViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/25.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLivePostViewController: UIViewController {
    @IBOutlet weak var imgV: UIImageView!
    
    var post = ""
    
    var activityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgV.sd_setImage(with: URL(string: post), completed: nil)
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTLiveDetailViewController" {
            let vc = segue.destination as! HTLiveDetailViewController
            vc.vm.activityId = activityId
        }
    }

}
