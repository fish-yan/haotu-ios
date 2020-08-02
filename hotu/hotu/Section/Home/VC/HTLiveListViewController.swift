//
//  HTLiveListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/19.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: HTLiveListDateSource!
    
    var vm = HTLiveVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        dataSource = HTLiveListDateSource(tableView)
        dataSource.refresh { (page, result) in
            self.vm.page = page
            self.vm.requestLiveListAll { (success) in
                result(self.vm.dataSource)
            }
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
