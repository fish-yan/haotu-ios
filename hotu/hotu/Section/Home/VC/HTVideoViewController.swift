//
//  HTVideoViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellKey = "HTVideoBigCell"
    
    @IBOutlet weak var backBtn: UIButton!
    
    var vm = HTVideoVM()
    
    var currentIndexPath = IndexPath()
    
    private var timer: Timer?
    
    private var playIndex: Int = -1
    
    private var isDisAppear = false
    
    private var isFixOffset = false
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fixOffset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDisAppear = false
        if let parent = parent as? HTHomeViewController {
            let index = parent.scrollView.contentOffset.x / SCREEN_WIDTH
            if index == 0 {
                play()
            } else {
                resetPlayer()
            }
        } else {
            play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isDisAppear = true
        resetPlayer()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        backBtn.isHidden = vm.dataSource.count == 0
        if vm.dataSource.count == 0 {
            FYLocationUtil.share.startLocation { (p) in
                self.tableView.mj_header?.beginRefreshing()
            }
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                self.vm.page = 1
                self.request()
            })
            tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
                self.vm.page += 1
                self.request()
            })
        } else {
            tableView.alpha = 0
            CATransaction.setCompletionBlock {
                self.tableView.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .top)
                self.tableView.alpha = 1
                self.play()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .HTVideoChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentChanged(_:)), name: .HTCommentChanged, object: nil)
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
    }
    
    @objc private func refresh(_ notification: Notification) {
        if let m = notification.object as? HTVideoModel {
            vm.pubVideoModel = m
        }
        tableView.mj_header?.beginRefreshing()
    }
    
    @objc private func commentChanged(_ notification: Notification) {
        if let count = notification.object as? Int,
            let cell = tableView.cellForRow(at: IndexPath(row: playIndex, section: 0)) as? HTVideoBigCell {
            let model = vm.dataSource[playIndex]
            let commCount = model.commentCount.toInt() + count
            model.commentCount = "\(commCount)"
            cell.commentCountLab.text = model.commentCount
        }
    }
    
    private func request() {
        self.vm.request { (success) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.reloadData()
            self.mainVC?.guidComplete = {
                self.play()
            }
            if self.isDisAppear || self.mainVC?.guideScrollView.isHidden == false || visibleViewController != self {
                return
            }
            self.play()
        }
    }
    
    private func requestFav(model: HTVideoModel) {
        if let index = self.vm.dataSource.firstIndex(of: model),
            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HTVideoBigCell {
            cell.favBtn.isEnabled = false
            vm.requestFav(videoId: model.id, isFav: model.isLike == "0") { (success) in
                cell.favBtn.isEnabled = true
                if success {
                    let count = Int(model.likeCount) ?? 1
                    if model.isLike == "1" {
                        model.isLike = "0"
                        model.likeCount = "\(Swift.max(0, count - 1))"
                    } else {
                        model.isLike = "1"
                        model.likeCount = "\(count + 1)"
                    }
                    cell.favCountLab.text = model.likeCount
                    cell.favBtn.isSelected = model.isLike == "1"
                    NotificationCenter.default.post(name: .HTFavChanged, object: nil)
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func play() {
        if isDisAppear {return}
        let index = lroundf(Float(tableView.contentOffset.y / SCREEN_HEIGHT))
        if vm.dataSource.count > index {
            let model = vm.dataSource[index]
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HTVideoBigCell {
                if model.type == "1" {
                    cell.playerV.play(url: model.url)
                }
                playIndex = index
                vm.requestUpdatePlayCount(videoId: model.id)
                if !model.linkedId.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        cell.showLinkView()
                    }
                }
                fixOffset()
            }
        }
    }
    
    func resetPlayer() {
        if playIndex >= 0 {
            if let cell = tableView.cellForRow(at: IndexPath(row: playIndex, section: 0)) as? HTVideoBigCell {
                cell.playerV.player.resetPlayer()
            }
        }
    }
    
    private func fixOffset() {
        if playIndex >= 0 && playIndex < vm.dataSource.count {
            isFixOffset = true
            tableView.contentOffset = CGPoint(x: 0, y: SCREEN_HEIGHT * CGFloat(playIndex))
        }
        
    }
    
    private func pushToShare(_ model: HTVideoModel) {
        vm.requestGetShare(videoId: model.id) { (url) in
            let vc = FYShareViewController(url, title: "\(model.userNickName) 的动态", des: model.content, img: UIImage(named: "icon_logo"))
            vc.complete = { success in
                self.vm.requestUpdateShareCount(videoId: model.id)
                if let index = self.vm.dataSource.firstIndex(of: model),
                let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HTVideoBigCell {
                    let count = (Int(model.forwardCount) ?? 0) + 1
                    model.forwardCount = "\(count)"
                    cell.shareCountLab.text = model.forwardCount
                }
            }
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTVideoChanged, object: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTComment" {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.topViewController as! HTCommentViewController
            if let m = sender as? HTVideoModel {
                if let index = vm.dataSource.firstIndex(of: m),
                    let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HTVideoBigCell {
                    vc.complete = { index in
                        m.commentCount = "\(index)"
                        cell.commentCountLab.text = "\(index)"
                    }
                }
                vc.vm.videoModel = m
            }
        }
    }

}

extension HTVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTVideoBigCell
        cell.model = vm.dataSource[indexPath.row]
        cell.commentAction = { model in
            self.performSegue(withIdentifier: "HTComment", sender: model)
        }
        cell.favAction = { model in
            HTUtils.share.checkLogin {
                self.requestFav(model: model)
            }
        }
        cell.shareAction = { model in
            self.pushToShare(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let c = cell as? HTVideoBigCell {
            c.playerV.player.resetPlayer()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isFixOffset = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isFixOffset {return}
        timer?.invalidate()
        timer = nil
        if isDisAppear || tableView.mj_footer?.isRefreshing == true {return}
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(play), userInfo: nil, repeats: false)
    }
    
}

