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

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Games") {
                    ForEach(games, id: \.id) { row in
                        
                        // NavigationLink is based on a Hashable Data now
                        NavigationLink(value: row) {
                            Label(row.title, systemImage: row.image)
                        }
                    }
                }
                
                Section("Movies") {
                    ForEach(movies, id: \.id) { row in
                        
                        // NavigationLink is based on a Hashable Data now
                        NavigationLink(value: row) {
                            Text(row.title)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .padding(0)
            .navigationTitle("Root screen")
            
            //.navigationDestination(for: Hashable.Protocol, destination: (Hashable) -> View)
            .navigationDestination(for: Game.self) { row in
                GameScreen(row: row, path: $path)
            }
            .navigationDestination(for: Movie.self) { row in
                MovieScreen(row: row, path: $path)
            }
        }
    }
}

struct MovieScreen: View {
    let row: Movie
    @Binding private var path: NavigationPath
    
    init(row: Movie, path: Binding<NavigationPath>) {
        self.row = row
        self._path = path
    }
    
    var body: some View {
        ZStack {
            row.color.ignoresSafeArea(.all).opacity(0.3)
            
            VStack(spacing: 20) {
                Text(row.title)
                    .font(.largeTitle)
                
                Button("Open screen with random Game") {
                    path.append(games[Int.random(in: 0...2)])
                }
            }
        }
    }
}

struct GameScreen: View {
    let row: Game
    @Binding private var path: NavigationPath
    
    init(row: Game, path: Binding<NavigationPath>) {
        self.row = row
        self._path = path
    }
    
    var body: some View {
        ZStack {
            row.color.ignoresSafeArea(.all).opacity(0.3)
            
            VStack(spacing: 20) {
                Image(systemName: row.image)
                Text(row.title)
                    .font(.headline)
                
                Button("Append 1 random Game Screen") {
                    path.append(games[Int.random(in: 0...2)])
                }
                
                Button("Pop last Screen") {
                    path.removeLast()
                }
                
                Button("Pop to Root") {
                    path.removeLast(path.count)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
