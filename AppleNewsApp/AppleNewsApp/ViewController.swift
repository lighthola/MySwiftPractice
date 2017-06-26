//
//  ViewController.swift
//  AppleNewsApp
//
//  Created by Bevis Chen on 2017/6/26.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: AppleNewsFlowLayout! {
        didSet {
            flowLayout.delegate = self
        }
    }
    
    var newsArray = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<5 {
            var cellType: NewsCellType = .big
            
            switch i {
            case 0:
                cellType = .big
            case 1, 2:
                cellType = .horizontal
            case 3, 4:
                cellType = .vertical
            default:
                fatalError("error")
            }
            
            let news = News(image: "news_image", provider: "TIME", title: "12 billion gallons of water pour into Lake Tahoe amid this week's hear wave", cellType: cellType)
            newsArray.append(news)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: AppleNewsFlowLayoutDelegate {
    func AppleNewsFlowLayout(_ AppleNewsFlowLayout: AppleNewsFlowLayout, cellTypeForItemAt indexPath: IndexPath) -> NewsCellType {
        
        return newsArray[indexPath.row].cellType
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let news = newsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: news.cellType.rawValue, for: indexPath) as! NewsCell
        cell.image.image = UIImage(named: news.image)!
        cell.provider.text = news.provider
        cell.title.text = news.title
        return cell
    }
}
