//
//  DraggableView.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 25.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class DraggableView: UIView {
    var startPoint: CGPoint?
    var startFrame: CGRect?
    override func awakeFromNib() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
        self.addGestureRecognizer(pan)
    }
    
    
    func onPan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            startPoint = pan.translation(in: self)
            startFrame = self.frame
        case .changed:
            let dispX = pan.translation(in: self).x - (startPoint?.x)!
            let dispY = pan.translation(in: self).y - (startPoint?.y)!
            self.frame.origin.x = (startFrame?.origin.x)! + dispX
            self.frame.origin.y = (startFrame?.origin.y)! + dispY
        case .ended:
            self.transform = .identity
        default:
             print(pan.velocity(in: self))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.backgroundColor = UIColor.red
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.backgroundColor = UIColor.black
        self.transform = .identity
    }
}
