//
//  SwipeTabBarControllerViewController.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/11.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeTabBarControllerViewController: UIViewController {
    
    var viewControllers: [UIViewController]
    var collectionView: UICollectionView!
    var tabBar: SwipeTabBar
    
    var selectedIndex: Int = 0
    // MARK: - private var
    private var dragBeginPosition: CGFloat = 0.0
    private var dragChangedPosition: CGFloat = 0.0
    
    // MARK: - override var
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: -
    init(itemTuples: [(UIViewController, UIImage, String)], selectedIndex: Int) {
        guard itemTuples.isEmpty == false else {
            fatalError("init(itemTuples:selectedIndex:) first argument can't be empty.")
        }
        guard selectedIndex >= 0 && selectedIndex < itemTuples.count else {
            fatalError("init(itemTuples:selectedIndex:) second argument can't be outside range of first argument.")
        }
        
        self.viewControllers = itemTuples.map{ $0.0 }
        let swipeItems = itemTuples.enumerated().map { (arg) -> SwipeItem in
            let (index, itemTuple) = arg
            return SwipeItem(image: itemTuple.1, title: itemTuple.2, isBig: index == selectedIndex)
        }
        tabBar = SwipeTabBar(items: swipeItems)
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setTabBar()
        
        for contentVC in viewControllers {
            addChildViewController(contentVC)
            didMove(toParentViewController: contentVC)
        }
        
        for i in 0..<viewControllers.count {
            let label = UILabel()
            label.text  = "\(i)"
            label.font = UIFont.systemFont(ofSize: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
            let consH = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: viewControllers[i].view, attribute: .centerX, multiplier: 1, constant: 0)
            let consV = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: viewControllers[i].view, attribute: .centerY, multiplier: 1, constant: 0)
            viewControllers[i].view.addSubview(label)
            viewControllers[i].view.addConstraint(consH)
            viewControllers[i].view.addConstraint(consV)
            viewControllers[i].view.backgroundColor = UIColor.brown
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func itemOnSelected(item: Int) {
        selectedIndex = item
        collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SwipeTabBarControllerViewController {
    private func setCollectionView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(UINib(nibName: "SwipeContentCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2980392157, blue: 0.3764705882, alpha: 1)
        
        // layout
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let vslHC = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView])
        let vslVC = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]", options: [], metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(vslHC)
        view.addConstraints(vslVC)
        
        // add Horizontal inset for properly animating bounces edge.
        collectionView.decelerationRate = 0
        let hInset = view.bounds.width * 0.1
        collectionView.contentInset = UIEdgeInsets(top: 0, left: -hInset, bottom: 0, right: -hInset)
        
        // add pan gesture for properly animating uicollectionView
        let pan = UIPanGestureRecognizer(target:self , action: #selector(panAction(pan:)))
        pan.delegate = self
        collectionView.addGestureRecognizer(pan)
    }
    
    private func setTabBar() {
        // layout
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        let vslHT = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabBar]|", options: [], metrics: ["width": view.frame.width], views: ["tabBar": tabBar])
        let vslVT = NSLayoutConstraint.constraints(withVisualFormat: "V:[collectionView][tabBar(70)]|", options: [], metrics: nil, views: ["collectionView": collectionView,"tabBar":tabBar])
        view.addConstraints(vslHT)
        view.addConstraints(vslVT)
        
        // Action
        tabBar.itemOnSelected = itemOnSelected
    }
}

extension SwipeTabBarControllerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SwipeContentCell
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let contentView = viewControllers[indexPath.item].view
        contentView?.frame = cell.contentView.bounds
        cell.contentView.addSubview(contentView!)
        
        let red = (CGFloat(indexPath.item) + 1) * 0.18
        contentView?.backgroundColor = UIColor(white: 0.9, alpha: red)
        
        if indexPath.item == 0 {
            cell.isShowRightShadow = true
            cell.isShowLeftOutsideShadow = true
        }
        else if indexPath.item == tabBar.items.count - 1 {
            cell.isShowRightShadow = false
            cell.isShowRightOutsideShadow = true
        }
        else {
            cell.isShowRightShadow = true
            cell.isShowLeftOutsideShadow = false
            cell.isShowRightOutsideShadow = false
        }
        
        return cell
    }
}

extension SwipeTabBarControllerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.size
        size.width *= 1.25
        return size
    }
}

extension SwipeTabBarControllerViewController: UIGestureRecognizerDelegate {
    @objc func panAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            dragBeginPosition = collectionView.contentOffset.x
            dragChangedPosition = collectionView.contentOffset.x
            print("Pan Begin x: \(dragBeginPosition)")
        }
        else if pan.state == .changed {
            let movedOffset = collectionView.contentOffset.x - dragChangedPosition
            let leadingConstant = movedOffset / CGFloat(tabBar.items.count + 1)
            print(leadingConstant)
            tabBar.highlightViewLeadingConstraint?.constant += leadingConstant
            
            dragChangedPosition = collectionView.contentOffset.x
        }
        else if pan.state == .ended {
            let dragEndPosition = collectionView.contentOffset.x
            print("Pan End x: \(dragEndPosition)")
            let dragMiniDistance = view.bounds.width / 4
            
            // For the delay of UIScrollViewDelayedTouchesBeganGestureRecognizer on UICollectionView, Setting a delay for animating selected item to properly animate collection view.
            // http://www.jianshu.com/p/b422d92738ac
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                // To fix in center
                if self.dragBeginPosition > dragEndPosition {
                    if self.selectedIndex != 0 && self.dragBeginPosition - dragEndPosition > dragMiniDistance {
                        self.selectedIndex -= 1
                    }
                    self.tabBar.animateItemsWhenTap(currentItem: self.tabBar.items[self.selectedIndex])
                }
                else {
                    if self.selectedIndex != self.tabBar.items.count - 1 && dragEndPosition - self.dragBeginPosition > dragMiniDistance {
                        self.selectedIndex += 1
                    }
                    self.tabBar.animateItemsWhenTap(currentItem: self.tabBar.items[self.selectedIndex])
                }
            })
            return
            
            // To fix in center
//            if dragBeginPosition > dragEndPosition {
//                if selectedIndex != 0 && dragBeginPosition - dragEndPosition > dragMiniDistance {
//                    selectedIndex -= 1
//                    tabBar.animateItemsWhenTap(currentItem: tabBar.items[selectedIndex])
//                }
//                else {
//                    itemOnSelected(item: selectedIndex)
//                }
//            }
//            else {
//                if selectedIndex != tabBar.items.count - 1 && dragEndPosition - dragBeginPosition > dragMiniDistance {
//                    selectedIndex += 1
//                    tabBar.animateItemsWhenTap(currentItem: tabBar.items[selectedIndex])
//                }
//                else {
//                    itemOnSelected(item: selectedIndex)
//                }
//            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("""
            - gestureRecognizer: \(String(describing: type(of: gestureRecognizer.self))),
            - otherGestureRecognizer: \(String(describing: type(of: otherGestureRecognizer.self)))
            """)
        
        // Disable UIScrollViewDelayedTouchesBeganGestureRecognizer for properly selecting item with animation on collection view.
        if gestureRecognizer is UIPanGestureRecognizer {
            if String(describing: type(of: otherGestureRecognizer.self)) == "UIScrollViewDelayedTouchesBeganGestureRecognizer" {
                //return false
            }
        }
        return true
    }
}


