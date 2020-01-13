//
//  CambioConverter.swift
//  ConversorMoedas
//
//  Created by Bruno Camargos on 08/01/20.
//  Copyright © 2020 Bruno Camargos. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire
import CoreData

class CambioConverter: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let hud = JGProgressHUD(style: .dark)

    var resultadoFinal: Double = 0

    @IBAction func mButtonSalvar(_ sender: Any) {
        saveData()

    }

    @IBOutlet weak var mValorDesejado: UITextField!
    @IBOutlet weak var mResultado: UITextField!

    @IBOutlet weak var mDestinoPicker: UIPickerView!
    @IBOutlet weak var mOrigemPicker: UIPickerView!
    var listCoins: [Moeda] = []
    var moedaDestino = Moeda(pais: "", valor: 0)
    var moedaOrigem = Moeda(pais: "", valor: 0)

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return listCoins.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (listCoins.count != 0) {
            return listCoins[row].getPais()
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {


        if pickerView == mOrigemPicker {
            moedaOrigem = self.listCoins[row]
            calculValores()
        }
        if pickerView == mDestinoPicker {
            moedaDestino = self.listCoins[row]
            calculValores()
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc
    func historicoButton() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "segueHistorico") as? HistoricoController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ConverDats", in: context)
        let newTransaction = NSManagedObject(entity: entity!, insertInto: context)
        newTransaction.setValue(moedaOrigem.getPais(), forKey: "origem")
        newTransaction.setValue(moedaDestino.getPais(), forKey: "destino")
        newTransaction.setValue(Double(mValorDesejado.text!), forKey: "valorOrigem")
        newTransaction.setValue(resultadoFinal, forKey: "valorDestino")

        do {
            try context.save()

            let alert = UIAlertController(title: "Conversão Salva com sucesso!", message: "Acesse seus históricos caso deseje busca-la.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.hud.dismiss()

        } catch {
            print("Failed saving")
        }


    }

    override func viewDidLoad() {
        mDestinoPicker.delegate = self
        mOrigemPicker.delegate = self
        mOrigemPicker.dataSource = self
        mDestinoPicker.dataSource = self
        //Botao de historico no navibar
        let mapButton = UIBarButtonItem(title: "Histórico", style: .done, target: self, action: #selector(self.historicoButton))
        self.navigationItem.rightBarButtonItem = mapButton

        //Desativa o keyboard em clique na tela
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)

        requisaoMoedas()

    }

    private func calculValores() {
        //Transforma o valor desejado em EUR, depois calculo a taxa de cambio com país desejado.
        if mValorDesejado.text != "" && listCoins.count != 0 {
            var valorDesejado = mValorDesejado.text
            let valorDesejadoDouble = Double(mValorDesejado.text!)
            var moedaTransformadaEUR = valorDesejadoDouble! / moedaOrigem.getValor()
            resultadoFinal = moedaTransformadaEUR * moedaDestino.getValor()
            mResultado.text = String(format: "%.2f", resultadoFinal)
        }
    }

    func requisaoMoedas() {
        //
        Alamofire.request(("https://api.exchangeratesapi.io/latest"), method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            //
            //lista da tableview
            self.listCoins.removeAll()
            //lista para o mapa
            print(response.response?.statusCode)
            //
            if response.response?.statusCode == 200 {
                let json = response.result.value as! NSDictionary
                //
                let callJSON = json["rates"] as! NSDictionary

                for (key, value) in callJSON {

                    var pais: String = key as! String
                    var valor: Double = value as! Double

                    self.listCoins.append(Moeda(pais: pais, valor: valor))
                }
                self.mDestinoPicker.reloadAllComponents()
                self.mOrigemPicker.reloadAllComponents()
            }
        }
    }

}

