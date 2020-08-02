//
//  HTPublishActivityViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishActivityViewController: UIViewController {
    @IBOutlet weak var pLab: UILabel!
    @IBOutlet weak var nmTF: UITextField!
    @IBOutlet weak var countTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var desTV: UITextView!
    
    @IBOutlet weak var addTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    
    @IBOutlet weak var linshiTF: UITextField!
    
    var vm = HTPublishActivityVM()
    
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdate {
            navigationItem.leftBarButtonItem = nil
            configView()
        }
    }
    
    func configView() {
        nmTF.text = vm.model.activityName
        dateTF.text = vm.model.startTime.formatDate("yyyy-MM-dd HH:mm:ss", to: "yyyy年MM月dd日HH时")
        addTF.text = vm.model.activityAddress
        countTF.text = vm.model.total_no
        priceTF.text = vm.model.member_amount
        priceTF.isEnabled = false
        discountTF.text = vm.model.discount_amount
        discountTF.isEnabled = false
        typeTF.text = vm.model.projectTypeName
        desTV.text = vm.model.remark
        if vm.model.activityProperty == "1" {
            linshiTF.text = "固定场"
        } else if vm.model.activityProperty == "2" {
            linshiTF.text = "临时场"
        }
        pLab.isHidden = !vm.model.remark.isEmpty
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        if isUpdate {
            vm.requestUpdateActivity { (success) in
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .HTActivityChanged, object: nil)
            }
        } else {
            vm.requestPublishActivity { (success) in
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .HTActivityChanged, object: nil)
            }
        }
        
    }

    @IBAction func activityTitleChanged(_ sender: UITextField) {
        vm.model.activityName = sender.text ?? ""
    }
    
    @IBAction func dateChanged(_ sender: UIButton) {
        view.endEditing(true)
        FYDatePicker.showDatePicker { (date) in
            self.dateTF.text = date.toString("yyyy年MM月dd日HH时")
            self.vm.model.startTime = date.toString("yyyy-MM-dd HH:mm:ss")
        }
    }
    @IBAction func endDateChanged(_ sender: UIButton) {
        view.endEditing(true)
        FYDatePicker.showDatePicker { (date) in
            self.endDateTF.text = date.toString("yyyy年MM月dd日HH时")
            self.vm.model.endTime = date.toString("yyyy-MM-dd HH:mm:ss")
        }
    }
    @IBAction func addressChanged(_ sender: UITextField) {
        vm.model.activityAddress = sender.text ?? ""
    }
    
    @IBAction func countChanged(_ sender: UITextField) {
        vm.model.total_no = sender.text ?? ""
    }
    
    @IBAction func amountChanged(_ sender: UITextField) {
        vm.model.member_amount = sender.text ?? ""
    }
    
    @IBAction func youhuiChanged(_ sender: UITextField) {
        vm.model.discount_amount = sender.text ?? ""
    }
    
    @IBAction func lishiAction(_ sender: UIButton) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "固定场", style: .default) { (action) in
            self.linshiTF.text = action.title
            self.vm.model.activityProperty = "1"
        }
        let action1 = UIAlertAction(title: "临时场", style: .default) { (action) in
            self.linshiTF.text = action.title
            self.vm.model.activityProperty = "2"
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTItemList" {
            let vc = segue.destination as! HTItemListViewController
            vc.code = "PROJECT_TYPE"
            vc.complete = { item in
                self.vm.model.activityType = item.itemCode
                self.typeTF.text = item.itemName
            }
        }
    }

}


extension HTPublishActivityViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = textView.text.count != 0
        vm.model.remark = textView.text
    }
}
