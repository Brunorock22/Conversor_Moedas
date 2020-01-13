//
//  Moeda.swift
//  ConversorMoedas
//
//  Created by Rodrigo Bruno Camargos Nogueira on 09/01/20.
//  Copyright © 2020 Bruno Camargos. All rights reserved.
//


import UIKit

class Moeda{
         var pais = String()
         var valor = Double()

        init(pais: String, valor: Double) {
                self.pais = pais
                self.valor = valor
        }

        func getPais()->String{
                return pais
        }
        func getValor()->Double{
                return valor
        }
}
