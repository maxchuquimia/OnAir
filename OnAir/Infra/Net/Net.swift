//
//  Net.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation

final class Net: NSObject {

    static let shared = Net()
    var nearPeer = NearPeer(serviceType: "cponair")

    let keepAliveInterval: TimeInterval = 120.0
    var keepAlive: Timer?

    var didReceivePacket: (Packet) -> Void = { _ in }
    var connectedDevicesChanged: ([String]) -> Void = { _ in }

    func begin(with userId: String) {
        nearPeer.delegate = self
        nearPeer.joinPeers()
    }
    
    func broadcast(packet: Packet) {
        keepAlive?.invalidate()
        nearPeer.send(data: packet.stringValue.data(using: .utf8)!)
//        MultiPeer.instance.send(data: , type: RequestType.packetV1.rawValue)
        keepAlive = Timer.scheduledTimer(withTimeInterval: keepAliveInterval, repeats: false, block: { [weak self] _ in
            self?.broadcast(packet: packet)
        })
    }

    func end() {
        nearPeer.stop()
        nearPeer = NearPeer(serviceType: "cponair")
    }

}

extension Net: NearPeerDelegate {

    func handle(error: Error) {
        print("ERR \(error)")
    }

    func connectedPeersDidChange(to peers: Set<NearPeer.ID>) {
        print("Connected peers: \(peers)")
        connectedDevicesChanged(peers.map(\.id))
    }

    func didReceiveMessageFromPeer(message: Data, peer: NearPeer.ID) {
        guard let packet = Packet(string: String(data: message, encoding: .utf8) ?? "") else { return }
        didReceivePacket(packet)
    }

}
