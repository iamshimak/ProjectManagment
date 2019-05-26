//
//  DayCounter.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/21/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

@IBDesignable class ProgressView: UIView {
    
    @IBInspectable var backgroundLineColour: UIColor = UIColor.lightGray
    @IBInspectable var foregroundLineColour: UIColor = UIColor.red
    @IBInspectable var lineCap: CAShapeLayerLineCap = .round
    
    
    @IBInspectable var lineWidth:CGFloat = 10 {
        didSet {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    @IBInspectable var labelSize: CGFloat = 10 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }
    
    @IBInspectable var showText: Bool = true
    
    @IBInspectable var progress: CGFloat = 50 {
        didSet {
            foregroundLayer.strokeEnd = progress / 100
            label.text = "\(Int(progress))%"
            configLabel()
        }
    }
    
    @IBInspectable var text: String? = nil {
        didSet {
            // label.text = text
            // configLabel()
        }
    }
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        configLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        layoutDone = false
        setupView()
        configLabel()
    }
    
    //MARK: Private
    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth) / 2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = backgroundLineColour.cgColor
        backgroundLayer.lineWidth = lineWidth 
        backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = lineCap
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = foregroundLineColour.cgColor
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }
    
    private func configLabel(){
        label.sizeToFit()
        label.center = pathCenter
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
    }
    
    //Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
            configLabel()
        }
    }
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= 2{
                timer.invalidate()
            } else {
                currentTime += 0.05
                let percent = currentTime/2 * 100
                self.label.text = "\(Int(progress * percent))"
                self.configLabel()
            }
        }
        timer.fire()
        
    }
    
    
}
