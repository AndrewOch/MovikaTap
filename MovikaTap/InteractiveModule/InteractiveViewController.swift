//
//  InteractiveViewController.swift
//  MovikaTap
//
//  Created by andrewoch on 09.06.2022.
//

import Foundation
import UIKit
import SnapKit

class InteractiveViewController: UIViewController, InteractiveInput {
    
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
    
    //MARK: - Protocol
    
    func initialize() {
        view.backgroundColor = .white

        view.addSubview(decisionView)
        decisionView.backgroundColor = .black
        decisionView.alpha = 0.0
        decisionView.isHidden = true
        decisionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        decisionView.addSubview(leftTimerView)
        leftTimerView.backgroundColor = .systemRed
        leftTimerView.isHidden = true
        leftTimerView.snp.makeConstraints { make in
            make.top.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.width.equalTo(8)
        }

        view.addSubview(leftTimerLabel)
        leftTimerLabel.isHidden = true
        leftTimerLabel.textColor = .white
        leftTimerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftTimerView).offset(40)
        }

        view.addSubview(rightTimerView)
        rightTimerView.backgroundColor = .systemRed
        rightTimerView.isHidden = true
        rightTimerView.snp.makeConstraints { make in
            make.top.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(decisionView.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(decisionView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(8)
        }
        
        view.addSubview(rightTimerLabel)
        rightTimerLabel.isHidden = true
        rightTimerLabel.textColor = .white
        rightTimerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightTimerView).inset(40)
        }
        
        decisionView.addSubview(decisionsArea)
        decisionsArea.alpha = 0.0
        decisionsArea.isHidden = true
        decisionsArea.snp.makeConstraints { make in
            make.top.bottom.equalTo(decisionView.safeAreaLayoutGuide)
            make.left.equalTo(leftTimerLabel).offset(20)
            make.right.equalTo(rightTimerLabel).inset(20)
        }
    }
    
    func playVideo() {
        output.playVideo()
    }
    
    func startDecisionTimer() {
        isDecisionStarted = true
        decisionView.isHidden = false
        leftTimerView.isHidden = false
        leftTimerLabel.isHidden = false
        rightTimerView.isHidden = false
        rightTimerLabel.isHidden = false
        decisionsArea.isHidden = false
        
        let areaMinX = self.decisionsArea.frame.minX + 60
        let areaMaxX = self.decisionsArea.frame.maxX - 60
        let areaMinY = self.decisionsArea.frame.minY + 20
        let areaMaxY = self.decisionsArea.frame.maxY - 20
        
        for decision in output.getDecisions() {
            let variantButton = UIButton()
            
            let randomPositionX = CGFloat.random(in: areaMinX...areaMaxX)
            let randomPositionY = CGFloat.random(in: areaMinY...areaMaxY)
            variantButton.center.x = randomPositionX
            variantButton.center.y = randomPositionY
            
            variantButton.isUserInteractionEnabled = true
            variantButton.setTitle(decision.title, for: .normal)
            variantButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .regular)
            decisionView.addSubview(variantButton)
            variantButton.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            variantButton.addTarget(self, action: #selector(selectVariant), for: .touchUpInside)
            variantButtons.append(variantButton)
        }
        moveButtons()
            
        output.startDecisionTimer()
    }

    @objc func selectVariant() {
        isDecisionStarted = false
        output.selectVariant(title: "")
    }
    
    func updateTimerView(with time: Int) {
        leftTimerLabel.text = String(time)
        rightTimerLabel.text = String(time)
    }
    
    func replayVideo() {
        isDecisionStarted = false
        decisionView.isHidden = true
        decisionView.alpha = 0.0
        leftTimerView.isHidden = true
        leftTimerLabel.isHidden = true
        rightTimerView.isHidden = true
        rightTimerLabel.isHidden = true
        decisionsArea.isHidden = true
        fadeOutDecisionBackground()
        
        leftTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        rightTimerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        
        for button in variantButtons {
            button.removeFromSuperview()
        }
        variantButtons = []
        playVideo()
    }
    
    //MARK: - Animations
    
    func fadeInDecisionBackground() {
        UIView.animate(withDuration: 2.0, delay: 0, animations: {
            self.decisionView.alpha = 0.7
        })
    }
    
    func fadeOutDecisionBackground() {
        UIView.animate(withDuration: 1.0, delay: 0, animations: {
            self.decisionView.alpha = 0.0
        }) { _ in self.decisionView.isHidden = true }
    }
    
    func DecisionBackground() {
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
    
    func moveButtons() {
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            for button in self.variantButtons {
                
                var areaMinX = self.decisionsArea.frame.minX + 60
                var areaMaxX = self.decisionsArea.frame.maxX - 60
                var areaMinY = self.decisionsArea.frame.minY + 20
                var areaMaxY = self.decisionsArea.frame.maxY - 20
                
                if areaMinX < button.center.x - 10 {
                    areaMinX = button.center.x - 10
                }
                if areaMaxX > button.center.x + 10 {
                    areaMaxX = button.center.x + 10
                }
                if areaMinY < button.center.y - 10 {
                    areaMinY = button.center.y - 10
                }
                if areaMaxY > button.center.y + 10 {
                    areaMaxY = button.center.y + 10
                }
                
                let randomPositionX = CGFloat.random(in: areaMinX...areaMaxX)
                let randomPositionY = CGFloat.random(in: areaMinY...areaMaxY)
                
                button.center.x = randomPositionX
                button.center.y = randomPositionY
            }
        }) { _ in self.moveButtons() }
    }
}
