//
//  HTSearchViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var searchResultView: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var courseTableView: UITableView!
    
    private var videoDataSource: HTVideoMiddleDataSource!
    private var activityDataSource: HTActivityDataSource!
    private var friendDataSource: HTFriendDataSource!
    private var productDataSource: HTProductDataSource!
    private var courseDataSource: HTProductDataSource!
    
    private var videoVM = HTVideoVM()
    private var activityVM = HTActivityVM()
    private var liveVM = HTLiveVM()
    private var productVM = HTProductVM()
    private var courseVM = HTProductVM()
    private var vm = HTSearchVM()
    
    private var videoNeedRefresh = false
    private var friendNeedRefresh = false
    private var activityNeedRefresh = false
    private var productNeedRefresh = false
    private var courseNeedRefresh = false
        
    private var isTapSegment = false
    
    var isCloseAd = false
    
    var ad: HTItemModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        requestKeys()
        requestAd()
    }
    
    private func configView() {
        segment.titleArray = ["视频", "用户", "活动", "商品", "课程"]
        segment.selectAction = { index in
            self.isTapSegment = true
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self.firstRequest()
        }
        videoDataSource = HTVideoMiddleDataSource(videoCollectionView)
        activityDataSource = HTActivityDataSource(activityTableView)
        friendDataSource = HTFriendDataSource(friendTableView)
        productDataSource = HTProductDataSource(productTableView)
        courseDataSource = HTProductDataSource(courseTableView)
    }
    
    private func resetResultView() {
        searchResultView.isHidden = true
        searchTF.text = ""
        collectionView.reloadData()
        segment.selectedIndex = 0
        contentScrollView.setContentOffset(CGPoint.zero, animated: false)
        videoVM.dataSource = [HTVideoModel]()
        activityVM.dataSource = [HTActivityModel]()
        liveVM.anchors = [HTMemberModel]()
        productVM.dataSource = [HTProductModel]()
        courseVM.dataSource = [HTProductModel]()
    }
    
    private func searchAction() {
        vm.keyword = searchTF.text ?? ""
        if vm.keyword.isEmpty {
            Toast("搜索关键字为空")
            return
        }
        searchTF.endEditing(true)
        searchResultView.isHidden = false
        vm.requestAddSearchKey()
        videoNeedRefresh = true
        friendNeedRefresh = true
        activityNeedRefresh = true
        productNeedRefresh = true
        courseNeedRefresh = true
        request()
        firstRequest()
    }
    
    private func requestKeys() {
        vm.requestHotSearchKey { (success) in
            self.collectionView.reloadData()
        }
    }
    
    private func firstRequest() {
        switch segment.titleArray[segment.selectedIndex] {
        case "商品":
            if productVM.dataSource.isEmpty || productNeedRefresh {
                productTableView.mj_header?.beginRefreshing()
                productNeedRefresh = false
            }
        case "课程":
            if courseVM.dataSource.isEmpty || courseNeedRefresh {
                courseTableView.mj_header?.beginRefreshing()
                courseNeedRefresh = false
            }
        case "视频":
            if videoVM.dataSource.isEmpty || videoNeedRefresh {
                videoCollectionView.mj_header?.beginRefreshing()
                videoNeedRefresh = false
            }
        case "用户":
            if liveVM.anchors.isEmpty || friendNeedRefresh {
                friendTableView.mj_header?.beginRefreshing()
                friendNeedRefresh = false
            }
        case "活动":
            if activityVM.dataSource.isEmpty || activityNeedRefresh {
                activityTableView.mj_header?.beginRefreshing()
                activityNeedRefresh = false
            }
        default:
            break
        }
    }
    
    private func request() {
        courseTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestCourse()
        })
        productTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestProduct()
        })
        videoCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.videoVM.page = 1
            self.requestVideo()
        })
        videoCollectionView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.videoVM.page += 1
            self.requestVideo()
        })
        friendTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.liveVM.page = 1
            self.requestFriend()
        })
        friendTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
             self.liveVM.page += 1
            self.requestFriend()
        })
        activityTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.activityVM.pageIndex = 1
            self.requestActivity()
        })
        activityTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.activityVM.pageIndex += 1
            self.requestActivity()
        })
    }
    
    private func requestCourse() {
        courseVM.keyword = vm.keyword
        courseVM.type = "2"
        courseVM.requestProductList {[weak self] (success) in
            self?.courseTableView.mj_header?.endRefreshing()
            self?.courseDataSource.resetData(self?.courseVM.dataSource)
        }
    }
    
    private func requestProduct() {
        productVM.keyword = vm.keyword
        productVM.type = "1"
        productVM.requestProductList {[weak self] (success) in
            self?.productTableView.mj_header?.endRefreshing()
            self?.productDataSource.resetData(self?.productVM.dataSource)
        }
    }
    
    private func requestVideo() {
        videoVM.search = vm.keyword
        videoVM.request { [weak self] (success) in
            self?.videoCollectionView.mj_header?.endRefreshing()
            self?.videoCollectionView.mj_footer?.endRefreshing()
            self?.videoDataSource.resetData(self?.videoVM.dataSource)
        }
    }
    
    private func requestActivity() {
        activityVM.activity_date = "2018-01-01 00:00:00"
        activityVM.keyword = vm.keyword
        activityVM.requestActivity { [weak self] (success) in
            self?.activityTableView.mj_header?.endRefreshing()
            self?.activityTableView.mj_footer?.endRefreshing()
            self?.activityDataSource.resetData(self?.activityVM.dataSource)
        }
    }
    
    private func requestFriend() {
        liveVM.keyword = vm.keyword
        liveVM.requestAnchorList { [weak self] (success) in
            self?.friendTableView.mj_header?.endRefreshing()
            self?.friendTableView.mj_footer?.endRefreshing()
            self?.friendDataSource.resetData(self?.liveVM.anchors)
        }
    }
    
    private func requestAd() {
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_SEARCH") { (items) in
            if let item = items?.first {
                self.ad = item
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        view.endEditing(true)
        if !searchResultView.isHidden {
            resetResultView()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTCityList" {
            let vc = segue.destination as! HTCityListViewController
            vc.complete = { model in
                self.locationBtn.setTitle(model.city_name, for: .normal)
                self.videoVM.city = model.city_name
            }
        }
    }

}

extension HTSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (ad == nil || isCloseAd) ? 2 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return vm.historys.count
        } else if section == 1 {
            return vm.searchHotKeys.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTSearchHistoryCell", for: indexPath) as! HTSearchHistoryCell
            cell.titleLab.text = vm.historys[indexPath.row]
            cell.deleteAction = { text in
                self.vm.delete(text)
                collectionView.reloadSections([0])
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTSearchHotCell", for: indexPath) as! HTSearchHotCell
            cell.model = vm.searchHotKeys[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTAdCollectionCell", for: indexPath) as! HTAdCollectionCell
            cell.img.sd_setImage(with: URL(string: ad!.itemName), completed: nil)
            cell.closeAction = {
                self.isCloseAd = true
                collectionView.deleteSections([indexPath.section])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTSearchHeaderView", for: indexPath) as! HTSearchHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: SCREEN_WIDTH, height: 47)
        } else if indexPath.section == 1 {
            return CGSize(width: SCREEN_WIDTH / 2, height: 47)
        } else {
            return CGSize(width: SCREEN_WIDTH, height: 310)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: SCREEN_WIDTH, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if !ad!.ext.isEmpty {
                HTUtils.share.checkLogin {
                    FYWebViewController.open(self.ad!.ext)
                }
            }
        } else {
            var text = ""
            if indexPath.section == 0 {
                text = vm.historys[indexPath.row]
            } else if indexPath.section == 1 {
                text = vm.searchHotKeys[indexPath.row].keyword
            }
            searchTF.text = text
            searchAction()
        }
    }
}

extension HTSearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            isTapSegment = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            if !isTapSegment {
                segment.process = contentScrollView.contentOffset.x / contentScrollView.contentSize.width
            }
        }
    }
}

extension HTSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }

}
