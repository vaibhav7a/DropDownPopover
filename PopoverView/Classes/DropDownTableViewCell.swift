//
//  DropDownTableViewCell.swift
//  RBCCompanion
//
//  Created by Vaibhav Jain on 12/07/23.
//  Copyright © 2023 Mayuri Patil. All rights reserved.
//

import UIKit

public class DropDownTableViewCell: UITableViewCell {
    @IBOutlet internal weak var titleLabel: UILabel!
    public var selectedRowColor: UIColor?
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.backgroundColor = selectedRowColor
    }
    
}
