//
//  HomeView.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import UIKit
import Stevia

final class HomeView: BaseView{
	
	required init() {
		
		super.init()
		
		translatesAutoresizingMaskIntoConstraints = true
		
		backgroundColor = StyleSheet.Colors.appBlack
		
		temperatureLabel.style { lb in
			lb.font = StyleSheet.Fonts.Medium
		}
		
		sv(
			cityLabel,
			imageWeatherImageView,
			temperatureLabel,
			weatherLabel,
			temperatureVariationsLabel,
			windLabel,
			activityIndicatorView
		)
		
		activityIndicatorView.centerInContainer()
		
		typealias p = StyleSheet.Paddings
		
		layout(
			p.xl,
			|-p.n-cityLabel-p.n-|,
			p.l,
			imageWeatherImageView.height(100).width(100).centerHorizontally(),
			p.l,
			|-p.n-temperatureLabel-p.n-|,
			p.l,
			|-p.n-weatherLabel-p.n-|,
			p.l,
			|-p.n-temperatureVariationsLabel-p.n-|,
			p.l,
			|-p.n-windLabel-p.n-|
		)
	}

	private let cityLabel: UILabel = .commonLabel()
	
	private let imageWeatherImageView: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.layer.borderColor =  StyleSheet.Colors.appWhite.cgColor
		iv.layer.borderWidth = 3
		iv.layer.cornerRadius = 12
		return iv
	}()
	
	private let temperatureLabel: UILabel = .commonLabel()
	
	private let weatherLabel: UILabel = .commonLabel()
	
	private let temperatureVariationsLabel: UILabel = .commonLabel()
	
	private let windLabel: UILabel = .commonLabel()
	
	private let activityIndicatorView: UIActivityIndicatorView = {
		let v = UIActivityIndicatorView(style: .gray)
		v.translatesAutoresizingMaskIntoConstraints = false
		v.hidesWhenStopped = true
		v.color = StyleSheet.Colors.appWhite
		return v
	}()
}

extension  HomeView{
	
	var cityName: String? {
		set{ cityLabel.text = newValue }
		get{ cityLabel.text }
   }
   
   var imageURL: String? {
	   set{ imageWeatherImageView.loadFromUrlString(newValue) }
	   get{ nil }
  }
   
   var temperature: String? {
	   set{ temperatureLabel.text = newValue }
	   get{ temperatureLabel.text }
   }
   
   var weather: String? {
	   set{ weatherLabel.text = newValue }
	   get{ weatherLabel.text }
   }
   
   var temperatureVariations: String? {
	   set{ temperatureVariationsLabel.text = newValue }
	   get{ temperatureVariationsLabel.text }
   }
   
   var windLevel: String? {
	   set{ windLabel.text = newValue }
	   get{ windLabel.text }
   }
   
   var hideLoader: Bool {
	   set{
		   if newValue{
			   activityIndicatorView.stopAnimating()
		   } else {
			   activityIndicatorView.startAnimating()
		   }
	   }
	   get{ activityIndicatorView.isAnimating }
   }
}
