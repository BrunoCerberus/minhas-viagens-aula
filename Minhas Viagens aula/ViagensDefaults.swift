//
//  ViagensDefaults.swift
//  Minhas Viagens aula
//
//  Created by Bruno Lopes de Mello on 05/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class ViagensDefaults {
    
    let chaveArmazenamento = "locaisViagem"
    var viagens : [ Dictionary<String, String> ] = []
    
    func salvarViagem(_ viagem: Dictionary<String, String>) {
        
        viagens = listarViagens()
        
        viagens.append(viagem)
        
        //Persistir dados no dispositivo
        UserDefaults.standard.set(viagens, forKey: chaveArmazenamento)
        UserDefaults.standard.synchronize()
    }
    
    func listarViagens() -> [ Dictionary<String, String> ]{
        let dados =  UserDefaults.standard.object(forKey: chaveArmazenamento)
        if dados != nil {
            return dados as! Array
        } else {
            return []
        }
    }
    
    func removerViagem(_ indice: Int) {
        
        viagens = listarViagens()
        viagens.remove(at: indice)
        
        UserDefaults.standard.set(viagens, forKey: chaveArmazenamento)
        UserDefaults.standard.synchronize()
    }
    
}
