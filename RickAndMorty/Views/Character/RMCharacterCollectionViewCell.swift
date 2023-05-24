//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-07.
//

import UIKit


/// Single cell for character
class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLbale: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLbale: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLbale, statusLbale)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -3, height: 3)
        contentView.layer.shadowOpacity = 0.25
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLbale.heightAnchor.constraint(equalToConstant: 32),
            nameLbale.heightAnchor.constraint(equalToConstant: 32),
            
            statusLbale.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            statusLbale.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameLbale.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            nameLbale.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            
            statusLbale.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            nameLbale.bottomAnchor.constraint(equalTo: statusLbale.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLbale.topAnchor, constant: -2),
        ])
        
//        imageView.backgroundColor = .systemYellow
//        statusLbale.backgroundColor = .systemOrange
//        nameLbale.backgroundColor = .systemRed
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLbale.text = nil
        statusLbale.text = nil
    }
    
    public func config(with viewModel: RMCharacterCollectionViewCellViewModel){
        self.nameLbale.text = viewModel.characterName
        self.statusLbale.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
