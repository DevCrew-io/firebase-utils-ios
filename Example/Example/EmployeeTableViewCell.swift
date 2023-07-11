//
//  StudentTableViewCell.swift
//  Example
//
//  Created by Maaz Rafique on 03/07/2023.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
