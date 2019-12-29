//
//  Track.swift
//  MyMusicApp
//
//  Created by APPLE on 2019/12/28.
//  Copyright © 2019 JeongminKim. All rights reserved.
//
import AVFoundation
import UIKit

class Track {
    var title: String
    var thumb: UIImage
    var artist: String
    
    // 이니셜라이저 생성
    init(title: String, thumb: UIImage, artist: String) {
        self.title = title
        self.thumb = thumb
        self.artist = artist
    }
    
    var asset: AVAsset {
        let path = Bundle.main.path(forResource: title, ofType: "mov")!
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        return asset
    }
}
