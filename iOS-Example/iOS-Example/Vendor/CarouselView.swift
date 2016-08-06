//
//  CarouselView.swift
//  CarouselView
//
//  Created by 谢某某 on 16/4/5.
//  Copyright © 2016年 谢某某. All rights reserved.
//

import UIKit

/// 方向枚举
public enum Direction {
    case DirecNone
    case DirecLeft
    case DirecRight
}

/// 代理协议
public protocol CarouselViewDelegate: class {
    /// 改变方向
    func carouselViewWillChangeDirection(carouselView car: CarouselView, index: Int, originalDir: Direction, presentDir: Direction) -> Void
    /// 结束动画
    func carouselViewDidEndAnimation(carouselView car: CarouselView, index: Int) -> Void
    /// 点击
    func carouselViewDidSelect(carouselView car: CarouselView, index: Int)
}
extension CarouselViewDelegate {
    func carouselViewWillChangeDirection(carouselView car: CarouselView, index: Int, originalDir: Direction, presentDir: Direction) -> Void {}
    func carouselViewDidEndAnimation(carouselView car: CarouselView, index: Int) -> Void {}
    func carouselViewDidSelect(carouselView car: CarouselView, index: Int) -> Void {}
}

//MARK: - 轮播图
public class CarouselView: UIView
{
    /// 代理
    public weak var delegate: CarouselViewDelegate?
    
    /// timer间隔时间,默认2.0秒
    public var timeInterval: NSTimeInterval = 2.0 {
        didSet{
            imagePath.count > 1 ? self.startTimer() : (scrollView.scrollEnabled = false)
        }
    }
    
    /// 占位图
    public var placeHolder = "4.jpg"
    
    /// 要轮播的图片(可以是UIImage对象、url、imageName)
    public var imagePath: [AnyObject] = [] {
        didSet {
            /// 第一张的占位视图
            currImageV.image = UIImage(named: placeHolder)
            for (index, obj) in imagePath.enumerate()
            {
                if let x = obj as? UIImage {
                    self.imageArr.append(x)
                }else if let x  = obj as? String where x.hasPrefix("http://") {
                    self.imageArr.append(UIImage(named: placeHolder) ?? UIImage())
                    self.downImage(index)
                }else if let x  = obj as? String, let image = UIImage(named: x) {
                    self.imageArr.append(image)
                }
            }
            imagePath.count > 1 ? self.startTimer() : (scrollView.scrollEnabled = false)
            pageControl.numberOfPages = imageArr.count
        }
    }
    
    public typealias clo = (view: UIImageView!, index:Int) -> Void
    /// 点击当前imageView的closure
    public var clickImageView: clo?
    public let pageControl = UIPageControl()
    //MARK: --------------- private property --------------
    
    private let scrollView  = UIScrollView()
    private let currImageV  = UIImageView()
    private let otherImageV = UIImageView()
    
    
    private var timer: NSTimer?
    /// 滚动(滑动)方向
    private var direction: Direction = .DirecNone {
        didSet {
            self.handleCarousel(oldValue)
        }
    }
    /// 图片数组
    private var imageArr: [UIImage] = []
    /// 下载的图片内存缓存字典
    private var imageDic = [NSURL: UIImage]()
    /// 下载操作缓存字典
    private var operationDic = [NSURL: NSBlockOperation]()
    /// 下载操作重复的index字典
    private var indexDic = [NSURL: Set<Int>]()
    
    private var nextIndex = 0
    private var currIndex = 0
    
    //MARK: --------------- function --------------
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)

        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        
        currImageV.contentMode = .ScaleToFill
        currImageV.userInteractionEnabled = true
        currImageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CarouselView.clickImage(_:))))
        currImageV.backgroundColor = UIColor.whiteColor()
        
        otherImageV.contentMode = .ScaleToFill
        otherImageV.backgroundColor = UIColor.whiteColor()
        
        scrollView.addSubview(currImageV)
        scrollView.addSubview(otherImageV)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    /// 点击当前imageView
    func clickImage(tap: UITapGestureRecognizer) -> Void {
        if clickImageView != nil {
            clickImageView!(view: tap.view as? UIImageView, index: currIndex)
        }else{
            delegate?.carouselViewDidSelect(carouselView: self, index: currIndex)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.contentSize = CGSizeMake(3*bounds.width, 0)
        scrollView.contentOffset = CGPointMake(bounds.width, 0)
        currImageV.frame = CGRectMake(bounds.width, 0, bounds.width, bounds.height)
        
        let size = pageControl.sizeForNumberOfPages(imageArr.count)
        pageControl.frame = CGRectMake(bounds.width-size.width-10,
                                       bounds.height-size.height,
                                       size.width, size.height)
    }
    public func reloadData() {
        self.layoutSubviews()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        debugPrint("\(self.classForCoder)释放了")
    }
}

//MARK: scrollView delegate
extension CarouselView: UIScrollViewDelegate
{
    public func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let offsetX = scrollView.contentOffset.x
        switch offsetX {
        case let x where x > bounds.width: // 向右滑动
            direction = .DirecRight
        case let x where x < bounds.width: // 向左滑动
            direction = .DirecLeft
        default:
            direction = .DirecNone // 必须设置,不能忽略
        }
        
        // 回到scrollView的contentsize 的中间部分，以便无限滚动
        if offsetX % bounds.width == 0 && direction != .DirecNone
        {
            currIndex = nextIndex
            currImageV.image = otherImageV.image
            scrollView.contentOffset = CGPointMake(bounds.width, 0)
        }
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = currIndex
        delegate?.carouselViewDidEndAnimation(carouselView: self, index: currIndex)
    }
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        pageControl.currentPage = currIndex
        delegate?.carouselViewDidEndAnimation(carouselView: self, index: currIndex)
    }
}

//MARK: private function
extension CarouselView
{
    /// 处理滚动
    private func handleCarousel(oldValue: Direction) -> Void {
        /// 避免频繁调用
        guard direction != oldValue else { return }
        
        var x: CGFloat = 0, wid: CGFloat = 0, hei: CGFloat = 0
        switch direction
        {
        case .DirecLeft:
            x = 0; wid = bounds.width; hei = bounds.height
            nextIndex = currIndex-1
            if nextIndex < 0 { nextIndex = imageArr.count-1 }
            
        case .DirecRight:
            wid = bounds.width; hei = bounds.height
            x = CGRectGetMaxX(currImageV.frame)
            nextIndex = (currIndex+1) % imageArr.count
            
        default: break
        }
        otherImageV.frame = CGRectMake(x, 0, wid, hei)
        otherImageV.image = imageArr[nextIndex]
        delegate?.carouselViewWillChangeDirection(carouselView: self, index: currIndex, originalDir: oldValue, presentDir: direction)
    }
    
    private func startTimer() -> Void
    {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = WeakTimer.timerWith(timeInterval, target: self){ [unowned self] _ in
            self.scrollView.setContentOffset(CGPointMake(2*self.bounds.width, 0), animated: true)
        }
    }
    
    /// 下载imagePath中的图片
    private func downImage(index: Int) -> Void
    {
        let path = imagePath[index] as? String
        guard let url = path.flatMap(NSURL.init) else { return }
        
        var image = imageDic[url]
        guard image == nil else{ /// 内存缓存
            debugPrint("内存缓存")
            if imageArr.count > index { imageArr[index] = image! }
            return
        }
        
        let cacheData = NSURLCache.sharedURLCache().cachedResponseForRequest(NSURLRequest(URL: url))?.data
        image = cacheData.flatMap(UIImage.init)
        
        guard image == nil else { /// 沙盒缓存
            debugPrint("沙盒缓存")
            if index == 0 { currImageV.image = image }
            if imageArr.count > index { imageArr[index] = image! }
            imageDic[url] = image!
            return
        }
        
        if operationDic[url] == nil { /// 队列下载
            debugPrint("队列不存在")
            let op = NSBlockOperation{ [url, index]
                if let data = NSData(contentsOfURL: url),
                    let image = UIImage(data: data)?.decode()/// 解码
                {
                    GCD.async_main{
                        if self.imageArr.count > index {
                            self.imageArr[index] = image
                            self.indexDic[url]?.forEach{ self.imageArr[$0] = image }
                            self.indexDic.removeValueForKey(url)
                        }
                        self.operationDic.removeValueForKey(url)
                        self.imageDic[url] = image
                    }
                }
            }
            NSOperationQueue().addOperation(op)
            operationDic[url] = op
        }else{
            debugPrint("队列存在")
            if indexDic[url] == nil { indexDic[url] = [] }
            indexDic[url]!.insert(index)
        }
    }
}

//MARK: - WeakTimer
public struct WeakTimer
{
    /// 不对target强引用,不阻塞主线程,不需要在deinit中释放
    public static func timerWith(timeInterval: NSTimeInterval, target: AnyObject, selector: Selector, userInfo: AnyObject? = nil, repeats: Bool = true) -> NSTimer
    {
        let proxy = WeakProxy()
        proxy.target = target
        proxy.selector = selector
        
        let timer = NSTimer(timeInterval: timeInterval, target: proxy, selector: #selector(WeakProxy.fire), userInfo: userInfo, repeats: repeats)
        
        GCD.async_globle {
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
        }
        
        proxy.timer = timer
        return timer
    }
    
    /// 不对target强引用,不阻塞主线程,不需要在deinit中释放
    public static func timerWith(timeInterval: NSTimeInterval, target: AnyObject, repeats: Bool = true, _ closure: NSTimer? -> Void) -> NSTimer
    {
        let proxy = WeakProxy()
        proxy.target = target
        proxy.closour = closure
        
        let timer = NSTimer(timeInterval: timeInterval, target: proxy, selector: #selector(WeakProxy.executeClosure), userInfo: nil, repeats: repeats)
        
        GCD.async_globle {
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
        }
        
        proxy.timer = timer
        return timer
    }
}

//MARK: - WeakProxy
private final class WeakProxy: NSObject
{
    private weak var target: AnyObject? = nil
    private var selector: Selector?
    private var closour: (NSTimer?) -> Void = {_ in}
    private weak var timer: NSTimer?
    
    @objc func fire() -> Void {
        if target != nil && selector != nil
            && target!.respondsToSelector(selector!)
        {
            GCD.async_main{ self.target?.performSelector(self.selector!) }
        }else {
            self.invalidateTimer()
        }
    }
    
    @objc func executeClosure() -> Void {
        if target == nil {
            self.invalidateTimer(); return
        }
        
        unowned let weakSelf = self
        GCD.async_main{ self.closour(weakSelf.timer) }
    }
    
    private func invalidateTimer() -> Void {
        if timer != nil { timer!.invalidate() }
        timer = nil
    }
    
    deinit {
        debugPrint("timer释放了")
    }
}

public struct GCD
{
    public static func async_main(clo: dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), clo)
    }
    public static func async_globle(clo: dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(0, 0), clo)
    }
}

extension UIImageView {
    /// 后台解码图片
    func decodeInBackground(img: UIImage?) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let image = img?.decode()
            dispatch_async(dispatch_get_main_queue(), {
                self.image = image
            })
        }
    }
}

extension UIImage {
    /// 解码图片
    func decode() -> UIImage
    {
        do {
            guard self.images == nil else { return self }
            
            let imageRef = self.CGImage
            let alpha = CGImageGetAlphaInfo(imageRef)
            
            let anyAlpha = (alpha == .First || alpha == .Last ||
                alpha == .PremultipliedFirst ||
                alpha == .PremultipliedLast)
            if anyAlpha { return self }
            
            let width = CGImageGetWidth(imageRef)
            let height = CGImageGetHeight(imageRef)
            
            let imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef))
            var colorspaceRef = CGImageGetColorSpace(imageRef)
            
            let unsupportedColorSpace = (imageColorSpaceModel.rawValue == 0 || imageColorSpaceModel.rawValue == -1 || imageColorSpaceModel == .CMYK || imageColorSpaceModel == .Indexed)
            
            if unsupportedColorSpace { colorspaceRef = CGColorSpaceCreateDeviceRGB() }
            
            let void = UnsafeMutablePointer<Void>(nil)
            let context = CGBitmapContextCreate(void, width, height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                colorspaceRef,
                                                CGBitmapInfo.ByteOrderDefault.rawValue
                                                    | CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
            CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)
            let imageRefWithAlpha = CGBitmapContextCreateImage(context)!
            
            let imageWithAlpha = UIImage(CGImage: imageRefWithAlpha, scale: self.scale, orientation: self.imageOrientation)
            
            return imageWithAlpha
        }
    }
}






