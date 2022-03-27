//
//  CommonAssemblyContainer.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Swinject
import SwinjectStoryboard

final class CommonAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		
		container.register(AppLocationManager.self) { r in
			
			return AppLocationManagerImpl()
		}
		
		container.register(RestRepository.self) { r in
			
			return RestRepositoryImpl()
		}
		
		container.register(LocalRepository.self) { r in
			
			let locationManager = r.resolve(AppLocationManager.self)!
		
			return LocalRepositoryImpl(locationManager: locationManager)
		}
		
		container.register(MockRepository.self) { r in
			
			return MockRepositoryImpl()
		}
		
		container.register(ProxyService.self) { r in
			
			let restRepository = r.resolve(RestRepository.self)!
			let localRepository = r.resolve(LocalRepository.self)!
			let mockRespository = r.resolve(MockRepository.self)!
			
			return Proxy(restRepository: restRepository, localRepository: localRepository, mockRespository: mockRespository)
			
		}.inObjectScope(.container)
		
	}
}
