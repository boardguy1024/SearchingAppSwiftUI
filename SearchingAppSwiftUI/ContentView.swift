//
//  ContentView.swift
//  SearchingAppSwiftUI
//
//  Created by park kyung seok on 2021/06/04.
//

import SwiftUI
import Kingfisher

struct RSS: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let results: [Result]
}
struct Result: Decodable, Hashable {
    let copyright, name, artworkUrl100, releaseDate: String
}

class GridViewModel: ObservableObject {
        
    @Published var results = [Result]()
    
    init() {
        fetch()
    }
    
    private func fetch() {
        
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/10/explicit.json") else  { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else { return }
            
            do {
                let rss = try JSONDecoder().decode(RSS.self, from: data)
                DispatchQueue.main.async {
                    self.results = rss.feed.results
                }
            } catch {
                print("Failed to decode: \(error)")
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var vm = GridViewModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12, alignment: .top),
                                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12, alignment: .top),
                                    GridItem(.flexible(minimum: 100, maximum: 200), alignment: .top)],
                          spacing: 12,
                          content: {
                            ForEach(vm.results, id: \.self) { result in
                                AppInfo(app: result)
                            }
                          }).padding(.horizontal, 12)
            }.navigationTitle("Grid Search")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AppInfo: View {
    
    let app: Result
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            KFImage(URL(string: app.artworkUrl100))
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(16)
            
            Text(app.name)
                .font(.system(size: 10, weight: .semibold))
                .padding(.top, 6)
            
            Text(app.releaseDate)
                .font(.system(size: 9, weight: .regular))
            Text(app.copyright)
                .font(.system(size: 9, weight: .regular))
        }
        .padding(.horizontal)
    }
}
