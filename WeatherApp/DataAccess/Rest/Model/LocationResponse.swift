//
//  LocationResponse.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 26/03/22.
//

struct LocationResponse: Decodable, Equatable{
	
	let latitude: Double
	let longitude: Double
}
