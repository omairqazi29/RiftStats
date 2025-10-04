import Foundation

struct Player: Codable, Identifiable {
    let id: String
    let puuid: String
    let gameName: String
    let tagLine: String
    let summonerLevel: Int
    let profileIconId: Int

    var displayName: String {
        "\(gameName)#\(tagLine)"
    }
}

struct Account: Codable {
    let puuid: String
    let gameName: String
    let tagLine: String
}

struct Summoner: Codable {
    let id: String?
    let accountId: String?
    let puuid: String
    let profileIconId: Int
    let summonerLevel: Int
}
