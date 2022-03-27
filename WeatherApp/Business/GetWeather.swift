//
//  GetWeather.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

protocol GetWeatherUseCase: AnyObject{
	
	func setParams(latitude: Double, longitude: Double) -> GetWeatherUseCase
	func build() -> BaseUseCase<WeatherResponse>
}

final class GetWeather: BaseUseCase<WeatherResponse>, GetWeatherUseCase{
	
	private var latitude = 0.0
	private var longitude = 0.0
	
	override func buildUseCaseObservable() -> Observable<WeatherResponse>? {
		return proxyService.repository().getWeatherByLocation(latitud: latitude, longitud: longitude)
	}
	
	func setParams(latitude: Double, longitude: Double) -> GetWeatherUseCase {
		
		self.latitude = latitude
		self.longitude = longitude
		
		return self
	}
}
