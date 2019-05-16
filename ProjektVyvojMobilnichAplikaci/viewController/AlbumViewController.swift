//
//  AlbumViewController.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 08/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class AlbumViewController: UITableViewController {

    @IBOutlet var lbNotes: UILabel!
    @IBOutlet var btArtist: UIButton!
    @IBOutlet var lbYear: UILabel!
    @IBOutlet var lbGenre: UILabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var ivThumb: UIImageView!
    var masterId: Int? = 64290 // TODO set to nil
    private var disposeBag: DisposeBag = DisposeBag()
    private var model: MasterModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (masterId != nil) {
            DiscogsApi().getMasters(id: masterId!)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: {
                    model in
                    self.model = model
                    self.updateView()
                    self.tableView.reloadData()
                }, onError: {
                    error in
                    print(error)
                }).disposed(by: disposeBag)
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.tracklist.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
       
        if (model != nil) {
            cell.update(model: model!.tracklist[indexPath.row])
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    private func updateView() {
        if (model == nil) {
            return
        }
        lbName.text = model?.title
        lbYear.text = String(model!.year)
        lbGenre.text = model?.genres.joined(separator: "/")
        lbNotes.text = model?.notes
        ivThumb.kf.setImage(with: URL(string: model?.imageUrl ?? ""))
        
        btArtist.setTitle(model?.artist?.name ?? "", for: UIControl.State.normal)
        
    }
    
   
    @IBAction func btArtistClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "ArtistSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ArtistSegue") {
            if let viewController = segue.destination as? ArtistViewController {
                viewController.id = model?.artist?.id ?? 0
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
