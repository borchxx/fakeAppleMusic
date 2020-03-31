//
//  MusicListTableViewCell.swift
//  fakeAppleMusic
//
//  Created by admin on 3/29/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage

class MusicListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageTrack: UIImageView!
    @IBOutlet weak var nameTrackLabel: UILabel!
    @IBOutlet weak var nameAuthorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imageTrack.layer.cornerRadius = 10
    }

   func set(trackImageURl: String?,
            trackName: String?,
            trackAuthor: String?) {
    if let trackImageURlString = trackImageURl,
        let url = URL(string: trackImageURlString){
        imageTrack.sd_setImage(with: url, placeholderImage: nil)
    }
       nameTrackLabel.text = trackName
       nameAuthorLabel.text = trackAuthor
   }

}
