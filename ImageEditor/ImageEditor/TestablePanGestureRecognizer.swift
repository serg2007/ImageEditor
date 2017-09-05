//
//  TestablePanGestureRecognizer.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 01.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//
import UIKit

class TestablePanGestureRecognizer: UIPanGestureRecognizer {
    let testTarget: AnyObject?
    let testAction: Selector
    
    var testState: UIGestureRecognizerState?
    var testLocation: CGPoint?
    var testTranslation: CGPoint?
    
    override init(target: Any?, action: Selector?) {
        testTarget = target as AnyObject
        testAction = action!
        super.init(target: target, action: action)
    }
    
    func perfomTouch(location: CGPoint?, translation: CGPoint?, state: UIGestureRecognizerState) {
        testLocation = location
        testTranslation = translation
        testState = state
        testTarget?.perform(testAction, on: Thread.current, with: self, waitUntilDone: true)
    }
    
    override func location(in view: UIView?) -> CGPoint {
        if let testLocation = testLocation {
            return testLocation
        }
        return super.location(in: view)
    }
    
    override func translation(in view: UIView?) -> CGPoint {
        if let testTranslation = testTranslation {
            return testTranslation
        }
        return super.translation(in: view)
    }
    
    override var state: UIGestureRecognizerState {
        if let testState = testState {
            return testState
        }
        return super.state
    }
}
