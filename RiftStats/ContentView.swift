import SwiftUI

struct ContentView: View {
    @StateObject private var apiService = RiotAPIService()
    @State private var searchText = ""
    @State private var player: Player?
    @State private var matches: [MatchDetail] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("RiftStats")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("GoldAccent"))

                        Text("Track Your League Performance")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search by Riot ID (Name#TAG)", text: $searchText)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Button(action: performSearch) {
                        Text("Search")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("GoldAccent"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(searchText.isEmpty || isLoading)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                    }

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("GoldAccent")))
                            .scaleEffect(1.5)
                            .padding()
                    }

                    // Results
                    if let player = player {
                        ScrollView {
                            VStack(spacing: 20) {
                                PlayerHeaderView(player: player)

                                Text("Recent Matches")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("GoldAccent"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)

                                ForEach(matches) { match in
                                    if let participant = match.info.participants.first(where: { $0.puuid == player.puuid }) {
                                        MatchCardView(match: match, participant: participant)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func performSearch() {
        let components = searchText.split(separator: "#")
        guard components.count == 2 else {
            errorMessage = "Invalid format. Use Name#TAG"
            return
        }

        let gameName = String(components[0])
        let tagLine = String(components[1])

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let (searchedPlayer, searchedMatches) = try await apiService.searchPlayer(
                    gameName: gameName,
                    tagLine: tagLine
                )

                await MainActor.run {
                    player = searchedPlayer
                    matches = searchedMatches
                    isLoading = false
                }
            } catch RiotAPIService.RiotAPIError.playerNotFound {
                await MainActor.run {
                    errorMessage = "Player not found"
                    isLoading = false
                }
            } catch RiotAPIService.RiotAPIError.apiError(let message) {
                await MainActor.run {
                    errorMessage = "API Error: \(message)"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error: \(error)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
