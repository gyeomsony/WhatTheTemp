//
//  LaunchViewController.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/14/25.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    let animationView: LottieAnimationView = {
        let aniView = LottieAnimationView(name: "Animation - 1736606457065")
        aniView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        aniView.loopMode = .playOnce
        return aniView
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 몇 도?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 애니메이션 추가
        view.addSubview(animationView)
        animationView.center = view.center
        
        // 라벨 추가
        view.addSubview(messageLabel)
        positionMessageLabel()
        
        // 라벨과 애니메이션 동시 시작
        showMessageAndStartAnimation()
    }
    
    func positionMessageLabel() {
        messageLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        messageLabel.center = CGPoint(x: view.center.x, y: animationView.frame.maxY + 50)
    }
    
    func showMessageAndStartAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.messageLabel.alpha = 1
        })
        
        animationView.play(fromProgress: 0.0, toProgress: 0.28) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.transitionToWeatherView()
            }
        }
    }
    
    func transitionToWeatherView() {
        let vm = WeatherViewModel(locationRepository: LocationRepository(), weatherRepository: WeatherRepository())
        let vc = WeatherViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: false)

        UIView.transition(
            with: UIApplication.shared.windows.first ?? UIWindow(),
            duration: 1.0,
            options: .transitionCrossDissolve,
            animations: {
//                UIApplication.shared.windows.first?.rootViewController = navigationController
            },
            completion: { _ in

            }
        )
    }


}

