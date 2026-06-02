import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.topUsers.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Memuat data peringkat...")
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Top 3 Podium
                            if viewModel.topUsers.count >= 3 {
                                HStack(alignment: .bottom, spacing: 12) {
                                    PodiumView(user: viewModel.topUsers[1], rank: 2, height: 120, color: .gray)
                                    PodiumView(user: viewModel.topUsers[0], rank: 1, height: 160, color: .yellow)
                                    PodiumView(user: viewModel.topUsers[2], rank: 3, height: 100, color: .orange)
                                }
                                .padding(.vertical, 20)
                            }
                            
                            // Rest of the list
                            VStack(spacing: 12) {
                                let startIndex = viewModel.topUsers.count >= 3 ? 3 : 0
                                if startIndex < viewModel.topUsers.count {
                                    ForEach(Array(viewModel.topUsers[startIndex...].enumerated()), id: \.element.id) { index, user in
                                        LeaderboardRow(rank: index + startIndex + 1, user: user)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Papan Peringkat")
            .task {
                await viewModel.fetchLeaderboard()
            }
            .refreshable {
                await viewModel.fetchLeaderboard()
            }
        }
    }
}

struct PodiumView: View {
    var user: RankModel
    var rank: Int
    var height: CGFloat
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .foregroundColor(color)
                .font(.title2)
            
            Text(user.nama)
                .font(.caption)
                .fontWeight(.bold)
                .lineLimit(1)
            
            Text("\(user.score)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.3))
                    .frame(width: 80, height: height)
                
                Text("\(rank)")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(color)
                    .padding(.top, 10)
            }
        }
    }
}

struct LeaderboardRow: View {
    var rank: Int
    var user: RankModel
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(rank)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .leading)
            
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: "person.fill").foregroundColor(.blue))
            
            Text(user.nama)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(user.score)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("Pts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    LeaderboardView()
}
