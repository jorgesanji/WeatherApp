//
//  LocalRepositoryImpl.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

final class LocalRepositoryImpl: LocalRepository{
	
	private final var locationManager: AppLocationManager
	
	init(locationManager: AppLocationManager){
		self.locationManager = locationManager
	}
	
	func getLocation() -> Observable<LocationResponse>?{
		
		return Observable<LocationResponse>.create({ [weak self] (observer) -> Disposable in
			
			self?.locationManager.startUpdatingLocation()
				
			self?.locationManager.locationUpdatingclosure = { location, error in
				if let error = error{
					observer.onError(error)
				} else {
					observer.onNext(location!)
				}
			}

			return Disposables.create()
		})
	}
}
