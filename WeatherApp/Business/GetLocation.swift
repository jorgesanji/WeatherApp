//
//  GetLocation.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 26/03/22.
//

import RxSwift

protocol GetLocationUseCase: AnyObject{
	func build() -> BaseUseCase<LocationResponse>
}

final class GetLocation: BaseUseCase<LocationResponse>, GetLocationUseCase{
	
	override init(proxyService:ProxyService) {
		
		super.init(proxyService: proxyService)
		
		processOnMainThread()
	}

	override func buildUseCaseObservable() -> Observable<LocationResponse>? {
		return proxyService.repository(.LOCAL).getLocation()
	}
}
