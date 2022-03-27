//
//  Proxy.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 25/03/22.
//

final class Proxy: ProxyService{
	
	private final let restRepository: RestRepository
	private final let locRepository: LocalRepository
	private final let mockRepository: MockRepository
	private let reachability = try! Reachability()
	
	var isReachable : Bool = true

	init(restRepository: RestRepository, localRepository: LocalRepository, mockRespository: MockRepository) {
		self.restRepository = restRepository
		self.locRepository = localRepository
		self.mockRepository = mockRespository
		initReachability()
	}
	
	deinit {
		reachability.stopNotifier()
	}
	
	func initReachability(){
		reachability.whenReachable = {[weak self] reachability in
			self?.isReachable = true
		}
		reachability.whenUnreachable = {[weak self]  _ in
			self?.isReachable = false
		}
		do {
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
	
	func localRepository() -> Repository {
		return locRepository
	}
	
	func repository() -> Repository {
		return isReachable ? restRepository : locRepository
	}
	
	func repository(_ type:RepositoryType = .REST) -> Repository{
		switch type {
		case .REST:
			return restRepository
		case .LOCAL:
			return locRepository
		default:
			return mockRepository
		}
	}
}
