//
//  DetailsSoungViewController.swift
//  fakeAppleMusic
//
//  Created by admin on 3/30/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import Alamofire
class DetailsSoungViewController: UIViewController {
    
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var nameSongLabel: UILabel!
    @IBOutlet weak var nameAuthorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var results: TrackInfoModel?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationContrl()
        
        playButton.layer.cornerRadius = 0.5 * playButton.bounds.size.width
        if let results = results {
                   configureView(withResults: results)
               }
    }
    
   private func configureNavigationContrl(){
           navigationController?.navigationBar.prefersLargeTitles = false
           title = "Fake Apple Music"
       }
    
   private func configureView(withResults results: TrackInfoModel) {
    if let imageUrlString = results.artworkUrl100,
            let url = URL(string: imageUrlString) {
               imageSong.sd_setImage(with: url, placeholderImage: nil)
           }
            nameAuthorLabel.text = results.artistName
            nameSongLabel.text = results.trackName
       }
       
    @IBAction func playButton(_ sender: UIButton) {
        if let results = results {
        let urlSoundString = results.previewUrl
            playSound(soundUrl: urlSoundString!)
        }
    }
    
}

extension DetailsSoungViewController {
    func playSound(soundUrl: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
           let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
           let fileName = soundUrl
           let fileURL = documentsURL.appendingPathComponent("\(fileName).m4a")
           return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
       }

        Alamofire.download(soundUrl, to: destination).response { [weak self] (response) in

            if response.error == nil {

                guard let url = response.destinationURL else { return }

                do {
                    self?.audioPlayer = try AVAudioPlayer(contentsOf:  url)
                    self?.audioPlayer?.prepareToPlay()
                    self?.audioPlayer?.play()
                } catch {
                    print("Error:", error.localizedDescription)
                }
            }
        }
    }
}
