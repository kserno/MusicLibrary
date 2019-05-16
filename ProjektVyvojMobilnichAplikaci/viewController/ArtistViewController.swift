//
//  ArtistViewController.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 08/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ArtistViewController: UITableViewController {
    
    var id: Int? = nil
    
    private var model: ArtistModel? = nil
    private var releases: [ReleaseModel] = [ReleaseModel]()
    
    @IBOutlet var ivArtistTop: NSLayoutConstraint!
    @IBOutlet var ivArtistHeight: NSLayoutConstraint!
    
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var ivArtist: UIImageView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbNote: UILabel!
    
    var originalHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        if (id != nil) {
            DiscogsApi().getArtist(id: id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: {
                    model in
                    self.model = model
                    self.updateView()
                }, onError: {
                    error in
                    print(error)
                }).disposed(by: disposeBag)
            
            DiscogsApi().getReleases(id: id!)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: {
                    result in
                    self.releases = result
                    self.tableView.reloadData()
                }, onError: {
                    error in
                    print(error)
                }).disposed(by: disposeBag)
        }
        ivArtist.contentMode = .scaleAspectFill
        ivArtist.clipsToBounds = true
        
        originalHeight = ivArtistHeight.constant


        // Do any additional setup after loading the view.
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        let defaultTop: CGFloat = CGFloat(0)
        
        var currentTop: CGFloat = defaultTop
        
        if offset < 0{
            currentTop = offset
            ivArtistHeight.constant = originalHeight - offset
        }else{
            ivArtistHeight.constant = originalHeight
        }
        
        ivArtistTop.constant = currentTop

    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        
        cell.update(model: releases[indexPath.row])
        
        return cell
    }
    
    private func updateView() {
        if (model == nil) {
            return
        }
        
        lbName.text = model?.name
        lbNote.text = model?.profile
        ivArtist.kf.setImage(with: URL(string: model?.imageUrl ?? ""))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return releases.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valueToPass = releases[indexPath.row]
        performSegue(withIdentifier: "AlbumSegue", sender: valueToPass.masterId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AlbumSegue") {
            if let viewController = segue.destination as? AlbumViewController {
                viewController.masterId = sender as? Int
            }
        }
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
