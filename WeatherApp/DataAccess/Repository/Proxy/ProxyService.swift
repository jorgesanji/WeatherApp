//
//  ProxyService.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

protocol ProxyService: AnyObject {

	var isReachable : Bool{ get }

	func repository() -> Repository
	func repository(_ type: RepositoryType) -> Repository
}
