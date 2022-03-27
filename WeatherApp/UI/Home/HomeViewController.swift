//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 22/03/22.
//

import RxSwift

final class HomeViewController: BaseViewController<HomeView> {
	
	private final var viewModel: HomeViewModel

	init(viewModel: HomeViewModel){
		
		self.viewModel = viewModel
		
		super.init()
		
		self.viewModel.subscribe { [weak self] _ in
			
			self?.updateUI()
		}
		
		updateUI()
	}

	private func updateUI(){
		
		guard let view = _view else { return }
		
		if viewModel.state == .error{
			
			view.hideLoader = true
			
			return
		}

		view.hideLoader = false
		
		guard viewModel.state == .success else { return }
				
		view.hideLoader = true
		view.cityName = viewModel.cityName
		view.imageURL = viewModel.imageUrl
		view.weather = viewModel.weather
		view.temperature = viewModel.temperature
		view.temperatureVariations = viewModel.temperatureVariations
		view.windLevel = viewModel.windLevel
	}	
}
	
	
