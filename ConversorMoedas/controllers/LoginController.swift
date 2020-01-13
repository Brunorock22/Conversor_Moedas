//
//  LoginController.swift
//  ConversorMoedas
//
//  Created by Bruno Camargos on 08/01/20.
//  Copyright © 2020 Bruno Camargos. All rights reserved.
//

import UIKit
class LoginController:UIViewController{
    @IBOutlet weak var mLoginImage: UIImageView!

    @IBOutlet weak var mButtonLogin: ButtonCorner!

    @objc
    func clickButton(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "segueConverter") as? CambioConverter
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Desativa o keyboard em clique na tela
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        //Configura layout dos botoes
        mButtonLogin.layer.cornerRadius = 0.5 * mButtonLogin.frame.height
        mButtonLogin.layer.masksToBounds = true
        mButtonLogin.addTarget(self, action:  #selector(self.clickButton), for: UIControl.Event.touchUpInside)


    }
}
