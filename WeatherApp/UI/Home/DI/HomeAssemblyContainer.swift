//
//  HomeAssemblyContainer.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Swinject
import SwinjectStoryboard

final class HomeAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		
		container.register(GetLocationUseCase.self) { r in
			
			let proxy = r.resolve(ProxyService.self)!
			
			return GetLocation(proxyService: proxy)
		}
		
		container.register(GetWeatherUseCase.self) { r in
			
			let proxy = r.resolve(ProxyService.self)!
			
			return GetWeather(proxyService: proxy)
		}
		
		container.register(HomeViewModel.self) { r in
			
			let getWeather = r.resolve(GetWeatherUseCase.self)!
			let getLocation = r.resolve(GetLocationUseCase.self)!
			
			return DefaultHomeViewModel(getWeather: getWeather, getLocation: getLocation)
		}
		
		container.register(HomeViewController.self) { r in
			
			let viewModel = r.resolve(HomeViewModel.self)!
			
			let controller = HomeViewController(viewModel: viewModel)
			
		   return controller
		}
	}
}
