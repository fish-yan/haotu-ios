//
//  HTCityListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/13.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCityListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = [HTCityListMdoel]()
    
    var allCitys = [HTCityModel]()
    
    var key = ""
    
    var complete:((HTCityModel)->Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        if let path = Bundle.main.path(forResource: "CityData", ofType: "plist") {
            let arr = NSArray(contentsOfFile: path)
            if let d = [HTCityListMdoel].deserialize(from: arr) as? [HTCityListMdoel] {
                dataSource = d
                if let local = filter(cityNm: HTUserInfo.share.city) {
                    dataSource[0].citys = [local]
                }
                allCitys = [HTCityModel]()
                dataSource.forEach { (listModel) in
                    if listModel.initial != "热门城市" && listModel.initial != "定位城市" {
                        allCitys += listModel.citys
                    }
                }
                collectionView.reloadData()
            }
        }
    }
    
    private func search() {
        if key.isEmpty {
            loadData()
        } else {
            
            let filterCitys = allCitys.filter({
                $0.city_name.contains(key) ||
                    $0.city_key.contains(key) ||
                    $0.pinyin.contains(key) ||
                    $0.short_name.contains(key) ||
                    $0.initials.contains(key)
            })
            let cityListModel = HTCityListMdoel()
            cityListModel.initial = ""
            cityListModel.citys = filterCitys
            dataSource = [cityListModel]
            collectionView.reloadData()
        }
    }
    
    private func filter(cityNm: String) -> HTCityModel? {
        var city: HTCityModel?
        dataSource.forEach { (list) in
            if let c = list.citys.filter({$0.city_name == cityNm}).first {
                city = c
                return
            }
        }
        return city
    }
    
    @IBAction func searchChanged(_ sender: UITextField) {
        key = sender.text ?? ""
        search()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HTCityListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section >= 2 || dataSource.count == 1 {
            return CGSize(width: SCREEN_WIDTH - 40, height: 40)
        } else {
            return CGSize(width: (SCREEN_WIDTH-60)/3, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].citys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HTCityCell", for: indexPath) as! HTCityCell
        let model = dataSource[indexPath.section].citys[indexPath.row]
        cell.titleLab.text = model.city_name
        if indexPath.section >= 2 || dataSource.count == 1 {
            cell.backgroundColor = .white
            cell.titleLab.textAlignment = .left
        } else {
            cell.backgroundColor = UIColor(hex: 0xF7F7F7)
            cell.titleLab.textAlignment = .center
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCityHeaderView", for: indexPath) as! HTCityHeaderView
        headerView.titleLab.text = dataSource[indexPath.section].initial
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataSource[section].initial.isEmpty {
            return CGSize.zero
        } else {
            return CGSize(width: SCREEN_WIDTH, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.section].citys[indexPath.row]
        if let c = complete {
            c(model)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
