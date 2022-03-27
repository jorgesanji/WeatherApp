//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

typealias HomeViewModel = Home_ViewModel

protocol Home_ViewModel{
	
	var state: State { get }
		
	var cityName: String { get }
	
	var imageUrl: String { get }
	
	var temperature: String { get }
	
	var weather: String { get }
	
	var temperatureVariations: String { get }

	var windLevel: String { get }
	
	func subscribe(_ on: @escaping (Event<Void>) -> Void)
}

enum State: Int{
	case error
	case success
	case idle
	case syncing
}
