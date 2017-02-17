//
//  changeDisplayView.swift
//  TableView_byswift3
//
//  Created by hunterchen on 2017/2/16.
//  Copyright © 2017年 hunterchen. All rights reserved.
//

import UIKit
import DisplaySwitcher
import Alamofire

private let listCellHeight: CGFloat = 88
private let gridCellHeight: CGFloat = 168

class changeDisplayView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchButton: SwitchLayoutButton!
    
    fileprivate let listCell = "ListCell"
    fileprivate let gridCell = "GridCell"
    
    private let animationDuration: TimeInterval = 0.3
    fileprivate lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listCellHeight, nextLayoutStaticCellHeight: gridCellHeight, layoutState: .list)
    fileprivate lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridCellHeight, nextLayoutStaticCellHeight: listCellHeight, layoutState: .grid)
    fileprivate var layoutState: LayoutState = .list
    fileprivate var isTransitionAvailable = true
    
    var str_imgUrl:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn_right =  UIBarButtonItem(title: "SwitchDisplay", style: .plain, target: self, action:#selector(changeDisplayView.changeDisplay))
        self.tabBarController?.navigationItem.rightBarButtonItem=btn_right
        
        //2擇一選擇切換 Button
        switchButton.isHidden = true
        
        setupCollectionView()
        setupSwitchButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeDisplay(){
        let transitionManager: TransitionManager
        if layoutState == .list {
            layoutState = .grid
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .list
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        switchButton.isSelected = layoutState == .list
        switchButton.animationDuration = animationDuration
    }
    
    // MARK: - Action
    @IBAction func TabSwitchButton(_ sender: Any) {
        let transitionManager: TransitionManager
        if layoutState == .list {
            layoutState = .grid
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .list
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        switchButton.isSelected = layoutState == .list
        switchButton.animationDuration = animationDuration
    }
    
    // MARK: - Private
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = listLayout
        collectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        collectionView.register(UINib(nibName: "GridCell", bundle: nil), forCellWithReuseIdentifier: "gridCell")
    }
    
    private func setupSwitchButton() {
        switchButton.isSelected = layoutState == .list
        switchButton.animationDuration = animationDuration
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: - UICollectionViewDataSource
extension changeDisplayView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return str_imgUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if layoutState == .grid {
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
                fatalError("Could not create GridCell")
            }
            Alamofire.request(str_imgUrl[indexPath.row])
                .responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    if let image = response.result.value {
                        // Update the cell
                        DispatchQueue.main.async(execute: {
                            gridCell.img.image = image
                        })
                    }
            }
            return gridCell
        }
        guard let litCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCell else {
            fatalError("Could not create ListCell")
        }
        Alamofire.request(str_imgUrl[indexPath.row])
            .responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                if let image = response.result.value {
                    // Update the cell
                    DispatchQueue.main.async(execute: {
                        litCell.img.image = image
                    })
                }
        }
        return litCell
    }
}

// MARK: - UICollectionViewDelegate
extension changeDisplayView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
}

