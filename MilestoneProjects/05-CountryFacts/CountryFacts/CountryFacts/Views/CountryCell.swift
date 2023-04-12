//
//  CountryCell.swift
//  CountryFacts
//
//  Created by JC on 8/4/23.
//

import UIKit

class CountryCell: UITableViewCell {
    
    static let identifier = "CountryCell"
    
    func configure(for name: String, imageName: String) {
        accessoryType = .disclosureIndicator

        imageView?.image = UIImage.scale(
            image: UIImage(named: imageName)!,
            to: CGSize(width: 65, height: 40)
        )
        imageView?.layer.borderWidth = 1
        imageView?.layer.borderColor = UIColor.systemFill.cgColor
        imageView?.contentMode = .scaleAspectFill
        
        textLabel?.text = name
        textLabel?.textColor = .label
        textLabel?.font = .boldSystemFont(ofSize: 17)
    }
}
