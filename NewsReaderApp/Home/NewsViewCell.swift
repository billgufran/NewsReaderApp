//
//  NewsViewCell.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 1/5/23.
//

import UIKit

protocol NewsViewCellDelegate: AnyObject {
    func newsViewCellBookmarkButtonTapped(_ cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: NewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code'
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
    
    @IBAction func bookmarkButtonTap(_ sender: Any) {
        delegate?.newsViewCellBookmarkButtonTapped(self)
    }
}
