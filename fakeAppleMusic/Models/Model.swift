//
//  Model.swift
//  fakeAppleMusic
//
//  Created by admin on 3/29/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

struct Model: Decodable {
    let results: [TrackInfoModel]
}

struct TrackInfoModel: Decodable {
    let trackName: String?
    let artistName: String?
    let artworkUrl60: String?
    let previewUrl: String?
    let artworkUrl100: String?
}
