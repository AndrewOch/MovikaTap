//
//  InteractiveModuleBuilder.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation

class InteractiveModuleBuilder {
    
    func build(for videoBlock: InteractiveVideoBlock) -> InteractiveViewController {
        let presenter = InteractivePresenter(videoBlock: videoBlock)
        let viewController = InteractiveViewController(output: presenter)
        presenter.input = viewController
        
        return viewController
    }
}
