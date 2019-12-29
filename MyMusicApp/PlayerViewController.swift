//
//  PlayerViewController.swift
//  MyMusicApp
//
//  Created by APPLE on 2019/12/28.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    var track: Track?
    var avplayer: AVPlayer?
    var timeObserver: Any?

    // 현재시간
    var currentTime: Double {
        return avplayer?.currentItem?.currentTime().seconds ?? 0
    }
    
    // 전체시간
    var totalDurationTime: Double {
        return avplayer?.currentItem?.duration.seconds ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareToPlay()
        
        // 플레이어의 재생 시간을 실시간으로 확인
        // CMTime(현재는 0.1초) 간격으로 { 클로저 } 안의 함수를 실행한다
        // value가 1이고, time scale은 10이다. -> 1초를 10개로 쪼갠 것(time sacle) 중에 하나(value)와 같으므로 0.1초다
        timeObserver = avplayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { time in
             self.updateTime(time: time)
        }
    }
    
    func updateUI() {
        guard let currentTrack = track else { return }
        thumbnail.image = currentTrack.thumb
        trackTitle.text = currentTrack.title
        artistName.text = currentTrack.artist
        playPauseButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
    }
    
    func prepareToPlay() {
        guard let currentTrack = track else { return }
        let asset = currentTrack.asset
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        avplayer = player
    }
    
    func updateTime(time: CMTime) {
        // currentTime label, total duration label, slider
        currentTimeLabel.text = secondsToString(sec: currentTime)
        totalDurationTimeLabel.text = secondsToString(sec: totalDurationTime)

        // 사용자가 드래깅하고있지 않을 때만 시간 업데이트를 하겠다
        if isSeeking == false {
            timeSlider.value = Float(currentTime/totalDurationTime)
        }
    }
    
    // 시간을 소수점은 떼고 양식에 맞춰 출력하게 만들기
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    // playback
    func play() {
        avplayer?.play()
    }
    
    func pause() {
        avplayer?.pause()
    }
    
    // 이 부분이 좀 어렵네
    func seek(to: Double) {
        // to: 0 ~ 1
        // 0.5 * 60 = 30
        let timeScale: CMTimeScale = 10
        let targetTime: CMTimeValue = CMTimeValue(to * totalDurationTime) * CMTimeValue(timeScale)
        let time = CMTime(value: targetTime, timescale: 10)
        avplayer?.seek(to: time)
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        // 재생중인지 아닌지 확인: rate가 1이면 플레이 상태, 0이면 퍼즈 상태
        let isPlaying = avplayer?.rate == 1
        
        if isPlaying {
            pause() // 퍼즈 상태라면
            playPauseButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
        } else {
            play() // 재생 상태라면
            playPauseButton.setImage(#imageLiteral(resourceName: "icPause"), for: .normal)
        }
    }
    
    // 드래그 기능
    var isSeeking = false
    @IBAction func dragging(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDragging(_ sender: UISlider) {
        isSeeking = false
        seek(to: Double(sender.value))
    }
    
    // 닫기 버튼: 작동 중이던 기능들을 정지시키고 닫는다
    @IBAction func close () {
        pause()
        avplayer?.replaceCurrentItem(with: nil)
        avplayer = nil
        dismiss(animated: true, completion: nil)
    }


}
