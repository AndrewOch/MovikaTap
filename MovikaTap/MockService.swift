//
//  MockService.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation

class MockService {
    
    func createVideoBlock() -> InteractiveVideoBlock {
        
        let secondVideoBlock1 = InteractiveVideoBlock(title: "BAD END", videoDurationBeforeDecision: 3, decisionTime: 10, decisions: [])
        let secondVideoBlock2 = InteractiveVideoBlock(title: "GOOD END", videoDurationBeforeDecision: 3, decisionTime: 10, decisions: [])
    
        let videoBlock = InteractiveVideoBlock(title: "BEGINING", videoDurationBeforeDecision: 3, decisionTime: 10, decisions: [secondVideoBlock1, secondVideoBlock2])
        
        return videoBlock
    }
}
