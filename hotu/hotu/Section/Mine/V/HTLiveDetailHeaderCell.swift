//
//  HTLiveDetailHeaderCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLiveDetailHeaderCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: FYScrollView!
    @IBOutlet weak var seeCountLab: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var headerSuperV: UIView!
    @IBOutlet var imgVs: [UIImageView]!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var segment: FYSegment!
    
    var ad: HTItemModel?
    
    var selectAction: ((_ index: Int) -> Void)? {
        didSet {
            segment.selectAction = selectAction
        }
    }

    var headers = [HTMemberModel]() {
        didSet {
            let headerImgs = headers.map({$0.userLogo})
            headerSuperV.isHidden = headerImgs.isEmpty
            let maxCount = Int((SCREEN_WIDTH - 74) / 38)
            for (i, imgV) in imgVs.enumerated() {
                if i < headerImgs.count && i < maxCount {
                    let url = headerImgs[i]
                    imgV.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    imgV.image = UIImage()
                }
            }
        }
    }
    
    var imgs = [String]() {
        didSet {
            scrollView.imgArray = imgs
            pageControl.numberOfPages = imgs.count
            scrollView.pageChange = { index in
                self.pageControl.currentPage = index
            }
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        let vc = HTMemberListViewController()
        vc.type = 0
        vc.title = "主播"
        vc.dataSource = headers
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        segment.titleArray = ["热门","照片", "视频"]
        segment.titleArray = ["照片","热门"]
        
    }
}
