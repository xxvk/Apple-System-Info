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
open class Dashboard: UIView {
    
    var fontSize:CGFloat = 16
    var lineSize:CGFloat = 10
    var isBorder: Bool = false
    var progress:CGFloat = 0
    var explain: String = ""
    
    
    //private
    fileprivate var _title: String = "left"
    fileprivate var x: CGFloat? = 0
    fileprivate var y: CGFloat? = 0
    fileprivate var radius: CGFloat! = 0
    fileprivate var pointer: PointerView?
    fileprivate var explainLabel: UILabel?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaultValue()
    }
    open func setupDefaultValue() {
        x = frame.size.width/2
        y = frame.size.height/2
        radius = frame.size.width/2-10
        self.backgroundColor = UIColor.clear
    }
    
    convenience public init(frame: CGRect, title: String, left: CGFloat, total: CGFloat, suffix: String, format: String = "%.f", isBorder: Bool = false){
        self.init(frame: frame)
        self.title = title ?? ""
        self.isBorder = isBorder
        self.change(left, total: total, suffix: suffix, format: format)
        self.backgroundColor = UIColor.clear
    }
    
    open func change(_ left: CGFloat, total: CGFloat, suffix: String, format: String = "%.f"){
        self.progressMirage = (left / total) * 100
        self.explainMirage = NSString(format: format as NSString, left) as String + "/" + (NSString(format: format as NSString, total) as String)  as String + suffix
    }
    
    open var title:String{
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
    
    
    
    override open func draw(_ rect: CGRect) {
        //get graphics context
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.setAllowsAntialiasing(true)
        
        //
        var start = 149.5, end = 390.5, fragment = 2.4*20, normal = end - fragment, danger = start + fragment
        
        let startAngle: CGFloat = radians(CGFloat(start));
        let endAngle: CGFloat = radians(CGFloat(end));
        
        //border
        if isBorder {
            let borderColor = UIColor(red: 51/255, green: 102/255, blue: 153/255, alpha: 1).cgColor
            context.setLineWidth(lineSize)
        
            context.setStrokeColor(borderColor)
            context.addArc(center: CGPoint.init(x: x!, y: y!), radius: radius-4, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//            CGContextAddArc(context, x!, y!, radius-4, startAngle, endAngle, 0)
            context.drawPath(using: CGPathDrawingMode.stroke)
        
            context.setStrokeColor(borderColor)

//            CGContextAddArc(context, x!, y!, radius+4, startAngle, endAngle, 0)
            context.addArc(center: CGPoint.init(x: x!, y: y!), radius: radius+4, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        
        //main dashborad
        context.setLineWidth(lineSize)  //set circle line size;
        
        context.setStrokeColor(normalColor.cgColor)
//        CGContextAddArc(context,
//                        (x  ??  0),
//                        (y  ??  0),
//                        radius,
//                        startAngle,
//                        endAngle,
//                        0)
        context.addArc(center: CGPoint.init(x: x ?? 0, y: y ?? 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.drawPath(using: .stroke)
        
        //
        let cicleFragment  = radians(CGFloat(fragment))
        
        context.setStrokeColor(dangerColor.cgColor)
//        CGContextAddArc(context, x!, y!, radius, startAngle, startAngle + radians(CGFloat(fragment+1)), 0)
        context.addArc(center: CGPoint.init(x: x!, y: y!), radius: radius, startAngle: startAngle, endAngle: startAngle + radians(CGFloat(fragment+1)), clockwise: false)
        context.drawPath(using: .stroke)
        
        //
        context.setStrokeColor(enoughColor.cgColor)
//        CGContextAddArc(context, x!, y!, radius, endAngle - cicleFragment, endAngle, 0)
        context.addArc(center: CGPoint.init(x: x!, y: y!), radius: radius, startAngle: endAngle - cicleFragment, endAngle: endAngle, clockwise: false)
        context.drawPath(using: .stroke)
        
        
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
            let end: CGFloat = CGFloat(end - Double(index) * 2.4)
            let start: CGFloat = end - CGFloat(width)
            context.setLineWidth(len)
            if start > CGFloat(normal) {
                realColor = enoughColor
            }else if end <= CGFloat(danger+1){
                realColor = dangerColor
            }else{
                realColor = normalColor
            }
            context.setStrokeColor(realColor.cgColor)
            
            context.addArc(center: CGPoint.init(x: x!, y: y!), radius: radius - len, startAngle: radians(start), endAngle: radians(end), clockwise: false)
//            CGContextAddArc(context, x!, y!, radius - len, radians(start), radians(end), 0)
            context.drawPath(using: .stroke)
            
            if index % 10 == 0 {
                let tmp: Double = (Double(index) * 2.4 - 30) * M_PI / 180;
                let movedFirstX: CGFloat = CGFloat(cos(tmp)) * numberRadius
                let movedFirstY: CGFloat = CGFloat(sin(tmp)) * numberRadius
                let number:NSString = String(100 - index) as NSString
                let numberAttributes: [String: AnyObject] = [
                    NSForegroundColorAttributeName : realColor,
                    NSFontAttributeName : UIFont.systemFont(ofSize: 12)
                ]
                let numberFontSize = number.size(attributes: numberAttributes)
                number.draw(at: CGPoint(x: (x! + movedFirstX - numberFontSize.width/2), y: (y! - movedFirstY - numberFontSize.height/2)), withAttributes: numberAttributes)
            }
        }
        
        drawTitle(title)
        
        showPointerView(progress, radius:radius)
        
        drawExplainLabel(explain)
        
    }
    var explainAttributes: [String: AnyObject] = [
        NSForegroundColorAttributeName : UIColor(white: 0.0, alpha: 1.0),
        NSFontAttributeName : UIFont.systemFont(ofSize: 20)
    ]
    
    var attributedString: NSAttributedString?
    
    func drawTitle(_ title: String){
        let font:UIFont! = UIFont.systemFont(ofSize: fontSize)
        let textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName:font
        ]
        
        attributedString = NSAttributedString(string: title, attributes: textAttributes)
        
        attributedString!.draw(at: CGPoint(x: x!-(attributedString!.size().width/2), y: y!-60))
        
    }
    
    fileprivate func drawExplainLabel(_ explain: String) {
        let explainSize: CGSize = explain.size(attributes: explainAttributes)
        ///if exsit, remove from superView
        if let viewWithTag = self.viewWithTag(98) {
            viewWithTag.removeFromSuperview()
            explainLabel = nil
        }
        explainLabel = UILabel(frame: CGRect(x: x!-(explainSize.width/2), y: (y! + 50), width: frame.size.width, height: explainSize.height))
        explainLabel?.tag = 98
        explainLabel?.attributedText = NSAttributedString(string: explain, attributes: explainAttributes)
        explainLabel?.textColor = UIColor(red:  64/255, green: 64/255, blue: 64/255, alpha: 1)
        self.addSubview(explainLabel!)
    }
    
    //middle pointer
    fileprivate func showPointerView(_ progress: CGFloat, radius: CGFloat){
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
        pointer = PointerView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), radius: (radius-10), progress: Double((100 - progress)*2.4), color: realColor.cgColor)
        pointer!.backgroundColor = UIColor.clear
        pointer!.tag = 99
        self.addSubview(pointer!)
    }
    
    
    
    func radians (_ degrees: CGFloat) -> CGFloat { return degrees * CGFloat(M_PI / 180); }
}
