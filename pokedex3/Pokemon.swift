//
//  Pokemon.swift
//  pokedex3
//
//  Created by PRO on 2/11/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId : Int!
    private var _description : String!
    private var _defense : String!
    private var _height : String!
    private var _type : String!
    private var _weight : String!
    private var _attack : String!
    private var _nextEvoTxt : String!
    private var _nextEvoName : String!
    private var _nextEvoId : String!
    private var _nextEvoLvl : String!
    private var _pokemonURL : String!
    
    var nextEvoLvl : String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var nextEvoId : String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    
    var nextEvoName : String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var defense : String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height : String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var type : String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var weight : String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack : String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt : String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var name : String {
        
        return _name
    }
    
    var pokedexId : Int {
        
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(Base_URL)\(URL_Pokemon)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(complete: @escaping downloaded) {
        
        Alamofire.request(_pokemonURL).responseJSON{response in
            let result = response.result.value
            if let dict = result as? Dictionary<String, AnyObject> {
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let weight =  dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                                print(self.type)
                            }
                        }
                    }
                }
                else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"]  {
                        
                        let updateUrl = "\(Base_URL)\(url)"
                        
                        Alamofire.request(updateUrl).responseJSON {response in
                            
                            let result = response.result.value
                            
                            if let dict = result as? Dictionary<String, AnyObject> {
                                
                                if let description = dict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    
                                    print(description)
                                }
                            }
                            complete()
                            
                        }
                        
                    }
                    else{
                        self._description = ""
                    }
                    
                    if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolution.count > 0 {
                        
                        if let name = evolution[0]["to"] as? String {
                            
                            self._nextEvoName = name
                            
                        }
                        if let uri = evolution[0]["resource_uri"] as? String {
                            
                            let uri2 = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            
                            let urlFinal = uri2.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvoId = urlFinal
                        }
                        if let lvl = evolution[0]["level"] as? Int {
                            
                            self._nextEvoLvl = "\(lvl)"
                            
                        }
                    }
                    else {
                        
                        self._nextEvoLvl = ""
                        
                    }
                    
                    
                    complete()
                }
            }
        }
        
        
        
    }
}
