//
//  ARAlbumViewController.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 03/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import RxSwift

class ARAlbumViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    var arController: ArSceneViewController? = nil
    var barcode: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        DiscogsApi().searchByBarcode(barcode: barcode!)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: {
                model in
                self.createView(model: model)
            }, onError: {
                error in
                print(error)
            }).disposed(by: disposeBag)
        
    }
    
    
    func createView(model: AlbumModel) {
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        var leftPadding = 16.0
        //var rightPadding = 16.0
        
        /*if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            leftPadding = Double((window?.safeAreaInsets.left)!)
            rightPadding = Double((window?.safeAreaInsets.right)!)
        }*/
        
        let lbTitle = UILabel()
        let width = Double(view.frame.width)
        lbTitle.frame = CGRect(x: leftPadding,y: 16, width: width - 2 * leftPadding, height: 80)
        lbTitle.text = "Title"
        view.addSubview(lbTitle)
        
        let lbArtist = UILabel()
        lbArtist.frame = CGRect(x: leftPadding, y: 72, width: width - 2 * leftPadding, height: 40)
        lbArtist.text = "Artist"
        view.addSubview(lbArtist)
        
        let btDetail = UIButton()
        btDetail.backgroundColor = UIColor.black
        btDetail.frame = CGRect(x: leftPadding, y: 128, width: 56, height: 40)
        btDetail.setTitle("Detail", for: UIControl.State.normal)
        btDetail.addTarget(self
            , action: #selector(detailClick), for: UIControl.Event.touchUpInside)
        
        view.addSubview(btDetail)
    

    }
    
    @objc func detailClick() {
        arController?.navigateDetail()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
