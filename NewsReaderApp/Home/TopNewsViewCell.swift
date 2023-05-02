//
//  TopNewsViewCell.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 1/5/23.
//

import UIKit

class TopNewsViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
}
