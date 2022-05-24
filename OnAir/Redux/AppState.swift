//
//  AppState.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation

struct AppState: Equatable {

    let instanceId = UUID()
    var menu = Menu()
    var network = Network()
    var timers = Timer()

}
