//
//  ViewController.swift
//  CustomFont
//
//  Created by Bevis Chen on 2016/10/13.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK:- IBOutlet
    @IBOutlet weak var fontShowCollectionView: UICollectionView!

    // MARK:- Variable
    var texts:[(text: String, selectCount: Int)]
        = [("PPAP", 0),
           ("I have a Pen", 0),
           ("I have an Apple", 0),
           ("Um~ Apple Pen!", 0),
           ("I have a Pen", 0),
           ("I have Pineapple", 0),
           ("Um~ Pineapple Pen!", 0),
           ("Apple Pen~", 0),
           ("Pineapple Pen~", 0),
           ("Um~ Pen Pineapple Apple Pen!", 0)]
    
    // MARK:- Constant
    let paddingTop: CGFloat = 10
    let paddingBottom: CGFloat = 10
    let fontFamilys:[(name: String, size: CGFloat)]
        = [(".SFUIDisplay-Ultralight", 30),
           ("loBe", 30),
           ("Diane de France", 30),
           ("AdmirationPains", 20),
           ("orange juice", 30)]
    let animationDuration = 0.2
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBaseUI()
        printFontFamily()
    }
    
    // MARK:- Set UI
    private func setBaseUI() {
        
        fontShowCollectionView.contentInset = UIEdgeInsetsMake(paddingTop, 0, paddingBottom, 0)
    }
    
    // MARK:- Private Methods
    private func printFontFamily() {
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    private func setFontFamilyWithCell(_ cell: FontShowCollectionViewCell,  indexPath: IndexPath) {
        
        let fontsIndex = self.texts[indexPath.row].selectCount % self.fontFamilys.count
        cell.textLebel.font = UIFont(name: self.fontFamilys[fontsIndex].name, size: self.fontFamilys[fontsIndex].size)
    }
    
    // MARK:- UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let cell = collectionView.cellForItem(at: indexPath) as! FontShowCollectionViewCell
        
        UIView.transition(with: cell, duration: animationDuration, options: .transitionFlipFromTop, animations: {
            
            self.texts[indexPath.row].selectCount += 1
            self.setFontFamilyWithCell(cell, indexPath: indexPath)
            
            }) { (isDone) in
                
                print("Animation isDone: \(isDone)")
        }
    }
    
    // MARK:- UICollectionViewDataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cell"
        collectionView.register(UINib(nibName: "FontShowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FontShowCollectionViewCell
        
        cell.textLebel.text = texts[indexPath.row].text
        setFontFamilyWithCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

