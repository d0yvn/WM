//
//  File.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Foundation
import Network

@available(iOS 12.0, *)
final public class NetworkMonitorManager {
    
    public static let shared = NetworkMonitorManager()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkManager")
    
    public private(set) var isConnected = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
