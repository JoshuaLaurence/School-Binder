//
//  StruggleTVCell.swift
//  School Binder
//
//  Created by Joshua Laurence on 25/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class StruggleTVCell: UITableViewCell {

    @IBOutlet weak var StrugglePinImageView: UIImageView!
    @IBOutlet weak var StruggleImageView: UIImageView!
    @IBOutlet weak var StrugglePageNumber: UILabel!
    @IBOutlet weak var StruggleTags: UILabel!
    @IBOutlet weak var StruggleTextContent: UILabel!
    @IBOutlet weak var StruggleTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
