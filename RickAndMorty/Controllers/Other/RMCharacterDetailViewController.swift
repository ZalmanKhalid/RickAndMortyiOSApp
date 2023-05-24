//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-08.
//

import UIKit

/// Controller to show Info about Selected Character
class RMCharacterDetailViewController: UIViewController {

    private var viewModel:RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView
    
    // MARK: - Init
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.name
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare))
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        addConstraints()
    
    }
    
    @objc private func didTapShare() {
        // share character info
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

}


extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .info(let viewModel):
            return viewModel.count
        case .episodes(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                fatalError()
            }
            cell.backgroundColor = .cyan
            cell.configure(with: viewModel)
            return cell
        case .info(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                fatalError()
            }
            cell.backgroundColor = .systemCyan
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case .episodes(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodesCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterEpisodesCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel[indexPath.row])
            cell.backgroundColor = .systemMint
            return cell
        }

    }
}
