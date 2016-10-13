//
//  TriangleDataView.swift
//  XVPN
//
//  Created by longhao on 15/6/10.
//  Copyright (c) 2015年 longhao. All rights reserved.
//

import UIKit


@IBDesignable
class PointerView: UIView {
    
    var x: CGFloat?
    var y: CGFloat?
    var radius:CGFloat?
    var color: CGColor?
    var progress:Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        x = frame.size.width/2
        y = frame.size.height/2
    }
    
    convenience init(frame: CGRect, radius: CGFloat, progress: Double, color: CGColor){
        self.init(frame: frame)
        self.radius = radius
        self.progress = progress
        self.color = color
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let ctx : CGContext = UIGraphicsGetCurrentContext()!
        ctx.beginPath()
        drawPointer(ctx, radius: radius!, progress: progress!)
    }
    
    func drawPointer(_ context:CGContext, radius:CGFloat, progress: Double){
        let tmp: Double = (progress - 30) * M_PI / 180;
        let movedFirstX: CGFloat = CGFloat(1-cos(tmp)) * radius
        let movedFirstY: CGFloat = CGFloat(sin(tmp)) * radius
        
        let secTmp: Double = sin(2 * M_PI / 180)
        let movedSecX: CGFloat = radius * CGFloat(secTmp) * CGFloat(sin(tmp))
        let movedSecY: CGFloat = radius * CGFloat(secTmp) * CGFloat(cos(tmp))
        // draw right point
        context.move(to: CGPoint(x: (x! + radius - movedFirstX), y: (y! - movedFirstY)));
        context.addLine(to: CGPoint(x: (x! - movedSecX), y: (y! - movedSecY)));
        context.addLine(to: CGPoint(x: (x! + movedSecX), y: (y! + movedSecY)));
        
        context.closePath()
        let rgbColor = color!.components
        context.setFillColor(red: (rgbColor?[0])!, green: (rgbColor?[1])!, blue: (rgbColor?[2])!, alpha: 0.80);
        //CGContextSetStrokeColorWithColor(context, color?.CGColor);
        context.fillPath();
        
        //draw left point
        context.move(to: CGPoint(x: (x! - (radius - movedFirstX) * 0.1), y: (y! + movedFirstY * 0.1)));
        context.addLine(to: CGPoint(x: (x! - movedSecX), y: (y! - movedSecY)));
        context.addLine(to: CGPoint(x: (x! + movedSecX), y: (y! + movedSecY)));
        
        context.closePath()
        //CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 0.80);
        context.fillPath();
        
        //draw center circle
        context.addArc(center: CGPoint.init(x: x!, y: y!), radius: 2, startAngle: 0, endAngle: 360, clockwise: false)
//        CGContextAddArc(context, x!, y!, 2, 0, 360, 0);
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        context.drawPath(using: .fill);
    }


}

