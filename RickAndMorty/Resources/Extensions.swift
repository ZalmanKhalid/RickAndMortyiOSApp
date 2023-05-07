//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-07.
//

import UIKit


extension UIView {
    func addSubviews(_ views: UIView...) {
//        views.forEach { view in
//            self.addSubview(view)
//        }
        views.forEach({
            self.addSubview($0)
        })
    }
}

