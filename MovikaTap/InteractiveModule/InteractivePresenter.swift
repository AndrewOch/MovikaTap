//
//  InteractivePresenter.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation

class InteractivePresenter {
    
    weak var input: InteractiveViewController?
    
    private var videoBlock: InteractiveVideoBlock
    private var timer = Timer()
    private var decisionTimeLeft: Int
    
    init(videoBlock: InteractiveVideoBlock) {
        self.videoBlock = videoBlock
        decisionTimeLeft = videoBlock.decisionTime
    }
}

extension InteractivePresenter: InteractiveOutput {
    
    func getDecisions() -> [InteractiveVideoBlock] {
        return videoBlock.decisions
    }
    
    func playVideo() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(videoBlock.videoDurationBeforeDecision),
                                         target: self,
                                         selector: #selector(updatePlayTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc private func updatePlayTimer() {
        stopTimer()
        input?.startDecisionTimer()
    }
    
    private func stopTimer() {
      timer.invalidate()
    }
    
    func startDecisionTimer() {
        input?.updateTimerView(with: decisionTimeLeft)
        input?.animateProgressBars(duration: videoBlock.decisionTime)
        input?.fadeInDecisionBackground()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateDecisionTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc private func updateDecisionTimer() {
        decisionTimeLeft = decisionTimeLeft - 1
        input?.updateTimerView(with: decisionTimeLeft)
        
        if decisionTimeLeft == 0 {
            stopTimer()
            decisionTimeLeft = videoBlock.decisionTime
            input?.replayVideo()
        }
    }
    
    func selectVariant(title: String) {
        guard let videoBlock = videoBlock.decisions.first(where: {$0.title == title}) else {
            return
        }
        self.videoBlock = videoBlock
        decisionTimeLeft = videoBlock.decisionTime
        input?.replayVideo()
    }
}
