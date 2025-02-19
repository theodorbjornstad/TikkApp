//
//  NetworkMonitor.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import Observation
import Network

@Observable class NetworkManager {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    var isConnected = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
