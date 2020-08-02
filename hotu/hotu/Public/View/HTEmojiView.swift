
//
//  HTEmojiView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTEmojiView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var complete:((String)->Void)?
    
    private var oneView: UIView!
    
    private var dataSource = [String]()
    
    private let cellKey = "HTEmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        oneView = UINib(nibName: "HTEmojiView", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        oneView.frame = bounds
        addSubview(oneView)
        collectionView.register(UINib(nibName: cellKey, bundle: nil), forCellWithReuseIdentifier: cellKey)
        collectionView.delegate = self
        collectionView.dataSource = self
        if let path = Bundle.main.path(forResource: "HTEmoji", ofType: "plist"),
            let arr = NSArray(contentsOfFile: path) {
            dataSource = arr as! [String]
            collectionView.reloadData()
        }
    }

}

extension HTEmojiView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (SCREEN_WIDTH / 7)
        let height: CGFloat = (collectionView.frame.height / 3)
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! HTEmojiCell
        let text = dataSource[indexPath.row]
        cell.emojiLab.text = text
        cell.deleteImg.isHidden = text != "D"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = dataSource[indexPath.row]
        if let c = complete {
            c(text)
        }
    }
}
