//
//  WeatherServices.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Foundation
import Moya

enum WeatherServices {
	
	case getWeatherByLocation(latitud: Double, longitud: Double)
}

extension WeatherServices: TargetType{
	
	private var appId: String{
		guard let appID = PlistUtils.appID else { fatalError("appId could not be configured") }
		return appID
	}
	
	var baseURL: URL {
		guard let path = PlistUtils.baseURL, let url = URL(string: path) else { fatalError("baseURL could not be configured") }
		return url
	}
	
	var path: String {
		switch self {
		case .getWeatherByLocation:
			return "/data/2.5/weather"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getWeatherByLocation:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		default:
			return Data()
		}
	}
	
	var task: Task {
		switch self {
		case .getWeatherByLocation(let latitud, let longitud):
			
			return .requestParameters(parameters: ["lat": latitud, "lon": longitud, "appid": appId], encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
	var parameterEncoding: ParameterEncoding {
		switch self {
		case .getWeatherByLocation:
			return JSONEncoding()
		}
	}
}
