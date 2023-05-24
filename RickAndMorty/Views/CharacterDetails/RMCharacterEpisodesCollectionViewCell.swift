//
//  RMCharacterEpisodesCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-25.
//

import UIKit

class RMCharacterEpisodesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        
    }
    
    override func prepareForReuse() {
        
    }
    
    public func configure(with viewModel: RMCharacterEpisodesCollectionViewCellViewModel) {
        
    }
    
}
