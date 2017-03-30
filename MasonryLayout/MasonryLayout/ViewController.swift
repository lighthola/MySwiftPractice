//
//  ViewController.swift
//  MasonryLayout
//
//  Created by Bevis Chen on 2017/3/16.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var masonryLayout: MasonryLayout!
    {
        didSet{
            masonryLayout.maxColumns = 2
            masonryLayout.delegate = self
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        }
    }
    
    // MARK:- Variable
    fileprivate var images:[String] = {
        var tmps = [String]()
        var count = 0
        for i in 0 ... 10
        {
            tmps.append("bg-" + String(count))
            count = count == 115 ? 0 : (count + 1)
        }
        return tmps;
    }()
    
    // MARK:- Constant
    
    
    // MARK:-
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loadMore(_ sender: Any)
    {
//        images.append("bg-" + String(images.count))
        var count = images.count
        let min = images.count
        let max = images.count+1
        var newImages = [String]()
        var newIndexs = [IndexPath]()
        for _ in min ... max
        {
            newImages.append("bg-" + String(count))
            newIndexs.append(IndexPath(item: count, section: 0))
            count += 1
            if count >= 115 {
                break
            }
        }
        images.append(contentsOf: newImages)
        collectionView?.insertItems(at: newIndexs)
        //collectionView.reloadData()
    }
    
    // MARK: - memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - MasonryLayoutDelegate
extension ViewController: MasonryLayoutDelegate
{
    func masonryLayout(_ masonryLaout: MasonryLayout, cellHeightForItemAt indexPath: IndexPath) -> CGFloat
    {
        let image = UIImage(named: images[indexPath.row])
        return image!.size.height * masonryLaout.itemWidth / image!.size.width
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageView.image = UIImage(named: self.images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionElementKindSectionHeader
        {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            //view.backgroundColor = UIColor.red
            if view.subviews.count == 0 {
                view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.95)
                let indicator = UIActivityIndicatorView(frame: view.bounds)
                indicator.activityIndicatorViewStyle = .whiteLarge
                indicator.hidesWhenStopped = true
                view.addSubview(indicator)
            }
            return view
        }
        else if kind == UICollectionElementKindSectionFooter
        {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            if view.subviews.count == 0 {
                view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.95)
                let indicator = UIActivityIndicatorView(frame: view.bounds)
                indicator.activityIndicatorViewStyle = .whiteLarge
                indicator.hidesWhenStopped = true
                indicator.startAnimating()
                view.addSubview(indicator)
            }
            
            return view
        }

        fatalError("Unable to Dequeue Reusable Supplementary View")
    }
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate
{
    
}
// MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation: \(scrollView.contentOffset)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging: \(scrollView.contentOffset)")
        
        guard scrollView.contentOffset.y < 0 else {
            return
        }
        
        guard let header = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) else {
            return
        }
        
        if scrollView.contentOffset.y <= header.frame.minY {
            print("Refresh ... ...")
            
            if let indicator = header.subviews.first as? UIActivityIndicatorView
            {
                collectionView.contentInset.top = header.frame.height
                indicator.startAnimating()
                let dispatchTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                    indicator.stopAnimating()
                    self.collectionView.contentInset = .zero
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating: \(scrollView.contentOffset)")

        // pulling to load more when
        if ceil(scrollView.contentOffset.y + scrollView.bounds.height) >= scrollView.contentSize.height {
            self.perform(#selector(loadMore(_:)), with: nil, afterDelay: 2)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll: \(scrollView.contentOffset)")
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop: \(scrollView.contentOffset)")

    }
}








