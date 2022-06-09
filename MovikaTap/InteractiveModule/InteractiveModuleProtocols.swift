//
//  InteractiveModuleProtocols.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation

protocol InteractiveInput {
    
    func initialize()
    func playVideo()
    func startDecisionTimer()
    func updateTimerView(with time: Int)
    func replayVideo()
}

protocol InteractiveOutput {
    
    func getDecisions() -> [InteractiveVideoBlock]
    func playVideo()
    func startDecisionTimer()
    func selectVariant(title: String)
}

