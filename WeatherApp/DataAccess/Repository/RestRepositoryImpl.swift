//
//  RestRepositoryImpl.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift
import Moya

final class RestRepositoryImpl: RestRepository{
	
	private let provider:MoyaProvider<WeatherServices> = MoyaProvider<WeatherServices>()
	
	func getWeatherByLocation(latitud: Double, longitud: Double) -> Observable<WeatherResponse>?{
		return provider.rx
			.request(.getWeatherByLocation(latitud: latitud, longitud: longitud))
			.filterSuccessfulStatusAndRedirectCodes()
			.map(WeatherResponse.self)
			.asObservable()
	}
}
