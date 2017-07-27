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
    var imageView: UIImageView?
    var scale: Double = 1.0
    
    
    init(image: UIImage, frame: CGRect) {
        super.init(frame: frame)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
        self.addGestureRecognizer(pan)
        
        imageView = UIImageView(image: image)
        imageView?.frame = CGRect(x: 0, y: 0,
                                  width: (frame.width),
                                  height: (frame.height))
        imageView?.contentMode = .scaleAspectFit
        addSubview(imageView!)
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
        self.addGestureRecognizer(pan)
        
        let image = UIImage(named: "priroda_1")
        
        scale = (image?.size.width)! > 200 ? 200 / Double((image?.size.width)!)  : 1.0
        
        imageView = UIImageView(image: image)
        imageView?.frame = CGRect(x: 0, y: 0,
                                  width: CGFloat(scale) * (image?.size.width)!,
                                  height: CGFloat(scale) * (image?.size.height)!)
        
        self.frame.size.height = (imageView?.frame.height)!
        self.frame.size.width = (imageView?.frame.width)!
        addSubview(imageView!)
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
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = .identity
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.transform = .identity
//        tempTransitionView?.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return self
    }
}
