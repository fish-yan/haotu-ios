//
//  HTLiveDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLiveDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var countLab: UILabel!
    
    var vm = HTLiveVM()
    
    var activityVM = HTActivityVM()
    
    var items = [HTItemModel]()
    
    var prefixArr = [HTLiveModel]()
    
    @IBOutlet weak var msgV: HTLiveMsgView!
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var camBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.vm.page = 1
            self.request()
        })
        collectionView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.vm.page += 1
            self.request()
        })
        
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_LIVE_BROADCAST_BANNER") { (items) in
            if let v = items {
                self.items = v
                self.collectionView.reloadSections([0])
                self.collectionView.mj_header?.beginRefreshing()
            }
        }
        activityVM.model.activityId = vm.activityId
        activityVM.requestActivityDetail { (success) in }
        configView()
        addObserver()
    }
    
    override func navigationShouldPop() -> Bool {
        msgV.exitChatRoom()
        return true
    }
    
    private func configView() {
        collectionView.register(UINib(nibName: "HTLiveDetailHeaderRView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTLiveDetailHeaderRView")
        msgV.msgTV.emojiAction = { height in
            self.view.endEditing(true)
            self.bottomHeight.constant = height + 200
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let bh: CGFloat = UIApplication.shared.statusBarFrame.height == 20 ? 0 : 34
            bottomHeight.constant = rect.height + 250 - bh
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardHidden(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            bottomHeight.constant = 250
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func request() {
        vm.requestLiveDetail { [weak self] (success) in
            self?.collectionView.mj_header?.endRefreshing()
            self?.collectionView.mj_footer?.endRefreshing()
            if self?.vm.sort == "2"  { // 热门
                if self?.vm.page == 1 {
                    self?.prefixArr = Array(self!.vm.liveDataSource.imageList.prefix(4))
                    self?.vm.liveDataSource.imageList = Array(self!.vm.liveDataSource.imageList.dropFirst(4))
                }
            } else {
                self?.prefixArr = [HTLiveModel]()
            }
            self?.collectionView.reloadData()
            self?.countLab.text = "\(self!.vm.liveDataSource.imageList.count + self!.prefixArr.count)/\(self!.vm.liveDataSource.operationCount.total)"
            if self!.vm.liveDataSource.imageList.count + self!.prefixArr.count >= self!.vm.liveDataSource.operationCount.total.toInt() {
                self?.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
                self?.collectionView.mj_footer?.ignoredScrollViewContentInsetBottom = 250
            }
            self?.camBtn.isHidden = self?.vm.liveDataSource.archorStatus != "3"
            let hidden = self!.vm.liveDataSource.ryChatroomId.isEmpty || self!.vm.liveDataSource.ryChatroomId == "0" || self!.vm.liveDataSource.ryChatroomId == "1"
            self?.msgV.isHidden = hidden
            self?.msgV.configChatRoom(self!.vm.liveDataSource.ryChatroomId)
        }
    }
    
    @IBAction func camAction(_ sender: UIButton) {
        HTImagePickerUtil.share.pickPhoto(with: .photoLibrary) { (img) in
            showHUD()
            HTAppVM.share.uploadImage(img, isZoom:true, isLive: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.imgs = [String]()
                    self.vm.imgs.append(url)
                    self.vm.requestAddPic { (success) in
                        self.collectionView.mj_header?.beginRefreshing()
                    }
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FYMenu" {
            let vc = segue.destination as! FYMenuViewController
            if HTUserInfo.share.userId == activityVM.model.manager_id {
                vc.dataArr = ["好兔二维码", "添加主播","分享连接", "分享图片"]
            } else {
                vc.dataArr = ["好兔二维码", "分享连接", "分享图片"]
            }
            vc.popoverPresentationController?.delegate = self
            vc.complete = { text in
                if text == "好兔二维码" {
                    HTShareQrCodeViewController.show(self.vm.activityId, type: "5")
                } else if text == "添加主播" {
                    let vc = HTMemberListViewController()
                    vc.activityId = self.vm.activityId
                    vc.type = 1
                    vc.title = "主播"
                    vc.complete = { models in
                        self.vm.addAnchors = models
                        self.vm.requestAddAnchor { (success) in
                            self.collectionView.reloadSections([0])
                        }
                    }
                    visibleViewController?.navigationController?.pushViewController(vc, animated: true)
                } else if text == "分享连接" {
                    HTAppVM.share.requestShareUrl(self.vm.activityId, type: "5") { (model) in
                        let vc = FYShareViewController(model.shareUrl, title: self.vm.liveDataSource.activityName, des: "赛事直播", img: UIImage(named: "icon_logo"))
                        vc.type = .live
                        self.present(vc, animated: false, completion: nil)
                    }
                } else if text == "分享图片" {
                    self.vm.requestShareQR { (url) in
                        SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { (image, data, e, success) in
                            let vc = FYShareViewController(url, title: "", des: "", img: image)
                            vc.type = .image
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                }
            }
        } else if segue.identifier == "FYBigImg" {
            let vc = segue.destination as! HTImgListViewController
            vc.dataSource = prefixArr + vm.liveDataSource.imageList
            if let index = sender as? Int {
                vc.index = prefixArr.count + index
            }
        }
    }

}

extension HTLiveDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let height = 150 * SCREEN_WIDTH / 375 + 114 + 69
            return CGSize(width: SCREEN_WIDTH, height: height)
        } else {
            let width = (SCREEN_WIDTH - 2) / 3
            let height = 166/125 * width
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return vm.liveDataSource.imageList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTLiveDetailHeaderCell", for: indexPath) as! HTLiveDetailHeaderCell
            cell.imgs = items.map({$0.itemName})
            cell.seeCountLab.text = "\(vm.liveDataSource.operationCount.seeCount)人浏览"
            cell.headers = vm.liveDataSource.archorList
            cell.countLab.text = "\(vm.liveDataSource.archorList.count)位主播"
            cell.titleLab.text = vm.liveDataSource.activityName
            if self.vm.sort == "1" {
                cell.segment.selectedIndex = 0
            } else if self.vm.sort == "2" {
                cell.segment.selectedIndex = 1
            }
            cell.selectAction = { index in
                if index == 0 {
                    self.vm.sort = "1"
                } else if index == 1 {
                    self.vm.sort = "2"
                }
                self.collectionView.mj_header?.beginRefreshing()
            }
            cell.scrollView.tapAction = { index in
                let ad = self.items[index]
                if !ad.ext.isEmpty {
                    HTUtils.share.checkLogin {
                        FYWebViewController.open(ad.ext)
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTLiveDetailCell", for: indexPath) as! HTLiveDetailCell
            cell.model = vm.liveDataSource.imageList[indexPath.row]
            cell.complete = { success in
                self.collectionView.mj_header?.beginRefreshing()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTLiveDetailHeaderRView", for: indexPath) as! HTLiveDetailHeaderRView
        if self.vm.sort == "2" {
            header.arr = self.prefixArr
            header.complete = { success in
                self.collectionView.mj_header?.beginRefreshing()
            }
            header.tapAction = { index in
                let model = self.prefixArr[index]
                self.performSegue(withIdentifier: "FYBigImg", sender: index - self.prefixArr.count)
                self.vm.requestLiveAddCount(model.id)
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.vm.sort == "2" && section == 1 {
            let height = SCREEN_WIDTH * 917 / 414 + 1
            return CGSize(width: SCREEN_WIDTH, height: height)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let model = vm.liveDataSource.imageList[indexPath.row]
            performSegue(withIdentifier: "FYBigImg", sender: indexPath.row)
            vm.requestLiveAddCount(model.id)
        }
    }
}

extension HTLiveDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

