//
//  MainExtension.swift
//  WeatherApp
//
//  Created by Adam Farago on 4/23/18.
//  Copyright © 2018 Adam Farago. All rights reserved.
//

import UIKit

extension Main: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MainCell
            else {fatalError()}
        cell.temperatureLabel.text = "\(Int(dailyWeather[indexPath.row].temperatureHigh))"
        
        let date = Date(timeIntervalSince1970: dailyWeather[indexPath.row].time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        let stringDate = dateFormatter.string(from: date)
        
        
        cell.dayLabel.text = stringDate
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
}
