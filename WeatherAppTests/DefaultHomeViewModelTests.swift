//
//  DefaultHomeViewModelTests.swift
//  WeatherAppTests
//
//  Created by Jorge Sanmartin on 26/03/22.
//

import XCTest
import RxSwift

@testable import WeatherApp

class DefaultHomeViewModelTests: XCTestCase {
	
	var disposeBag: DisposeBag!
	var viewModel: DefaultHomeViewModel!
	var getWeather: GetWeatherUseCase!
	var getLocation: GetLocationUseCase!
	var localRepository: LocalRepository!
	var restRepository: RestRepository!

	override func tearDown() {
		
		disposeBag = nil
		viewModel = nil
		getWeather = nil
		getLocation = nil
		localRepository = nil
		restRepository = nil
		
		super.tearDown()
	}
	
	override func setUp() {
		super.setUp()
		
		self.disposeBag = DisposeBag()

		let appLocationManager = AppLocationManagerImpl()
		self.localRepository = LocalRepositoryImpl(locationManager: appLocationManager)
		self.restRepository = RestRepositoryImpl()
		let mockRepository = MockRepositoryImpl()
		
		let proxy = Proxy(restRepository: restRepository, localRepository: localRepository, mockRespository: mockRepository)
		
		self.getWeather = GetWeather(proxyService: proxy)
		self.getLocation = GetLocation(proxyService: proxy)
		
		// Initialize DefaultHomeViewModel
		self.viewModel = DefaultHomeViewModel(getWeather: getWeather, getLocation: getLocation)
	}
	
	func testInitialization() {
		XCTAssertNotNil(viewModel, "The home view model should not be nil.")
	}
		
	func testGetWeatherUsingRestRepository() {
		
		let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		let mainScheduler = MainScheduler.instance
		
		let latitude = -118.4912
		let longitude = 34.0195
				
		let expected = expectation(description: "getting current weather using repository")
		
		var responseCallback: WeatherResponse? = nil
		var errorCallback :Error? = nil
				
		restRepository.getWeatherByLocation(latitud: latitude, longitud: longitude)?.subscribe(on: scheduler).observe(on: mainScheduler).bindNext({ response in
			
			responseCallback = response
			expected.fulfill()
			
		}, onError: { error in
			
			errorCallback = error
			expected.fulfill()
			
		}).disposed(by: disposeBag)
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	func testGetWeatherUseCase() {
		
		let latitude = -118.4912
		let longitude = 34.0195
		
		let expected = expectation(description: "get weather using use case")
		
		var responseCallback: WeatherResponse? = nil
		var errorCallback :Error? = nil
		
		getWeather.setParams(latitude: latitude, longitude: longitude).build().subscribe { response in
			
			responseCallback = response
			
			expected.fulfill()
		} onError: { error in
			
			errorCallback = error
			
			expected.fulfill()
		}

		wait(for: [expected], timeout: 60)

		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	func testLocationUsingLocalRepository() {
		
		let mainScheduler = MainScheduler.instance
				
		let expected = expectation(description: "getting location using repository")
		
		var responseCallback: LocationResponse? = nil
		var errorCallback :Error? = nil
				
		localRepository.getLocation()?.subscribe(on: mainScheduler).observe(on: mainScheduler).bindNext({ response in
			
			responseCallback = response
			expected.fulfill()
			
		}, onError: { error in
			
			errorCallback = error
			expected.fulfill()
			
		}).disposed(by: disposeBag)
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	func testLocationUsingLocationUseCase() {
		
		let expected = expectation(description: "get location use case")
		
		var responseCallback: LocationResponse? = nil
		var errorCallback :Error? = nil
		
		getLocation.build().subscribe { response in
			
			responseCallback = response
			expected.fulfill()
			
		} onError: { error in
			
			errorCallback = error
			expected.fulfill()
		}

		wait(for: [expected], timeout: 60)

		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	func testStateSyncingViewModel() {
		
		let expected = expectation(description: "updating ui when state is syncing")
		
		viewModel.subscribe { _ in
			expected.fulfill()
		}
		
		wait(for: [expected], timeout: 10)
		
		XCTAssertEqual(viewModel.state, .syncing)
	}
	
	func testStateSuccessViewModel() {
		
		let expected = expectation(description: "updating ui when state is success")
		
		viewModel.subscribe { [weak self] _ in
			if self?.viewModel.state == .success{
				expected.fulfill()
			}
		}
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertEqual(viewModel.state, .success)
	}
}
