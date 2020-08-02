//
//  HTPlayerView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit


enum HTPlayState: Int {
    case failed // 播放失败
    case buffering  // 缓冲中
    case playing    // 播放中
    case stopped    // 停止播放
    case pause // 暂停播放
    case finished // 播放完成
    case unknow // 未知
}

class HTPlayerView: UIView {
    
    @IBOutlet private weak var coverImgV: UIImageView!
    @IBOutlet private weak var playBtn: UIButton!
    @IBOutlet private weak var fatherPlayerView: UIView!
    @IBOutlet private weak var controlView: UIView!
    
    var autoPlay = true {
        didSet{
            player.autoPlay = autoPlay
        }
    }
    
    var loop = true {
        didSet {
            player.loop = loop
        }
    }
    
    var observePlayerStatus: ((_ status: HTPlayState)->Void)?
    
    private var oneView: UIView!
    
    var player: SuperPlayerView!
    
    var coverUrl = "" {
        didSet {
            coverImgV.sd_setImage(with: URL(string: coverUrl), completed: nil)
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        oneView = UINib(nibName: "HTPlayerView", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        oneView.frame = bounds
        addSubview(oneView)
        initPlayer()
    }
    
    private func initPlayer() {
        player = SuperPlayerView(frame: bounds)
        player.delegate = self
        player.autoPlay = true
        player.loop = loop
        player.fatherView = fatherPlayerView
        player.controlView = SuperPlayerControlView()
        player.repeatBtn.alpha = 0
        player.addObserver(self, forKeyPath: "state", options: .new, context: nil)
    }
    
    func play(url: String) {
        #if !(arch(i386) || arch(x86_64))
        let model = SuperPlayerModel()
        model.videoURL = url
        player.play(with: model)
        coverImgV.isHidden = false
        #endif
    }
    
    func play(fileId: String) {
        let model = SuperPlayerModel()
        let videoIdModel = SuperPlayerVideoId()
        videoIdModel.appId = VIDEO_APP_ID
        videoIdModel.fileId = fileId
        model.videoId = videoIdModel
        player.play(with: model)
    }
    
    func resetPlayer() {
        player.resetPlayer()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is SuperPlayerView {
            if keyPath == "state" {
                
                let isShow = player.state == .StatePause
                playBtn.isHidden = !isShow
                if let obs = observePlayerStatus {
                    obs(HTPlayState(rawValue: player.state.rawValue) ?? HTPlayState.unknow)
                }
                switch player.state {
                case .StatePlaying:
                    if let vc = visibleViewController as? HTHomeViewController,
                        vc.scrollView.contentOffset.x >= 1 {
                        player.resetPlayer()
                        return
                    }
                    if visibleViewController?.mainVC?.guideScrollView.isHidden == false {
                        player.resetPlayer()
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.coverImgV.isHidden = true
                    }
                case .StateFailed, .StateStopped:
                    coverImgV.isHidden = false
                default:
                    break
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == controlView {
            if player.state == .StatePlaying {
                player.pause()
            } else {
                player.resume()
            }
        }
    }
    
    deinit {
        player.resetPlayer()
    }
}

extension HTPlayerView: SuperPlayerDelegate {
    
    func superPlayerDidEnd(_ player: SuperPlayerView!) {
        if let obs = observePlayerStatus {
            obs(.finished)
        }
    }
    
}
