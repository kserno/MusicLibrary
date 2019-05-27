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
    var model: AlbumModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateBarcode(barcode: barcode)
        // Do any additional setup after loading the view.
        
    }
    
    func updateBarcode(barcode: String?) {
        self.barcode = barcode
        if (barcode != nil) {
            /*DispatchQueue.main.async {
               // self.startLoading()
            }*/ 
            DiscogsApi().searchByBarcode(barcode: barcode!)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: {
                    model in
                    self.model = model
                    self.createView(model: model)
                }, onError: {
                    error in
                    print(error)
                }).disposed(by: disposeBag)
        }
    }
    
    private func startLoading() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let width = view.frame.width
        let height = view.frame.height
        
        let spinnerSize = CGFloat(40)
        
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: width / 2 - spinnerSize / 2, y: height/2 - spinnerSize / 2,
                               width: spinnerSize, height: spinnerSize)
        
        view.addSubview(spinner)
        spinner.startAnimating()
    
        

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
        
        let width = Double(view.frame.width)
        let ivCover = UIImageView()
        ivCover.frame = CGRect(x:0, y:0, width: width, height:300)
        
        print(model.thumbUrl)
        ivCover.kf.setImage(with: URL(string: model.thumbUrl))
        
        let lbTitle = UILabel()
        
        lbTitle.frame = CGRect(x: leftPadding,y: 16, width: width - 2 * leftPadding, height: 80)
        lbTitle.text = model.title
        view.addSubview(lbTitle)
        
        let lbArtist = UILabel()
        lbArtist.frame = CGRect(x: leftPadding, y: 72, width: width - 2 * leftPadding, height: 40)
        lbArtist.text = model.genres.joined(separator: " / ")
        view.addSubview(lbArtist)
        
        print(model.artistName)
        print(model.title)
        
        
        
        let btDetail = UIButton()
        btDetail.backgroundColor = UIColor.black
        btDetail.frame = CGRect(x: leftPadding, y: 128, width: 56, height: 40)
        btDetail.setTitle("Detail", for: UIControl.State.normal)
        btDetail.addTarget(self
            , action: #selector(detailClick), for: UIControl.Event.touchUpInside)
        
        view.addSubview(btDetail)
    

    }
    
    @objc func detailClick() {
        arController?.navigateDetail(masterId: model?.id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ard dis")
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
