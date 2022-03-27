//
//  PlistUtils.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Foundation

struct PlistUtils {
	
	static var plist: [String: String]?{
		
		guard let pth = Bundle.main.url(forResource: "WeatherCredencials", withExtension: "plist") else {
			return nil
		}
		
		guard let dt = try? Data(contentsOf: pth),
			let plc = try? PropertyListSerialization.propertyList(from: dt, options: [], format: nil),
			let dc = plc as? [String: String] else {
			 return nil
		}
		
		return dc
	}
	
	static private func getValue(key: String) -> String?{
		guard let dc = PlistUtils.plist, let value = dc[key] else {
			 return nil
		}
		return value
	}
	
	static var baseURL: String?{
		guard let v = PlistUtils.getValue(key:"base_url") else {
			 return nil
		}
		return v
	}
	
	static var imageURL: String?{
		guard let v = PlistUtils.getValue(key:"image_url") else {
			 return nil
		}
		return v + "%@@2x.png"
	}
		
	static var appID: String?{
		guard let v = PlistUtils.getValue(key:"app_id") else {
			 return nil
		}
		return v
	}
}
