//
//  LocalNetwork.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation
import NearPeer
import Combine

protocol LocalNetworkInterface {
    var state: AnyPublisher<[RemoteUserState], Never> { get }
    var status: AnyPublisher<NearPeer.State, Never> { get }
    var connectedPeers: AnyPublisher<[String], Never> { get }
    func start()
    func stop()
    func broadcast(state: UserState)
}

final class LocalNetwork {

    static let shared = LocalNetwork()
    private var nearPeer: NearPeer?
    @Published private var _state: [RemoteUserState] = []
    @Published private var _status: NearPeer.State = .idle
    @Published private var _connectedPeers: [String] = []

    private init() {}

}

extension LocalNetwork: LocalNetworkInterface {

    var state: AnyPublisher<[RemoteUserState], Never> {
        $_state
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var status: AnyPublisher<NearPeer.State, Never> {
        $_status.eraseToAnyPublisher()
    }

    var connectedPeers: AnyPublisher<[String], Never> {
        $_connectedPeers
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func start() {
        nearPeer?.stop()
        nearPeer = NearPeer(serviceType: "cponair")
        nearPeer?.delegate = self
        nearPeer?.joinPeers()
    }

    func stop() {
        nearPeer?.stop()
        nearPeer = nil
    }

    func broadcast(state: UserState) {
        guard let nearPeer = nearPeer else { return }
        var remoteState = RemoteState()
        remoteState.peerID = nearPeer.localID.id
        remoteState.peerName = state.name
        remoteState.isOnAir = state.isOnAir
        guard let data = try? remoteState.serializedData() else { return print("Cannot encode", remoteState) }
        nearPeer.broadcast(data: data)
    }

}

extension LocalNetwork: NearPeerDelegate {

    func connectedPeersDidChange(to peers: Set<NearPeer.ID>) {
        _connectedPeers = Array(peers).map(\.id)
        // Remove all invalid peers from the peerState cache
        _state = _state.filter {
            peers.contains(.init(id: $0.peerId))
        }
    }

    func didReceiveMessageFromPeer(message: Data, peer: NearPeer.ID) {
        if let state = try? RemoteState(serializedData: message) {
            let updatedUser = RemoteUserState(name: state.peerName, peerId: state.peerID, isOnAir: state.isOnAir, timestamp: Date())
            _state.removeAll(where: { $0.peerId == updatedUser.peerId })
            _state.append(updatedUser)
        } else {
            print("Unable to serialise message")
        }
    }

    func handle(error: Error) {
        print(#function, error)
    }

    func stateDidChange(from oldValue: NearPeer.State, to newState: NearPeer.State) {
        _status = newState
    }

}
