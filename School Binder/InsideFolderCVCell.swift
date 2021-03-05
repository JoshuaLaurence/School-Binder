//
//  InsideFolderCVCell.swift
//  School Binder
//
//  Created by Joshua Laurence on 29/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class InsideFolderCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var InsideFolderCheckMarkBackgroundView: UIView!
    @IBOutlet weak var InsideFolderCheckMark: UIImageView!
    @IBOutlet weak var InsideFolderSelectionView: UIView!
    @IBOutlet weak var InsideFolderDifficultyBackgroundView: UIView!
    @IBOutlet weak var InsideFolderPageNumberShadowView: UIView!
    @IBOutlet weak var InsideFolderStruggleIconShadowView: UIView!
    @IBOutlet weak var InsideFolderShadowView: UIView!
    @IBOutlet weak var InsideFolderDifficultyImageView: UIImageView!
    @IBOutlet weak var InsideFolderPageNumber: UILabel!
    @IBOutlet weak var InsideFolderImageView: UIImageView!
    @IBOutlet weak var InsideFolderTitle: UILabel!
    @IBOutlet weak var InsideFolderTxtNoteContentLabel: UILabel!
    
    var isEditing: Bool = false
    
    override var isSelected: Bool {
        didSet {
            InsideFolderCheckMark.isHidden = !isSelected
            InsideFolderSelectionView.isHidden = !isSelected
            InsideFolderCheckMarkBackgroundView.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        InsideFolderCheckMark.isHidden = true
        InsideFolderSelectionView.isHidden = true
        InsideFolderCheckMarkBackgroundView.isHidden = true
    }
    
}
