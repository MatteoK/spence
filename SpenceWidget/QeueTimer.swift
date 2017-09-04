//
//  AmountQeueTimer.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum QueueTimerState {
    case start, ongoing(progress: Float), done
}

protocol IQueueTimer {
    
    var isActive: Bool { get }
    func start(duration: TimeInterval, onChange: @escaping (QueueTimerState)->Void)
    func restart()
    func cancel()
    
}

final class QueueTimer: IQueueTimer {
    
    var onChange: ((QueueTimerState)->Void)?
    var timer: Timer?
    var interval: TimeInterval = 0.05
    var timePassed: TimeInterval = 0
    var isActive: Bool = false
    
    func start(duration: TimeInterval, onChange: @escaping (QueueTimerState) -> Void) {
        isActive = true
        self.onChange = onChange
        timePassed = 0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self else { return }
            if strongSelf.timePassed == 0 {
                onChange(.start)
            } else if strongSelf.timePassed >= duration {
                onChange(.done)
                strongSelf.reset()
            } else {
                let progress = Float(strongSelf.timePassed) / Float(duration)
                onChange(.ongoing(progress: progress))
            }
            strongSelf.timePassed += strongSelf.interval
        })
    }
    
    func restart() {
        timePassed = 0
    }
    
    func cancel() {
        reset()
    }
    
    private func reset() {
        isActive = false
        timer?.invalidate()
        timePassed = 0
    }
    
    
}
