//
//  HistoricoController.swift
//  ConversorMoedas
//
//  Created by Bruno Camargos on 10/01/20.
//  Copyright © 2020 Bruno Camargos. All rights reserved.
//

import UIKit
import CoreData

class HistoricoController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var seachText: String = ""
    var searchActive: Bool = false

    @IBOutlet weak var mSearch: UISearchBar!
    @IBOutlet weak var mTableView: UITableView!

    var filteredList = [Historico]()
    var listHistoricos: [Historico] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredList.count
        } else {
            return listHistoricos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoCell", for: indexPath) as! HistoricoCell

        if (searchActive) {
            let historicoCell: Historico = filteredList[indexPath.row]
            cell.mOrigem?.text = historicoCell.origem
            cell.mResultado.text = String(format: "%.2f", (historicoCell.resultado))
            cell.mValor.text = String(format: "%.2f", (historicoCell.valor))
            cell.mDestino?.text = historicoCell.destino
            return cell

        } else {
            cell.mResultado.text = String(format: "%.2f", (listHistoricos[indexPath.row].getResultado()))
            cell.mValor.text = String(format: "%.2f", (listHistoricos[indexPath.row].getValor()))
            cell.mOrigem.text = listHistoricos[indexPath.row].getOrigem()
            cell.mDestino.text = listHistoricos[indexPath.row].getDestino()
            return cell
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mSearch.delegate = self
        mTableView.delegate = self
        mTableView.dataSource = self

        returnData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        seachText = searchBar.text!
        filteredList.removeAll()
        filteredList = listHistoricos.filter({ (text) -> Bool in
            let tmp: NSString = text.origem as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if (filteredList.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.mTableView.reloadData()

    }

    func returnData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConverDats")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var origemData = data.value(forKey: "origem") as! String
                var destinoData = data.value(forKey: "destino") as! String
                var resultadoData = data.value(forKey: "valorDestino") as! Double
                var valorData = data.value(forKey: "valorOrigem") as! Double
                self.listHistoricos.append(Historico(origem: origemData, destino: destinoData, resultado: resultadoData, valor: valorData))
            }
            mTableView.reloadData()
        } catch {

            print("Failed")
        }

    }
}



