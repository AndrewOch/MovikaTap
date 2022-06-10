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
    func showCredits()
}

protocol InteractiveOutput {
    
    func getCurrentVideoTitle() -> String
    func getDecisions() -> [InteractiveVideoBlock]
    func startVideoTimer()
    func startDecisionTimer()
    func selectVariant(id: Int)
}

