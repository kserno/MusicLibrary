//
//  MasterModel.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 08/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import Foundation

class MasterModel {
    var genres: [String] = []
    var title: String = ""
    var notes: String = ""
    var year: Int = 0
    var uri: String = ""
    var tracklist: [SongModel] = []
    var artist: ArtistModel? = nil
    var imageUrl: String = ""
}
