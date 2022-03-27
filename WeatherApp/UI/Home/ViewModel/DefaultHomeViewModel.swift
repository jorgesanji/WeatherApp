//
//  DefaultHomeViewModel.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

final class DefaultHomeViewModel: HomeViewModel{
	
	var state: State
		
	var cityName: String
	
	var imageUrl: String
	
	var temperature: String
	
	var weather: String
	
	var temperatureVariations: String
	
	var windLevel: String
	
	private final let updaterUIBag: DisposeBag = DisposeBag()
	private final let updaterUI = PublishSubject<Void>()

	final fileprivate let getWeather: GetWeatherUseCase
	final fileprivate let getLocation: GetLocationUseCase
	
	init(getWeather: GetWeatherUseCase, getLocation: GetLocationUseCase){
		
		self.getWeather = getWeather
		self.getLocation = getLocation
		
		self.cityName = ""
		self.imageUrl = ""
		self.temperature = ""
		self.weather = ""
		self.temperatureVariations = ""
		self.windLevel = ""
		self.state = .idle
	}
	
	private func getCurrentLocation(){
				
		getLocation.build().subscribe { [weak self] response in
						
			/// is needed to set the view model state because the location manager updates the current location
			self?.state = .syncing
			
			/// updating the ui in order to show activity indicator
			self?.updaterUI.onNext(())
			
			self?.fetchWeather(latitude: response.latitude, longitude: response.longitude)
			
		} onError: { [weak self] error in
			
			self?.state = .error
			
			self?.updaterUI.onNext(())
		}
	}
	
	private func fetchWeather(latitude: Double, longitude: Double){
		
		getWeather.setParams(latitude: latitude, longitude: longitude).build().subscribe { [weak self] response in
						
			self?.state = .success
			
			self?.cityName = response.city
			
			if let baseImageUrl = PlistUtils.imageURL{
				self?.imageUrl = String(format: baseImageUrl, response.details.icon)
			}
			
			self?.weather = response.details.description.capitalized
			
			self?.temperature = "temperature.Label".localized(with: [response.temperature.current])
			
			self?.temperatureVariations = "temperature.variations.Label".localized(with: [response.temperature.min, response.temperature.max])
			
			self?.windLevel = "wind.Label".localized(with: [response.wind.speed, response.wind.deg])
						
			self?.updaterUI.onNext(())
			
		} onError: { [weak self] error in
			
			self?.state = .error
						
			self?.updaterUI.onNext(())
		}
	}
	
	func subscribe(_ on : @escaping (Event<Void>) -> Void){
		
		updaterUI.subscribe(on).disposed(by: updaterUIBag)
		
		self.state = .syncing

		getCurrentLocation()
	}
}
