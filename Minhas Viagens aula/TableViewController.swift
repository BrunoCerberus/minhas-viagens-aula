//
//  ViewController.swift
//  Minhas Viagens aula
//
//  Created by Bruno Lopes de Mello on 05/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var locaisViagens : [Dictionary<String , String>] = []
    let gerenciadorArmazenamento = ViagensDefaults()
    var controleNavegacao = "adicionar"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
       atualizarViagens()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locaisViagens.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viagem = self.locaisViagens[indexPath.row]["local"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        cell.textLabel?.text = viagem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            gerenciadorArmazenamento.removerViagem(indexPath.row)
            atualizarViagens()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleNavegacao = "listar"
        print(self.locaisViagens[indexPath.row]["local"]!)
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocal" {
            let viewControllerDestino = segue.destination as! MapaViagemViewController
            if self.controleNavegacao == "listar" {
                if let _indiceRecuperado = sender {
                    let _indice = _indiceRecuperado as! Int
                    viewControllerDestino.viagem = locaisViagens[_indice]
                    viewControllerDestino.indiceSelecionado = _indice
                }
            } else {
                viewControllerDestino.viagem = [:]
                viewControllerDestino.indiceSelecionado = -1
            }
        }
    }
    
    func atualizarViagens() {
        self.locaisViagens = self.gerenciadorArmazenamento.listarViagens()
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}

