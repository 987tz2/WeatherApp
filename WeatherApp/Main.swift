//
//  ViewController.swift
//  WeatherApp
//
//  Created by Adam Farago on 4/18/18.
//  Copyright © 2018 Adam Farago. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Main: UIViewController {

    let cellID = "cellID"
    var currentTemperature: Double = 0.0
    var dateToday = "Monday, April 23"
    var todayHighTemperature : Double = 90.0
    var todayLowTemperature: Double = 70.0
    var userCurrentLocation = "California, Irvine"
    var dailyWeather: [DailyArray] = []
    var dailyHigh: [Int] = []
    var locationManager = CLLocationManager()
    var lat = 34.0
    var long = -118.0
    
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        updateLocation2()
        
        
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.rectangleWithDates.addGestureRecognizer(swipeUp)
        
        temperatureLabel.addTarget(self, action: #selector(changeFormateOfTemperature(sender:)), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: cellID)
        
        setUpViews()
        
    }

    //MARK: - Objects
    
    lazy var temperatureLabel: UIButton = {
        let label = UIButton()
            label.setTitle("\(Int(currentTemperature))", for: .normal)
            label.titleLabel?.font = UIFont(name: "Cochin-Bold", size: 80)
            label.titleLabel?.textColor = .white
            label.titleLabel?.textAlignment = .center
//            label.backgroundColor = .red
            label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateTodayLabel: UILabel = {
        let label = UILabel()
            label.text = dateToday
            label.font = UIFont(name: "Cochin", size: 25)
            label.textColor = .white
            label.backgroundColor = .red
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    lazy var todayHighLowTemperatureLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Cochin", size: 20)
            label.text = "\(todayHighTemperature)° / \(todayLowTemperature)°"
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.backgroundColor = .blue
        
        
        return label
    }()
    
    lazy var currentUserLocationLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: "Cochin", size: 20)
            label.textColor = .white
            label.text = userCurrentLocation
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.backgroundColor = .blue
        
        return label
    }()
    
    var degreesSymbole: UILabel = {
        let label = UILabel()
            label.text = "°F"
            label.textColor = .white
            label.font = UIFont(name: "Cochin", size: 50)
            label.translatesAutoresizingMaskIntoConstraints = false
//            label.textAlignment = .center
        
        return label
    }()
    
    var rectangleWithDates: UIView = {
        let rect = UIView()
            rect.backgroundColor = .white
            rect.layer.cornerRadius = 40
            rect.translatesAutoresizingMaskIntoConstraints = false
        
        return rect
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - Functions
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.up:
                present(DetailedViewViewController(), animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    @objc func changeFormateOfTemperature (sender: UIButton!) {
        
        if (UserDefaults().bool(forKey: "fahrenheit") == true) {
            self.currentTemperature = ((self.currentTemperature - 32) * 5/9)
            self.todayHighTemperature = ((self.todayHighTemperature - 32) * 5/9)
            self.todayLowTemperature = ((self.todayLowTemperature - 32) * 5/9)
            UserDefaults().set(false, forKey: "fahrenheit")
            UserDefaults().set("C", forKey: "CorF")
            
        } else {
            self.currentTemperature = ((self.currentTemperature * 1.8) + 32)
            self.todayHighTemperature = ((self.todayHighTemperature * 1.8) + 32)
            self.todayLowTemperature = ((self.todayLowTemperature * 1.8) + 32)
            UserDefaults().set(true, forKey: "fahrenheit")
            UserDefaults().set("F", forKey: "CorF")
        }
        
        for day in dailyWeather{
            print(day.temperatureHigh)
            day.temperatureHigh = ((day - 32) * 5/9)
        }
        
        self.todayHighLowTemperatureLabel.text = "\(Int(self.todayHighTemperature))° / \(Int(self.todayLowTemperature))°"
        self.temperatureLabel.setTitle(String(Int(self.currentTemperature)), for: .normal)
        self.degreesSymbole.text = "°\((UserDefaults().string(forKey: "CorF"))!)"
        
        return
    }
    
    func updateLocation2 () {
        locationManager.requestLocation()
    }
    
    //MARK: - Updating Weather Data
    
    struct WeatherInterval: Decodable {
        let currently: CurrentWeather
        let daily: DailyWeather
    }
    
    struct CurrentWeather: Decodable {
        let temperature: Double
        let precipProbability: Double
        let time: Double
    }
    
    struct DailyWeather: Decodable {
        let summary: String
        let data: [DailyArray]

    }
    
    struct DailyArray: Decodable {
        let temperatureHigh: Double
        let temperatureLow: Double
        let time: Double
    }
    
    func fetchJSON(){

        let jsonUrl = "https://api.darksky.net/forecast/4e3b9ba84a7ca9ce18f3afd39441f5be/\(lat),\(long)"
        //https://api.darksky.net/forecast/4e3b9ba84a7ca9ce18f3afd39441f5be/33.637142,-117.756558
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherInterval.self, from: data)
            
                for data in weather.daily.data {
                    self.dailyWeather.append(data)
                    
                }
                
                DispatchQueue.main.async {
                    self.currentTemperature = weather.currently.temperature
                    self.todayHighTemperature = (weather.daily.data[0].temperatureHigh)
                    self.todayLowTemperature = (weather.daily.data[0].temperatureLow)
                    
                    if (UserDefaults().bool(forKey: "fahrenheit") == false){
                        self.currentTemperature = ((self.currentTemperature - 32) * 5/9)
                        self.todayLowTemperature = ((self.todayLowTemperature - 32) * 5/9)
                        self.todayHighTemperature = ((self.todayHighTemperature - 32) * 5/9)
                        UserDefaults().set("C", forKey: "CorF")
                    } else {
                        UserDefaults().set("F", forKey: "CorF")
                    }
                    
                    let date = Date(timeIntervalSince1970: weather.currently.time)
//                    dailyWeather[indexPath.row].time
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, h:mm a"
                    let stringDate = dateFormatter.string(from: date)
                    
                    self.dateTodayLabel.text = stringDate
                    self.todayHighLowTemperatureLabel.text = "\(Int(self.todayHighTemperature))° / \(Int(self.todayLowTemperature))°"
                    self.temperatureLabel.setTitle("\(Int(self.currentTemperature))", for: .normal)
                    self.degreesSymbole.text = "°\((UserDefaults().string(forKey: "CorF"))!)"
                    
                    
                    self.collectionView.reloadData()
                }
                
            } catch let jsonError { print("Error \(jsonError)") }
            
        } .resume()

    }
    
    
    //MARK: - Set Up Views
    
    func setUpViews(){
        view.backgroundColor = .black
        
        view.addSubview(temperatureLabel)
        temperatureLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
//        temperatureLabel.heightAnchor.constraint(equalToConstant: 69).isActive = true
//        temperatureLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(rectangleWithDates)
        rectangleWithDates.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 333).isActive = true
        rectangleWithDates.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        rectangleWithDates.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 34).isActive = true
        rectangleWithDates.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -34).isActive = true
        
        
        view.addSubview(dateTodayLabel)
        dateTodayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 304).isActive = true
        dateTodayLabel.bottomAnchor.constraint(equalTo: rectangleWithDates.topAnchor, constant: -1).isActive = true
        dateTodayLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(todayHighLowTemperatureLabel)
        todayHighLowTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 0).isActive = true
        todayHighLowTemperatureLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        todayHighLowTemperatureLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        view.addSubview(currentUserLocationLabel)
        currentUserLocationLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: 0).isActive = true
        currentUserLocationLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        currentUserLocationLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(degreesSymbole)
        degreesSymbole.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor, constant: 0).isActive = true
        degreesSymbole.topAnchor.constraint(equalTo: temperatureLabel.topAnchor).isActive = true
        degreesSymbole.heightAnchor.constraint(equalToConstant: 69).isActive = true
        degreesSymbole.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        rectangleWithDates.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: rectangleWithDates.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rectangleWithDates.rightAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: rectangleWithDates.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: rectangleWithDates.bottomAnchor, constant: -20).isActive = true
    }
}

extension Main: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lat = (locations.last?.coordinate.latitude)!
        long = (locations.last?.coordinate.longitude)!
        dailyWeather.removeAll()
        fetchJSON()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
