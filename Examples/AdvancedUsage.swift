import SwiftUI

struct Game: Identifiable, Hashable {
    var id = UUID()
    
    let title: String
    let image: String
    let color: Color
}

struct Movie: Identifiable, Hashable {
    var id = UUID()
    
    let title: String
    let color: Color
}


let games: [Game] = [
    .init(title: "Counter-Strike", image: "globe.americas.fill", color: .brown),
    .init(title: "Warcraft", image: "globe.americas", color: .red),
    .init(title: "Cod", image: "sun.max.fill", color: .purple)
]

let movies: [Movie] = [
    .init(title: "Spiderman", color: .orange),
    .init(title: "Batman", color: .blue),
    .init(title: "Witcher", color: .green)
]

class NavigationWrapper: ObservableObject {

    enum NavigationType: Hashable {
        case movie(value: Movie)
        case game(value: Game)
    }
    
    @Published var path: [NavigationType] = []

    init() {
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func push(_ type: NavigationType) {
        path.append(type)
    }
    
    /*
     1) Subscribe on Naviigation state changes
     2) Convert this state into NavigationType
     
     private func convertToSwiftNavigationType(kotlinNavigationState: NavigationState) -> NavigationType {
         switch kotlinNavigationState {
         case is NavigationState.Root:
             return .root
         case let gameDetail as NavigationState.GameDetail:
             let game = Game(id: gameDetail.game.id, title: gameDetail.game.title, image: gameDetail.game.image)
             return .game(game)
         case let movieDetail as NavigationState.MovieDetail:
             let movie = Movie(id: movieDetail.movie.id, title: movieDetail.movie.title)
             return .movie(movie)
         default:
             return .root // or handle unexpected cases as needed
         }
     }
     */
}

struct ContentView: View {
    
    @EnvironmentObject private var navigationWrapper: NavigationWrapper
    
    var body: some View {
        NavigationStack(path: $navigationWrapper.path) {
            TabView {
                Text("Home")
                    .tabItem { Image(systemName: "house") }
                
                Text("Search")
                    .tabItem { Image(systemName: "magnifyingglass") }
                
                Text("Favorites")
                    .tabItem { Image(systemName: "suit.heart.fill") }
                
                Text("Profile")
                    .tabItem { Image(systemName: "person.circle.fill") }
            }
            .listStyle(.insetGrouped)
            .padding(0)
            .navigationTitle("Root screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationWrapper.push(.game(value: games.randomElement()!))
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationWrapper.push(.movie(value: movies.randomElement()!))
                    } label: {
                        Image(systemName: "heart")
                    }
                }
            }
            //.navigationDestination(for: Hashable.Protocol, destination: (Hashable) -> View)
            .navigationDestination(for: NavigationWrapper.NavigationType.self) { type in
                switch type {
                case .game(let game): GameScreen(row: game)
                case .movie(let movie): MovieScreen(row: movie)
                }
            }
        }
    }
}

struct MovieScreen: View {
    let row: Movie
    
    @EnvironmentObject private var navigationWrapper: NavigationWrapper

    init(row: Movie) {
        self.row = row
    }
    
    var body: some View {
        ZStack {
            row.color.ignoresSafeArea(.all).opacity(0.3)
            
            VStack(spacing: 20) {
                Text(row.title)
                    .font(.largeTitle)
                
                Button("Open screen with random Game") {
                    navigationWrapper.path.append(.game(value: games[Int.random(in: 0...2)]))
                }
            }
        }
    }
}

struct GameScreen: View {
    let row: Game
    
    @EnvironmentObject private var navigationWrapper: NavigationWrapper

    init(row: Game) {
        self.row = row
    }
    
    var body: some View {
        ZStack {
            row.color.ignoresSafeArea(.all).opacity(0.3)
            
            VStack(spacing: 20) {
                Image(systemName: row.image)
                Text(row.title)
                    .font(.headline)
                
                Button("Append 1 random Game Screen") {
                    navigationWrapper.push(.game(value: games[Int.random(in: 0...2)]))
                }
                
                Button("Pop last Screen") {
                    navigationWrapper.pop()
                }
                
                Button("Pop to Root") {
                    navigationWrapper.popToRoot()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
