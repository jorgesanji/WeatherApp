//
//  AppLocationManager.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 26/03/22.
//

import RxSwift
import RxCoreLocation
import CoreLocation

protocol AppLocationManager {
	
	func startUpdatingLocation()
	
	var locationUpdatingclosure: LocationClosure? { get set}
}

typealias LocationClosure = ((_ location: LocationResponse?, _ error: Error?)->())

fileprivate let locationUnknown = NSError(domain: "location unknown error", code: 1320, userInfo: nil)

fileprivate let locationDenied = NSError(domain: "location denied error", code: 1321, userInfo: nil)

fileprivate let locationRestricted = NSError(domain: "location restricted error", code: 1322, userInfo: nil)

fileprivate let locationUnable = NSError(domain: "location unable error", code: 1323, userInfo: nil)

final class AppLocationManagerImpl:  AppLocationManager{
	
	var locationUpdatingclosure: LocationClosure?
	
	private final let manager: CLLocationManager
	private final let bag: DisposeBag
	
	init(){
		self.manager = CLLocationManager()
		self.bag = DisposeBag()
	}
	
	private func checkLocationService(){
		
		guard let locationUpdatingclosure = locationUpdatingclosure else {
			return
		}
		
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
				case .notDetermined, .restricted, .denied:
				
					print("No access")
				
				locationUpdatingclosure(nil, locationUnable)

				case .authorizedAlways, .authorizedWhenInUse:
				
					print("Access")
				
				@unknown default:
					break
			}
		} else {
			
			print("Location services are not enabled")
			
			locationUpdatingclosure(nil, locationUnable)
		}
	}
	
	private func observerAuthorizationChanges(){
		manager.rx
			.didChangeAuthorization.bindNext { [weak self] status in
				
				guard let locationUpdatingclosure = self?.locationUpdatingclosure else {
					return
				}
				
				switch status.status {
				case .denied:
					
					print("Authorization denied")
					
					locationUpdatingclosure(nil, locationDenied)
					
				case .notDetermined:
					
					print("Authorization: not determined")
					
				case .restricted:
					
					print("Authorization: restricted")
					
					
					locationUpdatingclosure(nil, locationRestricted)

				case .authorizedAlways, .authorizedWhenInUse:
					
					print("All good fire request")
					
				@unknown default:
					
					locationUpdatingclosure(nil, locationUnknown)
					
				}
				
			} onError: { [weak self] error in
				
				guard let locationUpdatingclosure = self?.locationUpdatingclosure else {
					return
				}
				
				locationUpdatingclosure(nil, locationUnknown)

			}.disposed(by: bag)
	}
	
	private func observerLocation(){
		manager.rx
			.location
			.bindNext { [weak self] location in
				guard let location = location else { return }
				
				guard let locationUpdatingclosure = self?.locationUpdatingclosure else {
					return
				}
				
				let response = LocationResponse(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
				
				locationUpdatingclosure(response, nil)
				
			} onError: { [weak self] error in
				
				guard let locationUpdatingclosure = self?.locationUpdatingclosure else {
					return
				}
				
				locationUpdatingclosure(nil, locationUnknown)
			}
			.disposed(by: bag)
	}
	
	func startUpdatingLocation(){
		
		checkLocationService()
		
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
		
		observerAuthorizationChanges()
		
		observerLocation()
	}
}
