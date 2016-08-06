//
//  CircleDataView.swift
//  XVPN
//
//  Created by longhao on 15/6/5.
//  Copyright (c) 2015年 longhao. All rights reserved.
//

import UIKit


//define color
let normalColor = UIColor(red:  86/255, green: 176/255, blue: 242/255, alpha: 1) //blue
let dangerColor = UIColor(red: 218/255, green: 122/255, blue: 127/255, alpha: 1) //red
let enoughColor = UIColor(red:  255/255, green: 153/255, blue: 51/255, alpha: 1) //orange

@IBDesignable
public class Dashboard: UIView {
    
    var fontSize:CGFloat = 16
    var lineSize:CGFloat = 10
    var isBorder: Bool = false
    var progress:CGFloat = 0
    var explain: String = ""
    
    
    //private
    private var _title: String = "left"
    private var x: CGFloat? = 0
    private var y: CGFloat? = 0
    private var radius: CGFloat! = 0
    private var pointer: PointerView?
    private var explainLabel: UILabel?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaultValue()
    }
    public func setupDefaultValue() {
        x = frame.size.width/2
        y = frame.size.height/2
        radius = frame.size.width/2-10
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience public init(frame: CGRect, title: String, left: CGFloat, total: CGFloat, suffix: String, format: String = "%.f", isBorder: Bool = false){
        self.init(frame: frame)
        self.title = title ?? ""
        self.isBorder = isBorder
        self.change(left, total: total, suffix: suffix, format: format)
        self.backgroundColor = UIColor.clearColor()
    }
    
    public func change(left: CGFloat, total: CGFloat, suffix: String, format: String = "%.f"){
        self.progressMirage = (left / total) * 100
        self.explainMirage = NSString(format: format, left) as String + "/" + (NSString(format: format, total) as String)  as String + suffix
    }
    
    public var title:String{
        get {
            return self._title
        }
        set {
            self._title = newValue
            drawTitle(newValue)
            setNeedsDisplay()  //string drawAtPoint need setNeedsDisplay 
        }
    }
    
    //set progress mirage
    internal var progressMirage:CGFloat{
        get{
            return self.progress
        }
        set {
            var newVal = newValue
            if newVal < 0 {newVal = 0} // min is zero
            self.progress = newVal
            showPointerView(newVal, radius:radius)
        }
    }
    
    internal var explainMirage:String{
        get{
            return self.explain
        }
        set(newVal) {
            self.explain = newVal
            drawExplainLabel(newVal)
        }
    }
    
    
    
    override public func drawRect(rect: CGRect) {
        //get graphics context
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextSetAllowsAntialiasing(context, true)
        
        //
        var start = 149.5, end = 390.5, fragment = 2.4*20, normal = end - fragment, danger = start + fragment
        
        var startAngle: CGFloat = radians(CGFloat(start));
        var endAngle: CGFloat = radians(CGFloat(end));
        
        //border
        if isBorder {
            var borderColor = UIColor(red: 51/255, green: 102/255, blue: 153/255, alpha: 1).CGColor
            CGContextSetLineWidth(context, lineSize)
        
            CGContextSetStrokeColorWithColor(context, borderColor)
            CGContextAddArc(context, x!, y!, radius-4, startAngle, endAngle, 0)
            CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
            CGContextSetStrokeColorWithColor(context, borderColor)
            CGContextAddArc(context, x!, y!, radius+4, startAngle, endAngle, 0)
            CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        }
        
        
        //main dashborad
        CGContextSetLineWidth(context, lineSize)  //set circle line size;
        
        CGContextSetStrokeColorWithColor(context, normalColor.CGColor)
        CGContextAddArc(context,
                        (x  ??  0),
                        (y  ??  0),
                        radius,
                        startAngle,
                        endAngle,
                        0)
        CGContextDrawPath(context, .Stroke)
        
        //
        let cicleFragment  = radians(CGFloat(fragment))
        
        CGContextSetStrokeColorWithColor(context,  dangerColor.CGColor)
        CGContextAddArc(context, x!, y!, radius, startAngle, startAngle + radians(CGFloat(fragment+1)), 0)
        CGContextDrawPath(context, .Stroke)
        
        //
        CGContextSetStrokeColorWithColor(context,  enoughColor.CGColor)
        CGContextAddArc(context, x!, y!, radius, endAngle - cicleFragment, endAngle, 0)
        CGContextDrawPath(context, .Stroke)
        
        
        var len: CGFloat = 10
        var width: Double  = 1
        var realColor: UIColor
                
        let numberRadius = radius - 25
        
        for index in 0...100 {
            if index % 10 > 0 {
                len = 6
                width = 0.5
            }else{
                len = 10
                width = 1
            }
            var end: CGFloat = CGFloat(end - Double(index) * 2.4)
            var start: CGFloat = end - CGFloat(width)
            CGContextSetLineWidth(context, len)
            if start > CGFloat(normal) {
                realColor = enoughColor
            }else if end <= CGFloat(danger+1){
                realColor = dangerColor
            }else{
                realColor = normalColor
            }
            CGContextSetStrokeColorWithColor(context,  realColor.CGColor)
            
            CGContextAddArc(context, x!, y!, radius - len, radians(start), radians(end), 0)
            CGContextDrawPath(context, .Stroke)
            
            if index % 10 == 0 {
                var tmp: Double = (Double(index) * 2.4 - 30) * M_PI / 180;
                var movedFirstX: CGFloat = CGFloat(cos(tmp)) * numberRadius
                var movedFirstY: CGFloat = CGFloat(sin(tmp)) * numberRadius
                let number:NSString = String(100 - index)
                var numberAttributes: [String: AnyObject] = [
                    NSForegroundColorAttributeName : realColor,
                    NSFontAttributeName : UIFont.systemFontOfSize(12)
                ]
                var numberFontSize = number.sizeWithAttributes(numberAttributes)
                number.drawAtPoint(CGPointMake((x! + movedFirstX - numberFontSize.width/2), (y! - movedFirstY - numberFontSize.height/2)), withAttributes: numberAttributes)
            }
        }
        
        drawTitle(title)
        
        showPointerView(progress, radius:radius)
        
        drawExplainLabel(explain)
        
    }
    var explainAttributes: [String: AnyObject] = [
        NSForegroundColorAttributeName : UIColor(white: 0.0, alpha: 1.0),
        NSFontAttributeName : UIFont.systemFontOfSize(20)
    ]
    
    var attributedString: NSAttributedString?
    
    func drawTitle(_ title: String){
        let font:UIFont! = UIFont.systemFontOfSize(fontSize)
        var textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName:font
        ]
        
        attributedString = NSAttributedString(string: title, attributes: textAttributes)
        
        attributedString!.drawAtPoint(CGPointMake(x!-(attributedString!.size().width/2), y!-60))
        
    }
    
    private func drawExplainLabel(explain: String) {
        let explainSize: CGSize = explain.sizeWithAttributes(explainAttributes)
        ///if exsit, remove from superView
        if let viewWithTag = self.viewWithTag(98) {
            viewWithTag.removeFromSuperview()
            explainLabel = nil
        }
        explainLabel = UILabel(frame: CGRectMake(x!-(explainSize.width/2), (y! + 50), frame.size.width, explainSize.height))
        explainLabel?.tag = 98
        explainLabel?.attributedText = NSAttributedString(string: explain, attributes: explainAttributes)
        explainLabel?.textColor = UIColor(red:  64/255, green: 64/255, blue: 64/255, alpha: 1)
        self.addSubview(explainLabel!)
    }
    
    //middle pointer
    private func showPointerView(progress: CGFloat, radius: CGFloat){
        var realColor: UIColor
        if(progress <= 20){
            realColor = dangerColor
        }else if(progress > 80){
            realColor = enoughColor
        }else{
            realColor = normalColor
        }
        ///if exsit, remove from superView
        if let viewWithTag = self.viewWithTag(99) {
            viewWithTag.removeFromSuperview()
            pointer = nil
        }
        pointer = PointerView(frame:CGRectMake(0, 0, self.frame.width, self.frame.height), radius: (radius-10), progress: Double((100 - progress)*2.4), color: realColor.CGColor)
        pointer!.backgroundColor = .clearColor()
        pointer!.tag = 99
        self.addSubview(pointer!)
    }
    
    
    
    func radians (degrees: CGFloat) -> CGFloat { return degrees * CGFloat(M_PI / 180); }
}
