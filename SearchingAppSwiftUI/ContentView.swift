//
//  ContentView.swift
//  SearchingAppSwiftUI
//
//  Created by park kyung seok on 2021/06/04.
//

import SwiftUI

struct RSS: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let results: [Result]
}
struct Result: Decodable {
    let copyright, name, artworkUrl100, releaseDate: String
}

class GridViewModel: ObservableObject {
    
    @Published var items = 0..<10
    
    init() {
        fetch()
    }
    
    private func fetch() {
        
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/10/explicit.json") else  { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else { return }
            
            do {
                let rss = try JSONDecoder().decode(RSS.self, from: data)
                print(rss)
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
                LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                                    GridItem(.flexible(minimum: 100, maximum: 200))],
                          spacing: 12,
                          content: {
                            ForEach(vm.items, id: \.self) { num in
                              
                                VStack (alignment: .leading) {
                                    Spacer()
                                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .background(Color.blue)
                                    
                                    Text("App Title")
                                        .font(.system(size: 10, weight: .semibold))
                                    Text("Release Date")
                                        .font(.system(size: 9, weight: .regular))
                                    Text("Copyright")
                                        .font(.system(size: 9, weight: .regular))
                                }
                                .padding()
                                .background(Color.red)
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
