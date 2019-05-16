//
//  ViewController.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Lukas on 18/03/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    var disposeBag: DisposeBag? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        
        let barcode = "60255748262"
        
    }


}

