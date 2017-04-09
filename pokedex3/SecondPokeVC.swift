//
//  SecondPokeVC.swift
//  pokedex3
//
//  Created by PRO on 2/13/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit

class SecondPokeVC: UIViewController {
    
    
    var pokemon : Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokemonIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        self.mainImg.image = img
        self.currentEvoImg.image = img
        nameLbl.text = pokemon.name.capitalized
        
        pokemon.downloadPokemonDetails {
            //updateUI()
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokemonIDLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            nextEvoImg.isHidden = true
            evolutionLbl.text = "No Evolution"
        }
        else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvoId)")
            evolutionLbl.text = "Next Evolution: \(pokemon.nextEvoName) - LVL\(pokemon.nextEvoLvl)"
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
