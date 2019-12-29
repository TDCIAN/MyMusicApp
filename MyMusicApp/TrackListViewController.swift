//
//  TrackListViewController.swift
//  MyMusicApp
//
//  Created by APPLE on 2019/12/28.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import UIKit

class TrackListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var musicTrackList: [Track] = []
    
    // segue를 통해 데이터를 PlayerViewController로 전달하기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayer" {
            if let playerVC = segue.destination as? PlayerViewController, let index = sender as? Int {
                playerVC.track = musicTrackList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackList()
    }
    
    func loadTrackList() {
        musicTrackList = [
            Track(title: "Swish", thumb: #imageLiteral(resourceName: "Swish"), artist: "Tyga"),
            Track(title: "Dip", thumb: #imageLiteral(resourceName: "Dip"), artist: "Tyga"),
            Track(title: "The Harlem Barber Swing", thumb: #imageLiteral(resourceName: "The Harlem Barber Swing"), artist: "Jazzinuf"),
            Track(title: "Believer", thumb: #imageLiteral(resourceName: "Believer"), artist: "Imagine Dragon"),
            Track(title: "Blue Birds", thumb: #imageLiteral(resourceName: "Blue Birds"), artist: "Eevee"),
            Track(title: "Best Mistake", thumb: #imageLiteral(resourceName: "Best Mistake"), artist: "Ariana Grande"),
            Track(title: "thank u, next", thumb: #imageLiteral(resourceName: "thank u, next"), artist: "Ariana Grande"),
            Track(title: "7 rings", thumb: #imageLiteral(resourceName: "7 rings"), artist: "Ariana Grande")
        ]
    }
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        
        let track = musicTrackList[indexPath.row]
        cell.thumbnail.image = track.thumb
        cell.title.text = track.title
        cell.artist.text = track.artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---->\(indexPath.row)")
        // 클릭하면 세그를 통해 데이터를 보낸다
        performSegue(withIdentifier: "ShowPlayer", sender: indexPath.row)
    }
}

class TrackCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
}
