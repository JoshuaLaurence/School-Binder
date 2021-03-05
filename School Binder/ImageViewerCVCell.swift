//
//  ImageViewerCVCell.swift
//  School Binder
//
//  Created by Joshua Laurence on 22/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class ImageViewerCVCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageViewerCVCellShadowView: UIView!
    @IBOutlet weak var ImageViewerCVCellImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.08) {
                    self.ImageViewerCVCellImageView.frame = CGRect(x: 4, y: 4, width: 64, height: 64)
                    self.ImageViewerCVCellShadowView.frame = CGRect(x: 4, y: 4, width: 64, height: 64)
                }
            } else {
                UIView.animate(withDuration: 0.08) {
                    self.ImageViewerCVCellImageView.frame = CGRect(x: 12, y: 12, width: 48, height: 48)
                    self.ImageViewerCVCellShadowView.frame = CGRect(x: 12, y: 12, width: 48, height: 48)
                }
            }
        }
    }
}
