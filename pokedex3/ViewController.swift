//
//  ViewController.swift
//  pokedex3
//
//  Created by PRO on 2/10/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    
    var filteredPokemon = [Pokemon]()
    
    var musicPlayer : AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        playMusic()
        
    }
    
    
    
    func playMusic() {
        
        let path = Bundle.main.url(forResource: "music", withExtension: "mp3")
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: path!)
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
                
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            if inSearchMode {
                let poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            }
            else{
                let poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke : Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        }
        else{
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeIdent", sender: poke)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        }
        else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }
        else{
            inSearchMode = true
            let keyword = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({ ($0.name.range(of: keyword) != nil) })
            collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeIdent" {
            if let dest = segue.destination as? SecondPokeVC {
                if let sender = sender as? Pokemon{
                    dest.pokemon = sender
                }
            }
        }
    }
    
}




