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
   
    func getCurrentVideoTitle() -> String {
        return videoBlock.videoTitle
    }
    
    func getDecisions() -> [InteractiveVideoBlock] {
        return videoBlock.decisions
    }
    
    func startVideoTimer() {
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
        if (videoBlock.decisions.isEmpty) {
            input?.showCredits()
            return
        }
        input?.updateTimerView(with: decisionTimeLeft)
        input?.animateProgressBars(duration: videoBlock.decisionTime)
        input?.animateDecisionStarting()
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
    
    func selectVariant(id: Int) {
        let videoBlock = videoBlock.decisions[id]
        self.videoBlock = videoBlock
        decisionTimeLeft = videoBlock.decisionTime
        input?.replayVideo()
    }
}
