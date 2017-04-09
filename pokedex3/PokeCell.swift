//
//  PokeCell.swift
//  pokedex3
//
//  Created by PRO on 2/11/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var  thumbImg : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    
    //var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(_ pokemon: Pokemon) {
        
        nameLbl.text = pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
    }
    
}
