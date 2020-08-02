//
//  HTMineViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMineViewController: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var superScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var muClubV: UIView!
    @IBOutlet weak var applyToBtn: UIButton!
    
    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var topImgV: UIImageView!
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var authImgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var favCountLab: UILabel!
    @IBOutlet weak var attentionCountLab: UILabel!
    @IBOutlet weak var funsCountLab: UILabel!
    @IBOutlet weak var signatureLab: UILabel!
    
    @IBOutlet weak var titLab: UILabel!
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewTop: NSLayoutConstraint!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var firstTableView: UITableView!
    
    private var firstDataSource: HTProductDataSource!
    private var videoDataSource: HTVideoSmallDataSource!
    private var liveDataSource: HTVideoSmallDataSource!
    private var favDataSource: HTVideoSmallDataSource!
    private var activityDataSource: HTActivityDataSource!
    
    var mineVM = HTMineVM()
    private var myProductVM = HTProductVM()
    private var activityVM = HTActivityVM()
    private var myVideoVM = HTVideoVM()
    private var myFavVideoVM = HTVideoVM()
    private var myAnchorVM = HTLiveVM()
    
    private var courseNeedRefresh = false
    private var productNeedRefresh = false
    private var activityNeedRefresh = false
    private var videoNeedRefresh = false
    private var liveNeedRefresh = false
    private var faveNeedRefresh = false
    
    private var isTapSegment = false
    private var isAnimate = true
    
    private var vArr = [UIScrollView]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if mineVM.userId.isEmpty {
            leftBtn.setImage(UIImage(named: "icon_menu"), for: .normal)
            mainVC?.scrollView.isScrollEnabled = true
            attentionBtn.isHidden = true
            requestUserInfoChanged()
        } else {
            leftBtn.setImage(UIImage(named: "icon_back"), for: .normal)
            mainVC?.scrollView.isScrollEnabled = false
            attentionBtn.isHidden = mineVM.userId == HTUserInfo.share.userId
            requestRoleChanged()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        mainVC?.scrollView.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configUserView()
        request()
        if mineVM.userId.isEmpty {
            configDataView()
            self.firstRequest()
        }
        addNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let minHeight = superScrollView.frame.height - 44 - navHeight.constant
        let height = Swift.max(minHeight, vArr[segment.selectedIndex].contentSize.height)
        if height != contentScrollViewHeight.constant {
            contentScrollViewHeight.constant = height
        }
        self.contentScrollViewTop.constant = self.topView.frame.height
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestRoleChanged), name: .HTRoleChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestUserInfoChanged), name: .HTUserInfoChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshVideo), name: .HTVideoChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCourse), name: .HTCourseChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProduct), name: .HTProductChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLive), name: .HTLiveChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFav), name: .HTFavChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshActivtiy), name: .HTActivityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshActivtiy), name: .HTMatchChanged, object: nil)
    }
    
    private func configView() {
        vArr = [videoCollectionView, favCollectionView]
        if let img = HTFileUtil.getImage(name: "headerImg.png"),
            mineVM.userId.isEmpty {
            topImgV.image = img
        } else {
            topImgV.image = UIImage(named: "bg_user_center")
        }
        navHeight.constant = UIApplication.shared.statusBarFrame.height + 44
//        contentScrollViewTop.constant = SCREEN_WIDTH * 137 / 275 + 190
        CATransaction.setCompletionBlock {
            self.contentScrollViewTop.constant = self.topView.frame.height
        }
        
        firstDataSource = HTProductDataSource(firstTableView)
        videoDataSource = HTVideoSmallDataSource(videoCollectionView)
        videoDataSource.type = mineVM.userId.isEmpty ? .play : .like
        liveDataSource = HTVideoSmallDataSource(liveCollectionView)
        liveDataSource.type = .see
        liveDataSource.didSelectRow = { (indexpath, model) in
            HTUtils.share.checkLogin {
                self.performSegue(withIdentifier: "HTLiveDetail", sender: model)
            }
        }
        favDataSource = HTVideoSmallDataSource(favCollectionView)
        activityDataSource = HTActivityDataSource(activityTableView)
    }
    
    private func configUserView() {
        if mineVM.userId.isEmpty {
            mineVM.memberInfo.userLogo = HTUserInfo.share.headerImg
            mineVM.memberInfo.nick_name = HTUserInfo.share.userName
            mineVM.memberInfo.roleCode = HTUserInfo.share.role
            mineVM.memberInfo.isRealName = HTUserInfo.share.isReal ? "1" : "0"
            leftBtn.setImage(UIImage(named: "icon_menu"), for: .normal)
            mainVC?.scrollView.isScrollEnabled = true
            attentionBtn.isHidden = true
        } else {
            leftBtn.setImage(UIImage(named: "icon_back"), for: .normal)
            attentionBtn.isHidden = mineVM.userId == HTUserInfo.share.userId
            switch mineVM.memberInfo.status {
            case "0": // 未关注
                attentionBtn.isSelected = false
            case "1": // 我关注的
                attentionBtn.isSelected = true
                attentionBtn.setTitle("已关注", for: .selected)
            case "2": // 粉丝
                attentionBtn.isSelected = false
            case "3": // 互相关注
                attentionBtn.isSelected = true
                attentionBtn.setTitle("互相关注", for: .selected)
            default:
                break
            }
        }
        headImgV.sd_setImage(with: URL(string: mineVM.memberInfo.userLogo), completed: nil)
        authImgV.isHidden = mineVM.memberInfo.isRealName == "0"
        nameLab.text = mineVM.memberInfo.nick_name
        if mineVM.memberInfo.autograph.isEmpty {
            signatureLab.text = "Ta暂时还没有想到个性签名"
            signatureLab.textColor = UIColor(hex: 0xCECECE)
        } else {
            signatureLab.text = mineVM.memberInfo.autograph
            signatureLab.textColor = .black
        }
        
        favCountLab.text = mineVM.memberInfo.likedNo
        attentionCountLab.text = mineVM.memberInfo.followersNo
        funsCountLab.text = mineVM.memberInfo.fansNo
    }
    
    private func configDataView() {
        firstTableView.isHidden = true
        liveCollectionView.isHidden = true
        activityTableView.isHidden = true
        if mineVM.userId.isEmpty {
            segment.titleArray = ["活动", "视频", "直播", "点赞"]
            liveCollectionView.isHidden = false
            activityTableView.isHidden = false
            vArr = [activityTableView, videoCollectionView, liveCollectionView, favCollectionView]
        } else {
            segment.titleArray = ["视频", "直播", "点赞"]
            liveCollectionView.isHidden = false
            vArr = [videoCollectionView, liveCollectionView, favCollectionView]
        }
        /*
        switch mineVM.memberInfo.roleCode {
        case .visitor, .normal:
            segment.titleArray = ["视频", "点赞"]
            vArr = [videoCollectionView, favCollectionView]
        case .anchor:
            segment.titleArray = ["视频", "直播", "点赞"]
            liveCollectionView.isHidden = false
            vArr = [videoCollectionView, liveCollectionView, favCollectionView]
        case .coach:
            segment.titleArray = ["课程", "视频", "直播", "点赞"]
            firstTableView.isHidden = false
            liveCollectionView.isHidden = false
            vArr = [firstTableView, videoCollectionView, liveCollectionView, favCollectionView]
        case .merc:
            segment.titleArray = ["商品", "视频", "直播", "点赞"]
            firstTableView.isHidden = false
            liveCollectionView.isHidden = false
            vArr = [firstTableView, videoCollectionView, liveCollectionView, favCollectionView]
        case .club:
            segment.titleArray = ["活动", "视频", "直播", "点赞"]
            liveCollectionView.isHidden = false
            activityTableView.isHidden = false
            vArr = [activityTableView, videoCollectionView, liveCollectionView, favCollectionView]
        case .all:
            segment.titleArray = ["课程", "活动",  "视频", "直播", "点赞"]
             vArr = [firstTableView, activityTableView, videoCollectionView, liveCollectionView, favCollectionView]
            firstTableView.isHidden = false
            liveCollectionView.isHidden = false
            activityTableView.isHidden = false
         }
         */
        applyToBtn.isHidden = true
        muClubV.isHidden = true
        switch HTUserInfo.share.role {
        case .normal, .anchor:
            applyToBtn.isHidden = false
        case .club, .coach, .merc:
            muClubV.isHidden = false
        default:break
        }
        segment.selectAction = { index in
            self.isTapSegment = true
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self.viewDidLayoutSubviews()
            self.firstRequest()
        }
    }
    
    @objc private func requestRoleChanged() {
        if HTUserInfo.share.role == .visitor && mineVM.userId.isEmpty {
            configUserView()
            return
        }
        mineVM.requestUserCount { (success) in
            self.configUserView()
            self.configDataView()
            self.courseNeedRefresh = true
            self.productNeedRefresh = true
            self.activityNeedRefresh = true
            self.videoNeedRefresh = true
            self.liveNeedRefresh = true
            self.faveNeedRefresh = true
            self.firstRequest()
        }
    }
    
    @objc private func requestUserInfoChanged() {
        mineVM.requestUserCount { (success) in
            self.configUserView()
        }
    }
    
    @objc private func refreshVideo() {
        videoNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshProduct() {
        productNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshCourse() {
        courseNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshActivtiy() {
        activityNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshLive() {
        liveNeedRefresh = true
        firstRequest()
    }
    
    @objc private func refreshFav() {
        faveNeedRefresh = true
        firstRequest()
    }
    
    private func firstRequest() {
        switch segment.titleArray[segment.selectedIndex] {
        case "课程":
            if myProductVM.dataSource.isEmpty || courseNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                courseNeedRefresh = false
            }
        case "商品":
            if myProductVM.dataSource.isEmpty || productNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                productNeedRefresh = false
            }
        case "视频":
            if myVideoVM.dataSource.isEmpty || videoNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                videoNeedRefresh = false
            }
        case "直播":
            if myAnchorVM.dataSource.isEmpty || liveNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                liveNeedRefresh = false
            }
        case "点赞":
            if myFavVideoVM.dataSource.isEmpty || faveNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                faveNeedRefresh = false
            }
        case "活动":
            if activityVM.dataSource.isEmpty || activityNeedRefresh {
                superScrollView.mj_header?.beginRefreshing()
                activityNeedRefresh = false
            }
        default:
            break
        }
        isAnimate = true
    }
    
    private func request() {
        let mj_header = MJRefreshNormalHeader(refreshingBlock: {
            switch self.segment.titleArray[self.segment.selectedIndex] {
            case "商品":
                self.requestProduct(type: "1")
            case "课程":
                self.requestProduct(type: "2")
            case "视频":
                self.requestMyVideoList()
            case "直播":
                self.requestMyAnchorList()
            case "点赞":
                self.requestMyFavVideoList()
            case "活动":
                self.activityVM.pageIndex = 1
                self.requestActivity()
            default:
                break
            }
        })
        CATransaction.setCompletionBlock {
            mj_header.ignoredScrollViewContentInsetTop = -self.topView.frame.height
        }
        self.superScrollView.mj_header = mj_header
        self.superScrollView.mj_footer = MJRefreshBackStateFooter {
            switch self.segment.titleArray[self.segment.selectedIndex] {
            case "活动":
                self.activityVM.pageIndex += 1
                self.requestActivity()
            default:
                self.superScrollView.mj_footer?.endRefreshing()
                break
            }
        }
    }
    
    private func requestProduct(type: String) {
        myProductVM.userId = mineVM.userId
        myProductVM.requestProducts { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.firstDataSource.resetData(self?.myProductVM.dataSource)
        }
    }
    
    private func requestActivity() {
        activityVM.type = "99"
        activityVM.userId = mineVM.userId
        activityVM.requestMySignActivity { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.superScrollView.mj_footer?.endRefreshing()
            self?.activityDataSource.resetData(self?.activityVM.dataSource)
            CATransaction.setCompletionBlock {
                self?.viewDidLayoutSubviews()
            }
        }
    }
    
    private func requestMyVideoList() {
        myVideoVM.userId = mineVM.userId
        myVideoVM.requestMyVideoList { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.videoDataSource.resetData(self?.myVideoVM.dataSource)
        }
    }
    
    private func requestMyAnchorList() {
        myAnchorVM.userId = mineVM.userId
        myAnchorVM.requestLiveList { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.liveDataSource.resetData(self?.myAnchorVM.dataSource)
        }
    }
    
    private func requestMyFavVideoList() {
        myFavVideoVM.userId = mineVM.userId
        myFavVideoVM.requestMyFavVideoList { [weak self] (success) in
            self?.superScrollView.mj_header?.endRefreshing()
            self?.favDataSource.resetData(self?.myFavVideoVM.dataSource)
        }
    }
    
    @IBAction func setAction(_ sender: UIButton) {
        if mineVM.userId.isEmpty {
            if let m = mainVC {
                if m.isShow {
                    m.hiddenSetView()
                } else {
                    m.showSetView()
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func attentionAction(_ sender: UIButton) {
        HTUtils.share.checkLogin {
            if !self.mineVM.userId.isEmpty {
                let api = !sender.isSelected ? ATTENTION_USER : CANCEL_ATTENTION
                let params = ["followerUserId": self.mineVM.userId]
                FYNetWork.request(api, params: params).responseJSON { (response: HTBaseModel<String>) in
                    sender.isSelected = !sender.isSelected
                }
            }
        }
    }

    @IBAction func topImgChangeAction(_ sender: UIButton) {
        guard mineVM.userId.isEmpty else {return}
        HTImagePickerUtil.share.pickerPhoto { (img) in
            self.topImgV.image = img
            HTFileUtil.save(image: img, name: "headerImg.png")
        }
    }
    @IBAction func shareAction(_ sender: Any) {
        var id = ""
        if mineVM.userId.isEmpty {
            id = HTUserInfo.share.userId
        } else {
            id = mineVM.userId
        }
        HTShareQrCodeViewController.show(id, type: "1")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let height = SCREEN_WIDTH * 137 / 375 - 100
        if superScrollView.contentOffset.y >= height {
            self.titLab.text = HTUserInfo.share.userName
            return .default
        } else {
            self.titLab.text = ""
            return .lightContent
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTUserInfoEdit" {
            let vc = segue.destination as! HTUserInfoEditViewController
            vc.signText = mineVM.memberInfo.autograph
        } else if segue.identifier == "HTLiveDetail" {
            let vc = segue.destination as! HTLiveDetailViewController
            if let model = sender as? HTVideoModel {
                vc.vm.activityId = model.activityId
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTUserInfoChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTRoleChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTVideoChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTActivityChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTMatchChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTProductChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTCourseChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTFavChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTLiveChanged, object: nil)
    }

}

extension HTMineViewController: UIScrollViewDelegate {
    
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
