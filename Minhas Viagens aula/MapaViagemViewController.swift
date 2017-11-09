//
//  MapaViagemViewController.swift
//  Minhas Viagens aula
//
//  Created by Bruno Lopes de Mello on 05/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapaViagemViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var viagem : Dictionary<String, String> = [:]
    let armazenadorViagem = ViagensDefaults()
    var indiceSelecionado : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indice = indiceSelecionado {
            if indice == -1 {//adicionar
                configurarGerenciadorLocalizacao()
            } else {//listar
                exibirAnotacao(viagem)
            }
        }
        
        let reconhecedorDeGesto = UILongPressGestureRecognizer(target: self, action: #selector(marcar))
        reconhecedorDeGesto.minimumPressDuration = 1
        
        mapa.addGestureRecognizer(reconhecedorDeGesto)
    }
    
    func exibirAnotacao(_ viagem: Dictionary<String, String>) {
        
        if let localViagem = viagem["local"] {
            if let latitude = viagem["latitude"] {
                if let longitude = viagem["longitude"] {
                    
                    let anotacao = MKPointAnnotation()
                    anotacao.coordinate.latitude = Double(latitude)!
                    anotacao.coordinate.longitude = Double(longitude)!
                    anotacao.title = localViagem
                    
                    self.mapa.addAnnotation(anotacao)
                    
                    exibirLocal(Double(latitude)!, Double(longitude)!)
                }
            }
        }
        
    }
    
    @objc func marcar(gesture: UIGestureRecognizer) {
        
        
        
        if gesture.state == UIGestureRecognizerState.began {
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            var _localCompleto = "Endereco nao encontrado!"
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (local, erro) in
                if erro == nil {
                    if let dadosLocal = local?.first {
                        
                        if let _nome = dadosLocal.name {
                            _localCompleto = _nome
                        } else {
                            
                            if let _endereco = dadosLocal.thoroughfare {
                                _localCompleto = _endereco
                            } else {
                                
                                if let _local = dadosLocal.subThoroughfare {
                                    _localCompleto = _local
                                }
                                
                            }
                            
                        }
                        
                        //Salvar dados no dispositivo
                        self.viagem = ["local":_localCompleto, "latitude": String(coordenadas.latitude),
                                       "longitude":String(coordenadas.longitude)]
                        
                        self.armazenadorViagem.salvarViagem(self.viagem)
                        
                        print(self.viagem)
                    }
                    
                    self.exibirAnotacao(self.viagem)
                    
                } else {
                    print(erro!)
                }
            })
            
            
        }
        
        
    }
    
    func configurarGerenciadorLocalizacao() {
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            let Alerta = UIAlertController(title: "Permissao de localizacao", message: "Necessario permissao para acesso a" +
                " sua localizacao!! por favor habilite", preferredStyle: UIAlertControllerStyle.alert)
            
            let acoesConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: UIAlertActionStyle.default,
                                                   handler: { (alertaConfiguracoes) in
                                                    
                                                    if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                                                        UIApplication.shared.open(configuracoes as URL)
                                                    }
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler: nil)
            
            Alerta.addAction(acoesConfiguracoes)
            Alerta.addAction(cancelar)
            
            present(Alerta, animated: true, completion: nil)
        }
        
        
    }
    
    func exibirLocal(_ latitude: Double,_ longitude: Double) {
        let latitudeDelta : CLLocationDegrees = 0.05
        let longitudeDelta : CLLocationDegrees = 0.05
        
        let aproximacao : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let regiao : MKCoordinateRegion = MKCoordinateRegion(center: coordenadas, span: aproximacao)
        
        self.mapa.setRegion(regiao, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacao = locations.last!
        
        exibirLocal(localizacao.coordinate.latitude, localizacao.coordinate.longitude)
    }
    
}
