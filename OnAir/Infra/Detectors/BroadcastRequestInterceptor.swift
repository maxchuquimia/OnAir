//
//  BroadcastRequestInterceptor.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation
import Reduks

struct RefreshStateAction: Action {}
struct UserStateAction: Action {
    let isOnAir: Bool
}

private let detectors: [Detector] = [
    BentoBoxReader(),
    OrangeDotLocator()
]

let broadcastStateActionInterceptor = { (action: RefreshStateAction, state: AppState) -> InterceptorResult in
    let isOnAir = detectors.isQuietRequired
    return .map(UserStateAction(isOnAir: isOnAir))
}

let userStateReducer = { (action: UserStateAction, state: inout AppState.Menu.User) in
    state.isOnAir = action.isOnAir
}

let userStateSubscriber = { (state: AppState.Menu.User, dispatcher: ActionDispatcher) in
    let packet = Packet(name: state.name, id: state.id, isOnAir: state.isOnAir)
    guard let data = packet.stringValue.data(using: .utf8) else { return }
    dispatcher.dispatch(NetworkAction.broadcast(data: data))
}

//private enum BroadcastError: Action {
//    case unableToMakePacket
//}
