//
//  DiscogsApi.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 02/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class DiscogsApi {
    
    let API_TOKEN = "dkAmyezzgNPNMoUKEwGsZXhDKbOTtQGTNSPyteEB"
    
    func searchByBarcode(barcode: String) -> Single<AlbumModel> {
        return Single<AlbumModel>.create { emitter in
            guard let url = URL(string : "https://api.discogs.com/database/search") else {
                emitter(.error(NetworkError.runtimeError("error")))
                return Disposables.create()
            }
            
            let request = Alamofire.request(url,
                              method: .get,
                              parameters: [
                                "barcode": barcode,
                                "token": self.API_TOKEN
                ])
            .validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                    
                    guard let value = response.result.value as? [String: Any],
                        let results = value["results"] as? [[String: Any]] else {
                            emitter(.error(NetworkError.runtimeError("error")))
                            return
                        }
                    if (results.count == 0) {
                        emitter(.error(NetworkError.runtimeError("error")))
                    } else {
                        let result = AlbumModel()
                        let albumJson = results[0]
                        
                        result.title = albumJson["title"] as! String
                        result.id = albumJson["master_id"] as! Int
                        result.genres = albumJson["genre"] as! [String]
                        result.thumbUrl = albumJson["thumb"] as! String
                        
                        emitter(.success(result))
                    }
                    
            }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    func getMasters(id: Int) -> Single<MasterModel> {
        
        
        return Single<MasterModel>.create { emitter in
            
            guard let url = URL(string : "https://api.discogs.com/masters/\(id)") else {
                emitter(.error(NetworkError.runtimeError("error")))
                return Disposables.create()
            }
            
            let request = Alamofire.request(url,
                              method: .get,
                              parameters: ["token": self.API_TOKEN])
                        .validate()
                .responseJSON {
                    response in
                    guard response.result.isSuccess else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                    
                    guard let value = response.result.value as? [String: Any] else {
                            emitter(.error(NetworkError.runtimeError("error")))
                            return
                    }
                    
                    let model = MasterModel()
                    
                    model.genres = value["genres"] as! [String]
                    //model.imageUrl = value["images"]
                    model.notes = value["notes"] as? String ?? ""
                    model.title = value["title"] as! String
                    model.year = value["year"] as! Int
                    model.uri = value["uri"] as! String
                    
                    let artists = value["artists"] as! [[String: Any]]
                    
                    let artist = ArtistModel()
                    
                    artist.id = artists[0]["id"] as! Int
                    artist.name = artists[0]["name"] as! String
                    
                    model.artist = artist
                    
                    let tracks = value["tracklist"] as! [[String: Any]]
                
                    tracks.forEach { track in
                        let song = SongModel()
                        
                        song.title = track["title"] as! String
                        song.duration = track["duration"] as! String
                        
                        model.tracklist.append(song)
                    }
                    
                    let images = value["images"] as! [[String: Any]]
                    
                    let first = images.first
                    if (first != nil) {
                        model.imageUrl = first?["uri"] as! String
                    }
                    
                    emitter(.success(model))
            }
            
            
            return Disposables.create { request.cancel() }
        }
    }
    
    
    func getArtist(id: Int) -> Single<ArtistModel> {
        return Single<ArtistModel>.create { emitter in
            guard let url = URL(string : "https://api.discogs.com/artists/\(id)") else {
                emitter(.error(NetworkError.runtimeError("error")))
                return Disposables.create()
            }
            
            let request = Alamofire.request(url,
                              method: .get,
                              parameters: ["token": self.API_TOKEN])
                .validate()
                .responseJSON { response in
                    
                    guard response.result.isSuccess else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                    
                    guard let value = response.result.value as? [String: Any] else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                    
                    let result = ArtistModel()
                    
                    //result.imageUrl =
                    result.name = value["name"] as! String
                    result.profile = value["profile"] as! String
                    
                    let images = value["images"] as! [[String: Any]]
                    
                    if (images.count > 0) {
                        result.imageUrl = images[0]["uri"] as! String
                    }
                    
                    emitter(.success(result))
            }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    func getReleases(id: Int) -> Single<[ReleaseModel]> {
        return Single<[ReleaseModel]>.create { emitter in
            guard let url = URL(string : "https://api.discogs.com/artists/\(id)/releases") else {
                emitter(.error(NetworkError.runtimeError("error")))
                return Disposables.create()
            }
            
            let request = Alamofire.request(url,
                              method: .get,
                              parameters: ["token": self.API_TOKEN])
                .validate()
                .responseJSON { response in
                
                    guard response.result.isSuccess else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                
                    guard let value = response.result.value as? [String: Any] else {
                        emitter(.error(NetworkError.runtimeError("error")))
                        return
                    }
                    
                    var result = [ReleaseModel]()
                    let releases = value["releases"] as! [[String: Any]]
                    
                    releases.forEach {rel in
                        let release = ReleaseModel()
                        
                        release.masterId = rel["id"] as! Int
                        release.name = rel["title"] as! String
                        release.thumbUrl = rel["thumb"] as! String
                        release.year = rel["year"] as! Int
                        
                        result.append(release)
                    }
                    
                    emitter(.success(result))
                }
                    
                    
            
            return Disposables.create { request.cancel() }
        }
    }
    
    
}
