import SwiftUI

struct MatchCardView: View {
    let match: MatchDetail
    let participant: Participant

    private var timeAgo: String {
        let date = Date(timeIntervalSince1970: TimeInterval(match.info.gameCreation) / 1000)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private var gameDuration: String {
        let minutes = match.info.gameDuration / 60
        let seconds = match.info.gameDuration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Win/Loss Indicator
            Rectangle()
                .fill(participant.win ? Color.green : Color.red)
                .frame(width: 4)

            // Champion Icon
            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.19.1/img/champion/\(participant.championName).png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(participant.championName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(participant.win ? "Victory" : "Defeat")
                    .font(.system(size: 12))
                    .foregroundColor(participant.win ? .green : .red)

                Text(timeAgo)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(participant.kills)/\(participant.deaths)/\(participant.assists)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text("KDA: \(participant.kda)")
                    .font(.system(size: 12))
                    .foregroundColor(Color("GoldAccent"))

                Text("CS: \(participant.cs)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }

            // Items
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(Array(participant.items.prefix(4).enumerated()), id: \.offset) { index, itemId in
                        AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.19.1/img/item/\(itemId).png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(width: 20, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }

                if participant.items.count > 4 {
                    HStack(spacing: 2) {
                        ForEach(Array(participant.items.suffix(from: 4).enumerated()), id: \.offset) { index, itemId in
                            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.19.1/img/item/\(itemId).png")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                            }
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(participant.win ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
