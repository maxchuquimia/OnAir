//
//  MessageDataSource.swift
//  OnAir
//
//  Created by Max Chuquimia on 15/6/2022.
//

import Foundation

protocol FriendlyMessageDataSourceInterface {
    func getDefaultMessage() -> String
    func getQuietMessage() -> String
}

final class FriendlyMessageDataSource {

    private struct MessageModel: Decodable {
        let onair: [String]
        let `default`: [String]
    }

    private let messages: MessageModel

    init() {
        let path = Bundle.main.url(forResource: "messages", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        messages = try! JSONDecoder().decode(MessageModel.self, from: data)
    }

}

extension FriendlyMessageDataSource: FriendlyMessageDataSourceInterface {

    func getDefaultMessage() -> String {
        messages.default.randomElement()!
    }

    func getQuietMessage() -> String {
        messages.onair.randomElement()!
    }

}
