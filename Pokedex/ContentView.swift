//
//  ContentView.swift
//  Pokedex
//
//  Created by Jorge Mayta Guillermo on 6/20/20.
//  Copyright © 2020 Cibertec. All rights reserved.
//

import SwiftUI



struct PokedexResponse: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let url: String
}

class PokedexViewModel: ObservableObject {
    var page = 0
    var loading = false
 
    
    @Published var pokemons = [Pokemon]()
    
    func shouldLoadMoreData() -> Bool {
      return true
    }
    
    func getPokemons() {
        
        if !shouldLoadMoreData(){
            return
        }
        let stringUrl = "https://pokeapi.co/api/v2/pokemon?offset=\(page)&limit=20"

        let url = URL(string: stringUrl)!

         let session = URLSession.shared
        session.dataTask(with: url){
            (data, response, error) in
            DispatchQueue.main.async {
                self.pokemons = try! JSONDecoder().decode(PokedexResponse.self, from: data!).results
                self.page += 20
                self.loading = false
            }
        }.resume()
    }
}

struct PokemonRowView: View {
    let pokemon: Pokemon
    var body: some View {
        HStack(alignment: .center ){
            Text(pokemon.name.capitalized)
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var pokedexVM = PokedexViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(pokedexVM.pokemons) { pokemon in
                    PokemonRowView(pokemon: pokemon)
                }
            }.navigationBarTitle(Text("Pokedex"))
            
        }.onAppear{
            self.pokedexVM.getPokemons()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
