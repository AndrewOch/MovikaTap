//
//  MockService.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation

class MockService {
    
    func createVideoBlock() -> InteractiveVideoBlock {
        
        let badEnd = InteractiveVideoBlock(decisionTitle: "BAD END",videoTitle: "BadEnd", videoDurationBeforeDecision: 5, decisionTime: 0, decisions: [])
        let goodEnd = InteractiveVideoBlock(decisionTitle: "GOOD END",videoTitle: "GoodEnd", videoDurationBeforeDecision: 5, decisionTime: 0, decisions: [])
        
        let videoBlock = InteractiveVideoBlock(decisionTitle: "BEGINNING",videoTitle: "Beginning", videoDurationBeforeDecision: 5, decisionTime: 7, decisions: [badEnd, goodEnd])
        return videoBlock
    }
}
