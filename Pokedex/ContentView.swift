//
//  ContentView.swift
//  Pokedex
//
//  Created by Jorge Mayta Guillermo on 6/20/20.
//  Copyright © 2020 Cibertec. All rights reserved.
//

import SwiftUI

let stringUrl = "https://pokeapi.co/api/v2/pokemon"

let url = URL(string: stringUrl)!

let session = URLSession.shared

struct Pokedex: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let url: String
}

class PokedexViewModel: ObservableObject {
    @Published var pokemons = [Pokemon]()
    
    func getPokemons() {
        session.dataTask(with: url){
            (data, response, error) in
            DispatchQueue.main.async {
                self.pokemons = try! JSONDecoder().decode(Pokedex.self, from: data!).results
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
