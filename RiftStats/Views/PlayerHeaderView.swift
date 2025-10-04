import SwiftUI

struct PlayerHeaderView: View {
    let player: Player

    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.19.1/img/profileicon/\(player.profileIconId).png")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color("GoldAccent"))
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color("GoldAccent"), lineWidth: 3))

            Text(player.displayName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            HStack {
                Text("Level")
                    .foregroundColor(.gray)
                Text("\(player.summonerLevel)")
                    .foregroundColor(Color("GoldAccent"))
                    .fontWeight(.semibold)
            }
            .font(.system(size: 14))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("CardBackground"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
