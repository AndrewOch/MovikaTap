//
//  InteractiveViewController.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation
import UIKit
import SnapKit
import AVKit
import AVFoundation

class InteractiveViewController: UIViewController {
    
    //MARK: - Properties
    private var output: InteractiveOutput
    
    private var decisionView: UIView = UIView()
    private var decisionsArea: UIView = UIView()
    
    private var leftTimerView: UIView = UIView()
    private var leftTimerLabel: UILabel = UILabel()
    private var rightTimerView: UIView = UIView()
    private var rightTimerLabel: UILabel = UILabel()
    
    private var variantButtons: [UIButton] = []
    private var isDecisionStarted: Bool = false
    
    private var videoPlayer: AVPlayer = AVPlayer()
    private var videoPlayerLayer: AVPlayerLayer = AVPlayerLayer()
    
    private var creditsLabel: UILabel = UILabel()
    
    //MARK: - Lifecycle
    
    init(output: InteractiveOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
}
 
//MARK: - InteractiveInput
extension InteractiveViewController: InteractiveInput {
    
    func initialize() {
        view.backgroundColor = .black
        
        view.addSubview(decisionView)
        decisionView.backgroundColor = .black
        decisionView.alpha = 0.0
        decisionView.isHidden = true
        decisionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        decisionView.addSubview(leftTimerView)
        leftTimerView.backgroundColor = .systemYellow
        leftTimerView.isHidden = true
        leftTimerView.snp.makeConstraints { make in
            make.top.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.width.equalTo(8)
        }
        
        decisionView.addSubview(leftTimerLabel)
        leftTimerLabel.isHidden = true
        leftTimerLabel.textColor = .white
        leftTimerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftTimerView).offset(40)
        }
        
        decisionView.addSubview(rightTimerView)
        rightTimerView.backgroundColor = .systemYellow
        rightTimerView.isHidden = true
        rightTimerView.snp.makeConstraints { make in
            make.top.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(decisionView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(8)
        }
        
        decisionView.addSubview(rightTimerLabel)
        rightTimerLabel.isHidden = true
        rightTimerLabel.textColor = .white
        rightTimerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightTimerView).inset(40)
        }
        
        decisionView.addSubview(decisionsArea)
        decisionsArea.snp.makeConstraints { make in
            make.top.bottom.equalTo(decisionView.safeAreaLayoutGuide)
            make.left.equalTo(leftTimerLabel).offset(20)
            make.right.equalTo(rightTimerLabel).inset(20)
        }
        
        view.addSubview(creditsLabel)
        creditsLabel.textColor = .yellow
        creditsLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        creditsLabel.attributedText = NSAttributedString(string: "/VIGVAMCEV MEDIA", attributes: [.kern: 6])
        creditsLabel.isHidden = true
        creditsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func playVideo() {
        output.startVideoTimer()
        let videoTitle = output.getCurrentVideoTitle()
        guard let path = Bundle.main.path(forResource: videoTitle, ofType:"mp4") else {
            debugPrint(videoTitle, ".mp4 not found")
            return
        }
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        videoPlayer.externalPlaybackVideoGravity = .resizeAspectFill
        
        videoPlayerLayer.removeFromSuperlayer()
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.frame = view.bounds
        videoPlayerLayer.bounds.size.width = view.bounds.width

        view.layer.insertSublayer(videoPlayerLayer, at: 0)
        videoPlayer.play()
    }
    
    func startDecisionTimer() {
        isDecisionStarted = true
        decisionView.isHidden = false
        leftTimerView.isHidden = false
        leftTimerLabel.isHidden = false
        rightTimerView.isHidden = false
        rightTimerLabel.isHidden = false
        decisionsArea.isHidden = false
        
        let areaMinX = self.decisionsArea.frame.minX - 20
        let areaMaxX = self.decisionsArea.frame.maxX - 180
        let areaMinY = self.decisionsArea.frame.minY + 30
        let areaMaxY = self.decisionsArea.frame.maxY - 30
        
        let decisions = output.getDecisions()
        
        for i in 0..<decisions.count {
            let decision = decisions[i]
            let randomPositionX = CGFloat.random(in: areaMinX...areaMaxX)
            let randomPositionY = CGFloat.random(in: areaMinY...areaMaxY)
            
            let variantButton = UIButton()
            variantButton.isUserInteractionEnabled = true
            variantButton.setTitle(decision.decisionTitle, for: .normal)
            variantButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .regular)
            decisionsArea.addSubview(variantButton)
            variantButton.center.x = randomPositionX
            variantButton.center.y = randomPositionY
            variantButton.snp.makeConstraints { make in
                make.center.equalTo(CGPoint(x: variantButton.center.x, y: variantButton.center.y))
                make.width.equalTo(260)
                make.height.equalTo(60)
            }
            variantButton.tag = i
            variantButton.addTarget(self, action: #selector(selectVariant(sender:)), for: .touchUpInside)
            variantButtons.append(variantButton)
        }
        moveButtons()
        output.startDecisionTimer()
    }
    
    @objc func selectVariant(sender: UIButton) {
        isDecisionStarted = false
        output.selectVariant(id: sender.tag)
    }
    
    func updateTimerView(with time: Int) {
        leftTimerLabel.text = String(time)
        rightTimerLabel.text = String(time)
    }
    
    func replayVideo() {
        isDecisionStarted = false
        leftTimerView.isHidden = true
        leftTimerLabel.isHidden = true
        rightTimerView.isHidden = true
        rightTimerLabel.isHidden = true
        animateDecisionClosing()
        
        leftTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        rightTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        
        for button in variantButtons {
            button.removeFromSuperview()
        }
        variantButtons = []
        playVideo()
    }
    
    func showCredits() {
        videoPlayerLayer.removeFromSuperlayer()
        videoPlayer.pause()
        creditsLabel.isHidden = false
        creditAnimation()
    }
}
    
//MARK: - Animations
extension InteractiveViewController {
    
    func animateDecisionStarting() {
        
        leftTimerView.center.x = leftTimerView.center.x - 100
        leftTimerLabel.center.x = leftTimerLabel.center.x - 100
        
        rightTimerView.center.x = rightTimerView.center.x + 100
        rightTimerLabel.center.x = rightTimerLabel.center.x + 100
        
        UIView.animate(withDuration: 2.0, delay: 0, animations: {
            self.decisionView.alpha = 0.7
            self.leftTimerView.center.x = self.leftTimerView.center.x + 100
            self.leftTimerLabel.center.x = self.leftTimerLabel.center.x + 100
            
            self.rightTimerView.center.x = self.rightTimerView.center.x - 100
            self.rightTimerLabel.center.x = self.rightTimerLabel.center.x - 100
        })
    }
    
    private func animateDecisionClosing() {
        UIView.animate(withDuration: 1.0, delay: 0, animations: {
            self.decisionView.alpha = 0.0
        }) { _ in self.decisionView.isHidden = true }
    }
    
    func animateProgressBars(duration: Int) {
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, animations: {
            self.leftTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 0.001)
            self.rightTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 0.001)
        })
    }
    
    private func moveButtons() {
        UIView.animate(withDuration: 0.02, delay: 0, options: [.allowUserInteraction], animations: {
            for button in self.variantButtons {
                var movePosMinX = button.center.x - 2
                var movePosMaxX = button.center.x + 2
                var movePosMinY = button.center.y - 2
                var movePosMaxY = button.center.y + 2
                
                let area = self.decisionsArea.frame
                
                let areaMinX = area.minX - 20
                let areaMaxX = area.maxX - 180
                let areaMinY = area.minY + 20
                let areaMaxY = area.maxY - 20
                
                if movePosMinX < areaMinX { movePosMinX = areaMinX }
                if movePosMaxX > areaMaxX { movePosMaxX = areaMaxX }
                if movePosMinY < areaMinY { movePosMinY = areaMinY }
                if movePosMaxY > areaMaxY { movePosMaxY = areaMaxY }
                
                let randomPositionX = CGFloat.random(in: movePosMinX...movePosMaxX)
                let randomPositionY = CGFloat.random(in: movePosMinY...movePosMaxY)
                
                button.center.x = randomPositionX
                button.center.y = randomPositionY
            }
        }) { _ in if (self.isDecisionStarted) { self.moveButtons() }
        }
    }
    
    private func creditAnimation() {
        creditsLabel.center.y = creditsLabel.center.y + 300
        creditsLabel.alpha = 0.0
        UIView.animate(withDuration: 1.5, delay: 0, animations: {
            self.creditsLabel.center.y = self.creditsLabel.center.y - 300
            self.creditsLabel.alpha = 1.0
        })
    }
}
