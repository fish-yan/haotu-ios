//
//  HTMVideoDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoSmallDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private let cellKey = "HTVideoSmallCell"
    
    private var dataSource: [HTVideoModel] = []
    
    private var collectionView: UICollectionView!
    
    var type: HTVideoSmallCellType = .like
    
    var didSelectRow: ((IndexPath, HTVideoModel)->Void)?
    
    init(_ collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        configCollectionView()
    }
    
    private func configCollectionView() {
        collectionView.backgroundColor = UIColor(hex: 0xF7F7F7)
        collectionView.register(UINib(nibName: cellKey, bundle: nil), forCellWithReuseIdentifier: cellKey)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func resetData(_ data: [HTVideoModel]?) {
        if let d = data {
            dataSource = d
        }
        collectionView.reloadData()
    }
        
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! HTVideoSmallCell
        cell.type = type
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTVideoViewController") as! HTVideoViewController
        vc.vm.dataSource = dataSource
        vc.currentIndexPath = indexPath
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }

}

