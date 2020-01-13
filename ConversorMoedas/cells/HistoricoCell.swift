//
//  Bruno Camargos Nogueira

import UIKit

class HistoricoCell: UITableViewCell {

    @IBOutlet weak var mResultado: UILabel!
    @IBOutlet weak var mDestino: UILabel!
    @IBOutlet weak var mOrigem: UILabel!
    @IBOutlet weak var mValor: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
