//
//  HTClubDetail2ViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/24.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTClubDetail2ViewController: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var superScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var authImgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var titLab: UILabel!
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewTop: NSLayoutConstraint!
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet private var photosImgV: [UIImageView]!
    @IBOutlet weak var memberCountLab: UILabel!
    
    var clubVM = HTClubVM()
    
    private var liveNeedRefresh = false
    private var activityNeedRefresh = false
    
    private var isTapSegment = false
    private var isAnimate = true
    
    private let cellKey = "HTVideoSmallCell"
    
    
    private var vArr = [UIScrollView]()
    
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
        request()
        firstRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshActivtiy), name: .HTActivityChanged, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let minHeight = superScrollView.frame.height - 44 - navHeight.constant
        let height = Swift.max(minHeight, vArr[segment.selectedIndex].contentSize.height)
        if height != contentScrollViewHeight.constant {
            contentScrollViewHeight.constant = height
        }
    }
    
    
    private func configView() {
        addBtn.isHidden = [HTRoleType.anchor, HTRoleType.normal, HTRoleType.visitor].contains(HTUserInfo.share.role)
        liveCollectionView.register(UINib(nibName: cellKey, bundle: nil), forCellWithReuseIdentifier: cellKey)
        liveCollectionView.register(UINib(nibName: "HTClubLiveHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTClubLiveHeaderView")
        vArr = [liveCollectionView, activityTableView]
        navHeight.constant = UIApplication.shared.statusBarFrame.height + 44
        contentScrollViewTop.constant = 137.0/275.0 * SCREEN_WIDTH + 158
        segment.titleArray = ["群相册", "活动"]
        segment.selectAction = { index in
            self.isTapSegment = true
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self.viewDidLayoutSubviews()
            self.firstRequest()
        }
    }
    
    private func configClubInfoView() {
        headImgV.sd_setImage(with: URL(string: clubVM.model.group_logo), completed: nil)
        nameLab.text = clubVM.model.group_name
        memberCountLab.text = "\(clubVM.model.group_member_images.count)"
        let maxCount = Int((SCREEN_WIDTH - 96) / 38)
        for (i, imgV) in photosImgV.enumerated() {
            if i < clubVM.model.group_member_images.count && i < maxCount {
                let url = clubVM.model.group_member_images[i].userLogo
                imgV.sd_setImage(with: URL(string: url), completed: nil)
            } else {
                imgV.image = UIImage()
            }
        }
    }
    
    @objc private func refreshlive() {
        liveNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshActivtiy() {
        activityNeedRefresh = true
        firstRequest()
    }
    
    
    private func firstRequest() {
        switch segment.titleArray[segment.selectedIndex] {
        case "群相册":
            if clubVM.clubLiveList.isEmpty || liveNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                liveNeedRefresh = false
            }
        case "活动":
            if clubVM.clubAcList.isEmpty || activityNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                activityNeedRefresh = false
            }
        default:
            break
        }
        isAnimate = true
    }
    
    private func request() {
        clubVM.requestClubInfo { (success) in
            self.configClubInfoView()
        }
        
        let mj_header = MJRefreshNormalHeader(refreshingBlock: {
            switch self.segment.titleArray[self.segment.selectedIndex] {
            case "群相册":
                self.clubVM.pageIndex = 1
                self.requestLiveList()
            case "活动":
                self.requestActivity()
            default:
                break
            }
        })
        let h = 137.0/275.0 * SCREEN_WIDTH + 158
        mj_header.ignoredScrollViewContentInsetTop = -h
        self.superScrollView.mj_header = mj_header
        self.superScrollView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            switch self.segment.titleArray[self.segment.selectedIndex] {
            case "群相册":
                self.clubVM.pageIndex += 1
                self.requestLiveList()
            default:
                self.superScrollView.mj_footer?.endRefreshing()
                break
            }
        })
    }
    
    private func requestLiveList() {
        clubVM.requestClubLive { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.superScrollView.mj_footer?.endRefreshing()
            self?.liveCollectionView.reloadData()
            CATransaction.setCompletionBlock {
                self?.viewDidLayoutSubviews()
            }
        }
    }
    
    private func requestActivity() {
        clubVM.requestClubActivity { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.activityTableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let height = SCREEN_WIDTH * 137 / 375 - 100
        if superScrollView.contentOffset.y >= height {
            self.titLab.text = clubVM.model.group_name
            return .default
        } else {
            self.titLab.text = ""
            return .lightContent
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        switch HTUserInfo.share.role {
        case .club: // 活动
            HTUtils.share.checkVitified {
                self.performSegue(withIdentifier: "HTPublishActivity", sender: nil)
            }
        case .coach: // 课程
            HTUtils.share.checkVitified {
                self.performSegue(withIdentifier: "HTPublishCourse", sender: nil)
            }
        case .merc: // 商品
            HTUtils.share.checkVitified {
                self.performSegue(withIdentifier: "HTPublishProduct", sender: nil)
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTClubMember" {
            let vc = segue.destination as! HTClubMemberViewController
            vc.clubVM.model.group_id = clubVM.model.group_id
            vc.type = HTMemberListType.group
        } else if segue.identifier == "FYMenu" {
            let vc = segue.destination as! FYMenuViewController
            vc.popoverPresentationController?.delegate = self
            vc.dataArr = ["好兔二维码", "分享连接"]
            vc.complete = { text in
                if text == "好兔二维码" {
                    HTShareQrCodeViewController.show(self.clubVM.model.group_id, type: "2")
                } else if text == "分享连接" {
                    HTAppVM.share.requestShareUrl(self.clubVM.model.group_id, type: "2") { (model) in
                        let vc = FYShareViewController(model.shareUrl, title: model.name , des: model.remark, img: UIImage(named: "icon_logo"))
                        vc.type = .live
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTActivityChanged, object: nil)
    }
    
}

extension HTClubDetail2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clubVM.clubAcList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubVM.clubAcList[section].activityBasics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTClubAcCell") as! HTClubAcCell
        let model = clubVM.clubAcList[indexPath.section].activityBasics[indexPath.row]
        model.weekDay = clubVM.clubAcList[indexPath.section].weekDay
        cell.model = model
        cell.weekLab.isHidden = indexPath.row != 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = clubVM.clubAcList[indexPath.section].activityBasics[indexPath.row]
        let story = UIStoryboard(name: "Home", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HTActivityDetailViewController") as! HTActivityDetailViewController
        vc.vm.model.activityId = model.activityId
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HTClubDetail2ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = SCREEN_WIDTH / 3
        return CGSize(width: width, height: width / 125 * 166)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return clubVM.clubLiveList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let m = clubVM.clubLiveList[section]
        if m.isSelected {
            return m.archorImageDtos.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! HTVideoSmallCell
        cell.type = .like
        let model = clubVM.clubLiveList[indexPath.section].archorImageDtos[indexPath.row]
        cell.setClubLiveModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTClubLiveHeaderView", for: indexPath) as! HTClubLiveHeaderView
        header.model = clubVM.clubLiveList[indexPath.section]
        header.complete = {
            collectionView.reloadSections([indexPath.section])
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = clubVM.clubLiveList[indexPath.section]
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
        vc.vm.activityId = model.activityId
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HTClubDetail2ViewController: UIScrollViewDelegate {
    
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
        } else if scrollView == superScrollView {
            let height = SCREEN_WIDTH * 137 / 375
            navView.backgroundColor = UIColor(white: 1, alpha: superScrollView.contentOffset.y / height)
            setNeedsStatusBarAppearanceUpdate()
            if superScrollView.contentOffset.y >= height {
                self.titLab.text = clubVM.model.group_name
            } else {
                self.titLab.text = ""
            }
            let topHeight = topView.frame.height - 44 - navHeight.constant
            let offsetY = superScrollView.contentOffset.y
            if offsetY < 0 {
                topViewTop.constant = offsetY
                if offsetY == -54 {
                    UIView.animate(withDuration: 0.45) {
                        self.view.layoutIfNeeded()
                    }
                }
                
            } else if offsetY < topHeight {
                isAnimate = false
                self.topViewTop.constant = 0
                UIView.animate(withDuration: 0.45) {
                    self.view.layoutIfNeeded()
                }
            } else {
                topViewTop.constant = offsetY - topHeight
            }
        }
        
    }
    
}

extension HTClubDetail2ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

