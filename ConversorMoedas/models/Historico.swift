
import UIKit

class Historico: NSObject{
    var origem = String()
    var destino = String()
    var resultado = Double()
    var valor = Double()

    init(origem: String, destino: String, resultado: Double,valor:Double) {
        self.origem = origem
        self.destino = destino
        self.resultado = resultado
        self.valor = valor
    }

    func getOrigem()->String{
        return origem
    }
    func getDestino()->String{
        return destino
    }
    func getResultado()->Double{
        return resultado
    }
    func getValor()->Double{
        return valor
    }
}
