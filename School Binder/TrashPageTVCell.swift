//
//  TrashPageTVCell.swift
//  School Binder
//
//  Created by Joshua Laurence on 01/08/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class TrashPageTVCell: UITableViewCell {

    
    @IBOutlet weak var TrashPageTVCMainContentView: UIView!
    @IBOutlet weak var TrashPageTVCTitleLabel: UILabel!
    @IBOutlet weak var TrashPageTVCTagsLabel: UILabel!
    @IBOutlet weak var TrashPageTVCPageNumber: UILabel!
    @IBOutlet weak var TrashPageTVCImageView: UIImageView!
    @IBOutlet weak var TrashPageTVCTextContentLabel: UILabel!
    @IBOutlet weak var TrashPageTVCTrashDateLabel: UILabel!
    @IBOutlet weak var TrashPageTVCTrashDateLabelSecondary: UILabel!
    @IBOutlet weak var TrashPageTVCDifficultyImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
