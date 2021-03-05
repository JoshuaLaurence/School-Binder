//
//  AllNotesTVCell.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class AllNotesTVCell: UITableViewCell {

    
    @IBOutlet weak var AllNotesTVCDifficultyImageView: UIImageView!
    @IBOutlet weak var AllNotesTVCTextContent: UILabel!
    @IBOutlet weak var AllNotesTVCPageNumber: UILabel!
    @IBOutlet weak var AllNotesTVCImageView: UIImageView!
    @IBOutlet weak var AllNotesTVCTags: UILabel!
    @IBOutlet weak var AllNotesTVCTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
