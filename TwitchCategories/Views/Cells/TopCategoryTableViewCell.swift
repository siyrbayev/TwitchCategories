//
//  TopCategoryTableViewCell.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 23.05.2021.
//

import UIKit
import Kingfisher

class TopCategoryTableViewCell: UITableViewCell {
    static let identifier = "TopCategoryTableViewCell"
    static let nib = UINib(nibName: identifier, bundle: Bundle(for: TopCategoryTableViewCell.self))
    
    @IBOutlet weak fileprivate var backgroundImageView: UIImageView!
    @IBOutlet weak fileprivate var channelsLabel: UILabel!
    @IBOutlet weak fileprivate var viewersLabel: UILabel!
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    
    public var category: CategoryDetails? {
        didSet {
            if let category = category {
                channelsLabel.text = "channels: \(category.channels)"
                viewersLabel.text = "viewers: \(category.viewers)"
                nameLabel.text = category.name
                backgroundImageView.kf.setImage(with: URL(string: category.backPath))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
}

extension TopCategoryTableViewCell {
    private func configureLayout(){
        backgroundImageView.layer.cornerRadius = 12
    }
}
