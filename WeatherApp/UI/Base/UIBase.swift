//
//  UIBase.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 23/03/22.
//

import UIKit
import Longinus

public typealias BaseView = NonStoryboardableView
public typealias BaseViewController = NonStoryboardableViewController

open class NonStoryboardableViewController<V: BaseView>: UIViewController {
	
	public var _view: V? = V()
	
	public override func loadView() {
		self.view = _view
	}

	public init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) { storyboardsNotSupported(by: type(of: self)) }
}
											
open class NonStoryboardableView: UIView {

	required public init() {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) { storyboardsNotSupported(by: type(of: self)) }

	// Sometimes a custom view based on this class does not define internal constraints and thus does not work
	// the system that Auto Layout should be used.
	// (Using `class` instead of `static` to work around an invalid warning in Swift 4.2.)
	@objc open override class var requiresConstraintBasedLayout: Bool {
		return true
	}
}

fileprivate func storyboardsNotSupported(by type: AnyClass, file: StaticString = #file, line: UInt = #line) -> Never {
	preconditionFailure(
		"\(String(reflecting: type)) does not support decoding from storyboards/NIBs", file: file, line: line
	)
}

extension UILabel{
	
	class func commonLabel() -> UILabel{
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.textColor = StyleSheet.Colors.appWhite
		lb.textAlignment = .center
		return lb
	}
}

extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment:"")
	}
	
	public func localized(with arguments: [CVarArg]) -> String {
		return String(format: self.localized, locale: nil, arguments: arguments)
	}
}

extension UIImageView {
	
	func loadFromUrlString(_ urlString: String?){
		
		guard let urlString = urlString else {
			return
		}

		let url = URL(string: urlString)
		lg.setImage(with: url, options: [.progressiveBlur, .imageWithFadeAnimation, .showNetworkActivity])
	}
}
