//
//  NetworkMonitorService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI
import Network
import Combine

class NetworkMonitorService {
    static let shared = NetworkMonitorService()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var networkStatusPublisher = PassthroughSubject<Bool, Never>()

    init() {
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let status = path.status == .satisfied
                self?.networkStatusPublisher.send(status)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
