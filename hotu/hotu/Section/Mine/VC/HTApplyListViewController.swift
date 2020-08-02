//
//  HTApplyListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyListViewController: UIViewController {

    @IBOutlet weak var anchorV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        anchorV.isHidden = HTUserInfo.share.role == .anchor
    }
    
    @IBAction func applyClubAction(_ sender: UIButton) {
        HTUtils.share.checkVitified {
            self.performSegue(withIdentifier: "HTApplyClub", sender: nil)
        }
    }
    
    @IBAction func applyMercAction(_ sender: UIButton) {
        HTUtils.share.checkVitified {
            self.performSegue(withIdentifier: "HTApplyMerc", sender: nil)
        }
    }
    
    @IBAction func applyCoachAction(_ sender: UIButton) {
        HTUtils.share.checkVitified {
            self.performSegue(withIdentifier: "HTApplyCoach", sender: nil)
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
