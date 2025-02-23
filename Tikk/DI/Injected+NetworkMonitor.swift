//
//  Injected+NetworkMonitor.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 20/02/2025.
//

private struct NetworkMonitorServiceKey: InjectionKey {
    static var currentValue: NetworkMonitorService = NetworkMonitorServiceImpl()
}

extension InjectedValues {
    var networkMonitorService: NetworkMonitorService{
        get { Self[NetworkMonitorServiceKey.self] }
        set { Self[NetworkMonitorServiceKey.self] = newValue }
    }
}
