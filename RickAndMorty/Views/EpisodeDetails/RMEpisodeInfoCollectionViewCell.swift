//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-06-13.
//

import UIKit

class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    fileprivate func setUpLayer() {
        layer.cornerRadius = 8
//        contentView.layer.shadowColor = UIColor.label.cgColor
//        contentView.layer.shadowRadius = 4
//        contentView.layer.shadowOffset = CGSize(width: -3, height: 3)
//        contentView.layer.shadowOpacity = 0.25
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.masksToBounds = true
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel){
        
    }
}
