//
//  Redux.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation
import Reduks
import ReduksTimer

let store = Store(initialState: AppState())

func setupRedux() {
    store.debugActions = true

    // Interceptors
    store.use(interceptor: networkActionInterceptor, lense: \.network)
    store.use(interceptor: incomingNetworkActionInterceptor)
    store.use(interceptor: broadcastStateActionInterceptor)

    // Reducers
    store.use(reducer: menuBarReducer, lense: \.menu)
    store.use(reducer: networkActionReducer, lense: \.network)
    store.use(reducer: userStateReducer, lense: \.menu.currentUser)

    // Subscribers
    store.add(subscriber: menuStateSubscriber, lense: \.menu)
    store.add(subscriber: userStateSubscriber, lense: \.menu.currentUser)

    // Timers
    let broadcastTimer = ReduksTimerConfiguration(timeInterval: 10.0, tolerance: 5.0, actionEmitted: RefreshStateAction())
    store.add(timer: broadcastTimer, isActive: \.timers.isBroadcastTimerActive)

    boostrapNotificationCenter()
}
