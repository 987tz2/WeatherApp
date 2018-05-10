//
//  MainCell.swift
//  WeatherApp
//
//  Created by Adam Farago on 4/23/18.
//  Copyright © 2018 Adam Farago. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Cochin", size: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Cochin", size: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setUpViews() {

        backgroundColor = .green
        
        addSubview(temperatureLabel)
        temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        temperatureLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
