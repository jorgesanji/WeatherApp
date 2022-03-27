//
//  DI.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import Swinject
import SwinjectStoryboard
import UIKit

final class ApplicationAssembly {
	
	class var assembler: Assembler {
		
		var commonAssemblies: [Assembly]{
			return [CommonAssemblyContainer()]
		}
		
		var homeAssemblies: [Assembly]{
			return [HomeAssemblyContainer()]
		}
		
		var assemblies: [Assembly] = commonAssemblies
		assemblies.append(contentsOf: homeAssemblies)
		
		return Assembler(assemblies)
	}
}

extension SwinjectStoryboard {
	
	@objc class func setup() {
		defaultContainer = ApplicationAssembly.assembler.resolver as! Container
	}
	
	class func resolve<C: UIViewController>(_ controllerClass: C.Type) -> C{
		return defaultContainer.resolve(controllerClass.self)!
	}
}

extension UIViewController {
	
	class func homeViewController() -> HomeViewController{
			
		return SwinjectStoryboard.resolve(HomeViewController.self)
	}
}
