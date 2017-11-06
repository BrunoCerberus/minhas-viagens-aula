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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGerenciadorLocalizacao()
        
        let reconhecedorDeGesto = UILongPressGestureRecognizer(target: self, action: #selector(marcar))
        reconhecedorDeGesto.minimumPressDuration = 1
        
        mapa.addGestureRecognizer(reconhecedorDeGesto)
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
                        
                    }
                    
                    let anotacao = MKPointAnnotation()
                    anotacao.coordinate.latitude = coordenadas.latitude
                    anotacao.coordinate.longitude = coordenadas.longitude
                    anotacao.title = _localCompleto
                    
                    self.mapa.addAnnotation(anotacao)
                    
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
        
    }
    
}
