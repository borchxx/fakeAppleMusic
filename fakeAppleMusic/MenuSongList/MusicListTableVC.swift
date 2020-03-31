//
//  ViewController.swift
//  fakeAppleMusic
//
//  Created by admin on 3/29/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit


class MusicListTableVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var timerDate: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    var model: Model?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
    }
    
    func setupData(){
        NetworkManager.shared.loadRates { result in
            switch result {
            case .success(let model):
                self.model = model
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = "Введите название песни"
        searchController.searchBar.delegate = self
    }
}

extension MusicListTableVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = model {
            return model.results.count
        } else {
            return 0
        }
        
    }
    
    func configure(cell: MusicListTableViewCell, withTrackInfo results:TrackInfoModel){
        cell.set(trackImageURl: results.artworkUrl60, trackName: results.trackName, trackAuthor: results.artistName)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListTableViewCell") as! MusicListTableViewCell
        if let model = model {
            let trackInfo = model.results[indexPath.row]
            configure(cell: cell, withTrackInfo: trackInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
        
          guard let detailVC = DetailsSoungViewController.createFromMainStoryboard() else { return }
                   navigationController?.pushViewController(detailVC, animated: true)
        
        if let songModel = model{
            let detailResults = songModel.results[indexPath.row]
            detailVC.results = detailResults
        }
    }
}


extension MusicListTableVC: UISearchBarDelegate {
    func searchSong(searchText: String){
        NetworkManager.shared.nameSong = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSong(searchText: searchText)
        timerDate?.invalidate()
        timerDate = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.setupData()
        })
       
    }
}
