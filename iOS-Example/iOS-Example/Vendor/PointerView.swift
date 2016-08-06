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
    var color: CGColorRef?
    var progress:Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        x = frame.size.width/2
        y = frame.size.height/2
    }
    
    convenience init(frame: CGRect, radius: CGFloat, progress: Double, color: CGColorRef){
        self.init(frame: frame)
        self.radius = radius
        self.progress = progress
        self.color = color
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    
    override func drawRect(rect: CGRect) {
        var ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginPath(ctx)
        drawPointer(ctx, radius: radius!, progress: progress!)
    }
    
    func drawPointer(context:CGContextRef, radius:CGFloat, progress: Double){
        var tmp: Double = (progress - 30) * M_PI / 180;
        var movedFirstX: CGFloat = CGFloat(1-cos(tmp)) * radius
        var movedFirstY: CGFloat = CGFloat(sin(tmp)) * radius
        
        var secTmp: Double = sin(2 * M_PI / 180)
        var movedSecX: CGFloat = radius * CGFloat(secTmp) * CGFloat(sin(tmp))
        var movedSecY: CGFloat = radius * CGFloat(secTmp) * CGFloat(cos(tmp))
        // draw right point
        CGContextMoveToPoint(context, (x! + radius - movedFirstX), (y! - movedFirstY));
        CGContextAddLineToPoint(context, (x! - movedSecX), (y! - movedSecY));
        CGContextAddLineToPoint(context, (x! + movedSecX), (y! + movedSecY));
        
        CGContextClosePath(context)
        var rgbColor = CGColorGetComponents(color!)
        CGContextSetRGBFillColor(context, rgbColor[0], rgbColor[1], rgbColor[2], 0.80);
        //CGContextSetStrokeColorWithColor(context, color?.CGColor);
        CGContextFillPath(context);
        
        //draw left point
        CGContextMoveToPoint(context, (x! - (radius - movedFirstX) * 0.1), (y! + movedFirstY * 0.1));
        CGContextAddLineToPoint(context, (x! - movedSecX), (y! - movedSecY));
        CGContextAddLineToPoint(context, (x! + movedSecX), (y! + movedSecY));
        
        CGContextClosePath(context)
        //CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 0.80);
        CGContextFillPath(context);
        
        //draw center circle
        CGContextAddArc(context, x!, y!, 2, 0, 360, 0);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextDrawPath(context, .Fill);
    }


}

