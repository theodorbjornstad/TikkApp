//
//  MockNetworkMonitorService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 23/02/2025.
//

import Combine
@testable import Tikk

class MockNetworkMonitorService: NetworkMonitorService {
    var networkStatusPublisher = PassthroughSubject<Bool, Never>()

    func sendNetworkStatus(_ isOnline: Bool) {
        networkStatusPublisher.send(isOnline)
    }
}
