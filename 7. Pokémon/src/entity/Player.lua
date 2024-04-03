--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    

    self.party = Party {
        pokemon = {
        }
    }
    local nStartingPokemon = 3
    for i = 1, nStartingPokemon do
      table.insert(self.party.pokemon, Pokemon(Pokemon.getRandomDef(), 5))
    end
    
end