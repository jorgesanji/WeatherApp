//
//  MockRepositoryImpl.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

final class MockRepositoryImpl: MockRepository{
	
	/*
	 
	 {
		"coord":{
		   "lon":-118.4912,
		   "lat":34.0195
		},
		"weather":[
		   {
			  "id":800,
			  "main":"Clear",
			  "description":"clear sky",
			  "icon":"01d"
		   }
		],
		"base":"stations",
		"main":{
		   "temp":299.7,
		   "feels_like":299.7,
		   "temp_min":290.15,
		   "temp_max":307.51,
		   "pressure":1014,
		   "humidity":49
		},
		"visibility":10000,
		"wind":{
		   "speed":4.63,
		   "deg":290
		},
		"clouds":{
		   "all":0
		},
		"dt":1648251242,
		"sys":{
		   "type":2,
		   "id":2032408,
		   "country":"US",
		   "sunrise":1648216236,
		   "sunset":1648260540
		},
		"timezone":-25200,
		"id":5393212,
		"name":"Santa Monica",
		"cod":200
	 }
	 */
	
	func getWeatherByLocation(latitud: Double, longitud: Double) -> Observable<WeatherResponse>? {
		
		let city: String = "Santa Monica"
		let details: Details = Details(description: "clear sky", icon: "01d")
		let temperature: Temperature = Temperature(current: 299.7, min: 290.15, max: 307.51)
		let wind: Wind = Wind(speed: 4.63, deg: 290)
		let response = WeatherResponse(city: city, details: details, temperature: temperature, wind: wind)
		
		return Observable.just(response)
	}
	
	func getLocation() -> Observable<LocationResponse>? {
		
		let location = LocationResponse(latitude: 34.0195, longitude: -118.4912)
		
		return Observable.just(location)
	}
	
}
