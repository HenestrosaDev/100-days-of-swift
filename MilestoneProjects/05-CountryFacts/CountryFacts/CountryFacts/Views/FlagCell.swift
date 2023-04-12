//
//  FlagCell.swift
//  CountryFacts
//
//  Created by JC on 8/4/23.
//

import UIKit

class FlagCell: UITableViewCell {
    
    static let identifier = "FlagCell"
    
    func configure(countryCode: String) {
        let flagImageView = UIImageView()
        addSubview(flagImageView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        flagImageView.image = UIImage(named: ImageUtils.getFlagFileName(countryCode: countryCode))
        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.systemFill.cgColor
        
        let flagHeight: CGFloat = 120
        let flagRatio: CGFloat = flagImageView.image?.getImageRatio() ?? 1.5
        let flagWidth = flagHeight * flagRatio
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            flagImageView.heightAnchor.constraint(equalToConstant: flagHeight),
            flagImageView.widthAnchor.constraint(equalToConstant: flagWidth),
            flagImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            flagImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
