import Foundation
import Combine

class RiotAPIService: ObservableObject {
    private let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let key = config["RIOT_API_KEY"] as? String else {
            fatalError("API Key not found in Config.plist")
        }
        return key
    }()
    private let region = "americas"
    private let platformId = "na1"

    enum RiotAPIError: Error {
        case invalidURL
        case invalidResponse
        case playerNotFound
        case apiError(String)
    }

    // Fetch account by Riot ID
    func fetchAccount(gameName: String, tagLine: String) async throws -> Account {
        let urlString = "https://\(region).api.riotgames.com/riot/account/v1/accounts/by-riot-id/\(gameName)/\(tagLine)"

        guard let url = URL(string: urlString) else {
            throw RiotAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Riot-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RiotAPIError.invalidResponse
        }

        if httpResponse.statusCode == 404 {
            throw RiotAPIError.playerNotFound
        }

        guard httpResponse.statusCode == 200 else {
            throw RiotAPIError.apiError("Status code: \(httpResponse.statusCode)")
        }

        let account = try JSONDecoder().decode(Account.self, from: data)
        return account
    }

    // Fetch summoner by PUUID
    func fetchSummoner(puuid: String) async throws -> Summoner {
        let urlString = "https://\(platformId).api.riotgames.com/lol/summoner/v4/summoners/by-puuid/\(puuid)"

        guard let url = URL(string: urlString) else {
            throw RiotAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Riot-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RiotAPIError.invalidResponse
        }

        let summoner = try JSONDecoder().decode(Summoner.self, from: data)
        return summoner
    }

    // Fetch match IDs
    func fetchMatchIds(puuid: String, count: Int = 5) async throws -> [String] {
        let urlString = "https://\(region).api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?start=0&count=\(count)"

        guard let url = URL(string: urlString) else {
            throw RiotAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Riot-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RiotAPIError.invalidResponse
        }

        let matchIds = try JSONDecoder().decode([String].self, from: data)
        return matchIds
    }

    // Fetch match details
    func fetchMatchDetail(matchId: String) async throws -> MatchDetail {
        let urlString = "https://\(region).api.riotgames.com/lol/match/v5/matches/\(matchId)"

        guard let url = URL(string: urlString) else {
            throw RiotAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Riot-Token")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RiotAPIError.invalidResponse
        }

        let matchDetail = try JSONDecoder().decode(MatchDetail.self, from: data)
        return matchDetail
    }

    // Complete player search with matches
    func searchPlayer(gameName: String, tagLine: String) async throws -> (Player, [MatchDetail]) {
        let account = try await fetchAccount(gameName: gameName, tagLine: tagLine)
        let summoner = try await fetchSummoner(puuid: account.puuid)
        let matchIds = try await fetchMatchIds(puuid: account.puuid)

        var matches: [MatchDetail] = []
        for matchId in matchIds {
            if let match = try? await fetchMatchDetail(matchId: matchId) {
                matches.append(match)
            }
        }

        let player = Player(
            id: summoner.id ?? account.puuid,
            puuid: account.puuid,
            gameName: account.gameName,
            tagLine: account.tagLine,
            summonerLevel: summoner.summonerLevel,
            profileIconId: summoner.profileIconId
        )

        return (player, matches)
    }
}
