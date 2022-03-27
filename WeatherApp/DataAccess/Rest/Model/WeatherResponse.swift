//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Foundation

struct WeatherResponse: Decodable{
	
	private enum CodingKeys: String, CodingKey {
		case details = "weather", wind, temperature = "main", city = "name"
	}
	
	let city: String
	let details: Details
	let temperature: Temperature
	let wind: Wind
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.city = try container.decode(String.self, forKey: .city)
		
		/// Is needed to use only the first element
		/// 
		let detailsArray = try container.decode([Details].self, forKey: .details)
		self.details = detailsArray[0]
		
		self.temperature = try container.decode(Temperature.self, forKey: .temperature)
		
		self.wind = try container.decode(Wind.self, forKey: .wind)
	}
	
	init(city: String, details: Details,temperature: Temperature, wind: Wind){
		self.city = city
		self.details = details
		self.temperature = temperature
		self.wind = wind
	}
}

struct Details: Decodable{
	
	let description: String
	let icon: String
}

struct Temperature: Decodable{
	
	private enum CodingKeys: String, CodingKey {
		case min = "temp_min", max = "temp_max", current = "temp"
	}
	
	let current: Double
	let min: Double
	let max: Double
}

struct Wind: Decodable{
	
	let speed: Double
	let deg: Int64
}
