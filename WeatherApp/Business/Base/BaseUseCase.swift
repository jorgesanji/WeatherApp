//
//  BaseUseCase.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

import RxSwift

class BaseUseCase<K: Decodable>{

	private var subscriberScheduler:SchedulerType!
	private var observableScheduler:SerialDispatchQueueScheduler!
	private var disposable:Disposable!
	
	final let proxyService: ProxyService!
	
	init(proxyService:ProxyService) {
		self.proxyService = proxyService
		initRx()
	}
	
	init() {
		self.proxyService = nil
		initRx()
	}
	
	private func initRx(){
		self.subscriberScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		self.observableScheduler = MainScheduler.instance
	}
	
	func processOnMainThread(){
		self.subscriberScheduler = MainScheduler.instance
		self.observableScheduler = MainScheduler.instance
	}
	
	func subscribe(_ onNext:@escaping (K)-> Void, onError:((Swift.Error) -> Void)? = nil){
		self.disposable = buildUseCaseObservable()?.subscribe(on: subscriberScheduler)
			.observe(on: observableScheduler).bindNext(onNext, onError: onError)
	}
	
	func buildUseCaseObservable() -> Observable<K>? {
		preconditionFailure("please override this method and build your observable")
	}
	
	func unsubscribe(){
		if disposable != nil{
			disposable.dispose()
		}
		disposable = nil
	}
	
	func isUnsubscribe()->Bool{
		return disposable != nil
	}
	
	func build() -> BaseUseCase<K> {
		return self
	}
}

extension ObservableType{
	
	func bindNext(_ onNext:@escaping (Element)-> Void, onError:((Swift.Error) -> Void)? = nil)-> Disposable{
		return subscribe(onNext: onNext, onError: { (error) in
			onError!(error)
		}, onCompleted: {
		}, onDisposed: {
		})
	}
}
