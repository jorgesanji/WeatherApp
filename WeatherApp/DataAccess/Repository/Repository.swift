//
//  Repository.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

fileprivate let `default` = NSError(domain: "default error", code: 131, userInfo: nil)

protocol Repository: AnyObject{
	
	func getWeatherByLocation(latitud: Double, longitud: Double) -> Observable<WeatherResponse>?
	
	func getLocation() -> Observable<LocationResponse>?
}

extension Repository{
	
	func getWeatherByLocation(latitud: Double, longitud: Double) -> Observable<WeatherResponse>?{
		return Observable.error(`default`)
	}
	
	func getLocation() -> Observable<LocationResponse>?{
		return Observable.error(`default`)
	}
}

protocol LocalRepository: Repository{}

protocol RestRepository: Repository{}

protocol MockRepository: Repository{}

enum RepositoryType: Int {
	case REST
	case LOCAL
	case MOCK
}
