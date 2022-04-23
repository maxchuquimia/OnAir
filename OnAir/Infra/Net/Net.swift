//
//  Net.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation
import MultiPeer

final class Net: NSObject {

    static let shared = Net()

    let keepAliveInterval: TimeInterval = 120.0
    var keepAlive: Timer?

    var didReceivePacket: (Packet) -> Void = { _ in }
    var connectedDevicesChanged: ([String]) -> Void = { _ in }

    func begin(with userId: String) {
        MultiPeer.instance.initialize(serviceType: "onairapp", deviceName: userId)
        MultiPeer.instance.autoConnect()
        MultiPeer.instance.delegate = self
    }

    func broadcast(packet: Packet) {
        keepAlive?.invalidate()
        MultiPeer.instance.send(data: packet.stringValue.data(using: .utf8)!, type: RequestType.packetV1.rawValue)
        keepAlive = Timer.scheduledTimer(withTimeInterval: keepAliveInterval, repeats: false, block: { [weak self] _ in
            self?.broadcast(packet: packet)
        })
    }

}

extension Net: MultiPeerDelegate {

    func multiPeer(connectedDevicesChanged devices: [String]) {
        connectedDevicesChanged(devices)
    }

    func multiPeer(didReceiveData data: Data, ofType type: UInt32, from peerID: MCPeerID) {
        guard type == RequestType.packetV1.rawValue else { return }
        guard let packet = Packet(string: String(data: data, encoding: .utf8) ?? "") else { return }
        didReceivePacket(packet)
    }

}
