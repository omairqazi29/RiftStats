import Foundation

struct MatchHistory: Codable {
    let matches: [String]
}

struct MatchDetail: Codable, Identifiable {
    let metadata: MatchMetadata
    let info: MatchInfo

    var id: String { metadata.matchId }
}

struct MatchMetadata: Codable {
    let matchId: String
    let participants: [String]
}

struct MatchInfo: Codable {
    let gameCreation: Int64
    let gameDuration: Int
    let gameMode: String
    let participants: [Participant]
}

struct Participant: Codable, Identifiable {
    let puuid: String
    let summonerName: String
    let championName: String
    let championId: Int
    let kills: Int
    let deaths: Int
    let assists: Int
    let totalMinionsKilled: Int
    let neutralMinionsKilled: Int
    let win: Bool
    let item0: Int
    let item1: Int
    let item2: Int
    let item3: Int
    let item4: Int
    let item5: Int
    let item6: Int
    let goldEarned: Int
    let champLevel: Int
    let totalDamageDealtToChampions: Int

    var id: String { puuid }

    var kda: String {
        let kdaValue = deaths == 0 ? Double(kills + assists) : Double(kills + assists) / Double(deaths)
        return String(format: "%.2f", kdaValue)
    }

    var cs: Int {
        totalMinionsKilled + neutralMinionsKilled
    }

    var items: [Int] {
        [item0, item1, item2, item3, item4, item5, item6].filter { $0 != 0 }
    }
}
