//
//  HTVideoBigCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoBigCell: UITableViewCell {
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var playerV: HTPlayerView!
    @IBOutlet weak var headerImgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var livingBtn: UIButton!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var favCountLab: UILabel!
    @IBOutlet weak var commentCountLab: UILabel!
    @IBOutlet weak var shareCountLab: UILabel!
    
    @IBOutlet weak var cHeaderImgV: UIImageView!
    @IBOutlet weak var cTitleLab: UILabel!
    @IBOutlet weak var cDesLab: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var commentAction: ((HTVideoModel)->Void)?
    
    var favAction: ((HTVideoModel)->Void)?
        
    var shareAction:  ((HTVideoModel)->Void)?
        
    private let cellKey = "HTVideoImageCell"
    
    var model = HTVideoModel() {
        didSet {
            headerImgV.sd_setImage(with: URL(string: model.userImageUrl), completed: nil)
            nameLab.text = "@" + model.userNickName
            desLab.attributedText = model.content.toAttContent()
            favCountLab.text = model.likeCount
            commentCountLab.text = model.commentCount
            shareCountLab.text = model.forwardCount
            favBtn.isSelected = model.isLike == "1"
            if model.type == "1" { // 视频
                playerV.coverUrl = model.coverUrl
                playerV.isHidden = false
                collectionView.isHidden = true
            } else { // 图片
                playerV.coverUrl = ""
                playerV.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
            }
            cHeaderImgV.sd_setImage(with: URL(string: model.linkedImage), completed: nil)
            cTitleLab.text = model.linkedTitle
            if model.linkedType == "3" { // 活动
                cDesLab.text = "最新活动信息点击查看"
            } else {
                cDesLab.text = "最新信息点击查看"
            }
            leading.constant = -505
            livingBtn.isHidden = model.isLiveBroadCast == "0"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottom.constant = UIApplication.shared.statusBarFrame.height == 20 ? 64 : 103
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HTVideoImageCell.classForCoder(), forCellWithReuseIdentifier: cellKey)
        if UMSocialManager.default()?.isInstall(.QQ) == false && !WXApi.isWXAppInstalled() {
            shareView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showLinkView() {
        leading.constant = -20
        UIView.animate(withDuration: 0.5) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    
    @IBAction func headerAction(_ sender: UIButton) {
        if livingBtn.isHidden {
            let story = UIStoryboard(name: "Mine", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "HTMineViewController") as! HTMineViewController
            vc.hidesBottomBarWhenPushed = true
            vc.mineVM.userId = model.userId
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        } else {
            livingAction(nil)
        }
        
    }
    
    @IBAction func favAction(_ sender: UIButton) {
        if let fav = favAction {
            fav(model)
        }
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        if let com = commentAction {
            com(model)
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if let share = shareAction {
            share(model)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton?) {
        leading.constant = -505
        UIView.animate(withDuration: 0.5) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    @IBAction func pushBtnAction(_ sender: UIButton) {
        switch model.linkedType {
        case "1", "2", "4", "5": // 商户 教练 俱乐部
             let story = UIStoryboard(name: "Mine", bundle: nil)
                   let vc = story.instantiateViewController(withIdentifier: "HTMineViewController") as! HTMineViewController
                   vc.hidesBottomBarWhenPushed = true
                   vc.mineVM.userId = model.linkedId
             visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        case "3": // 活动
            let story = UIStoryboard(name: "Home", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "HTMatchDetailViewController") as! HTMatchDetailViewController
            vc.vm.model.activityId = model.linkedId
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    @IBAction func livingAction(_ sender: UIButton?) {
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
        vc.vm.activityId = model.liveBroadCastActivityId
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func jubaoAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTReportViewController") as! HTReportViewController
        vc.hidesBottomBarWhenPushed = true
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HTVideoBigCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! HTVideoImageCell
        let mo = model.imageUrls[indexPath.row]
        cell.imgUrl = mo.url
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
}
