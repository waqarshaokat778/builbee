//
//  ImagesCollectionView.swift
//  Builbee
//
//  Created by Abdullah on 1/8/21.
//  Copyright © 2021 KK. All rights reserved.
//

import UIKit

class ImagesCollectionView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imagesArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageController.numberOfPages = imagesArray.count
        
        pageController.currentPage = 0
        pageController.isHidden = !(imagesArray.count  > 1)
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ImagesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionCell", for: indexPath) as! ImagesCollectionCell
        
        let urls = URL(string: (imagesArray[indexPath.row]))
        
        if urls != nil {
            if #available(iOS 13.0, *) {
                cell.imagecell.af_setImage(withURL: urls! ,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
            } else {
                cell.imagecell.af_setImage(withURL: urls! ,placeholderImage: UIImage(named:"stock_image_four"))
            }
        } else {
            cell.imagecell.image = #imageLiteral(resourceName: "stock_image_four")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: view.frame.height )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.section
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

class ImagesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imagecell: UIImageView!
}
