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
    case direcNone
    case direcLeft
    case direcRight
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
open class CarouselView: UIView
{
    /// 代理
    open weak var delegate: CarouselViewDelegate?
    
    /// timer间隔时间,默认2.0秒
    open var timeInterval: TimeInterval = 2.0 {
        didSet{
            imagePath.count > 1 ? self.startTimer() : (scrollView.isScrollEnabled = false)
        }
    }
    
    /// 占位图
    open var placeHolder = "4.jpg"
    
    /// 要轮播的图片(可以是UIImage对象、url、imageName)
    open var imagePath: [AnyObject] = [] {
        didSet {
            /// 第一张的占位视图
            currImageV.image = UIImage(named: placeHolder)
            for (index, obj) in imagePath.enumerated()
            {
                if let x = obj as? UIImage {
                    self.imageArr.append(x)
                }else if let x  = obj as? String , x.hasPrefix("http://") {
                    self.imageArr.append(UIImage(named: placeHolder) ?? UIImage())
                    self.downImage(index)
                }else if let x  = obj as? String, let image = UIImage(named: x) {
                    self.imageArr.append(image)
                }
            }
            imagePath.count > 1 ? self.startTimer() : (scrollView.isScrollEnabled = false)
            pageControl.numberOfPages = imageArr.count
        }
    }
    
    public typealias clo = (_ view: UIImageView?, _ index:Int) -> Void
    /// 点击当前imageView的closure
    open var clickImageView: clo?
    open let pageControl = UIPageControl()
    //MARK: --------------- private property --------------
    
    fileprivate let scrollView  = UIScrollView()
    fileprivate let currImageV  = UIImageView()
    fileprivate let otherImageV = UIImageView()
    
    
    fileprivate var timer: Timer?
    /// 滚动(滑动)方向
    fileprivate var direction: Direction = .direcNone {
        didSet {
            self.handleCarousel(oldValue)
        }
    }
    /// 图片数组
    fileprivate var imageArr: [UIImage] = []
    /// 下载的图片内存缓存字典
    fileprivate var imageDic = [URL: UIImage]()
    /// 下载操作缓存字典
    fileprivate var operationDic = [URL: BlockOperation]()
    /// 下载操作重复的index字典
    fileprivate var indexDic = [URL: Set<Int>]()
    
    fileprivate var nextIndex = 0
    fileprivate var currIndex = 0
    
    //MARK: --------------- function --------------
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)

        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.white
        
        currImageV.contentMode = .scaleToFill
        currImageV.isUserInteractionEnabled = true
        currImageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CarouselView.clickImage(_:))))
        currImageV.backgroundColor = UIColor.white
        
        otherImageV.contentMode = .scaleToFill
        otherImageV.backgroundColor = UIColor.white
        
        scrollView.addSubview(currImageV)
        scrollView.addSubview(otherImageV)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    /// 点击当前imageView
    func clickImage(_ tap: UITapGestureRecognizer) -> Void {
        if clickImageView != nil {
            clickImageView!(tap.view as? UIImageView, currIndex)
        }else{
            delegate?.carouselViewDidSelect(carouselView: self, index: currIndex)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: 3*bounds.width, height: 0)
        scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        currImageV.frame = CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height)
        
        let size = pageControl.size(forNumberOfPages: imageArr.count)
        pageControl.frame = CGRect(x: bounds.width-size.width-10,
                                       y: bounds.height-size.height,
                                       width: size.width, height: size.height)
    }
    open func reloadData() {
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
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetX = scrollView.contentOffset.x
        switch offsetX {
        case let x where x > bounds.width: // 向右滑动
            direction = .direcRight
        case let x where x < bounds.width: // 向左滑动
            direction = .direcLeft
        default:
            direction = .direcNone // 必须设置,不能忽略
        }
        
        // 回到scrollView的contentsize 的中间部分，以便无限滚动
        if offsetX.truncatingRemainder(dividingBy: bounds.width) == 0 && direction != .direcNone
        {
            currIndex = nextIndex
            currImageV.image = otherImageV.image
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = currIndex
        delegate?.carouselViewDidEndAnimation(carouselView: self, index: currIndex)
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = currIndex
        delegate?.carouselViewDidEndAnimation(carouselView: self, index: currIndex)
    }
}

//MARK: private function
extension CarouselView
{
    /// 处理滚动
    fileprivate func handleCarousel(_ oldValue: Direction) -> Void {
        /// 避免频繁调用
        guard direction != oldValue else { return }
        
        var x: CGFloat = 0, wid: CGFloat = 0, hei: CGFloat = 0
        switch direction
        {
        case .direcLeft:
            x = 0; wid = bounds.width; hei = bounds.height
            nextIndex = currIndex-1
            if nextIndex < 0 { nextIndex = imageArr.count-1 }
            
        case .direcRight:
            wid = bounds.width; hei = bounds.height
            x = currImageV.frame.maxX
            nextIndex = (currIndex+1) % imageArr.count
            
        default: break
        }
        otherImageV.frame = CGRect(x: x, y: 0, width: wid, height: hei)
        otherImageV.image = imageArr[nextIndex]
        delegate?.carouselViewWillChangeDirection(carouselView: self, index: currIndex, originalDir: oldValue, presentDir: direction)
    }
    
    fileprivate func startTimer() -> Void
    {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = WeakTimer.timerWith(timeInterval, target: self){ [unowned self] _ in
            self.scrollView.setContentOffset(CGPoint(x: 2*self.bounds.width, y: 0), animated: true)
        }
    }
    
    /// 下载imagePath中的图片
    fileprivate func downImage(_ index: Int) -> Void
    {
        let path = imagePath[index] as? String
        guard let url = path.flatMap(URL.init) else { return }
        
        var image = imageDic[url]
        guard image == nil else{ /// 内存缓存
            debugPrint("内存缓存")
            if imageArr.count > index { imageArr[index] = image! }
            return
        }
        
        let cacheData = URLCache.shared.cachedResponse(for: URLRequest(url: url))?.data
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
            let op = BlockOperation{ [url, index] as [Any]
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)?.decode()/// 解码
                {
                    GCD.async_main{
                        if self.imageArr.count > index {
                            self.imageArr[index] = image
                            self.indexDic[url]?.forEach{ self.imageArr[$0] = image }
                            self.indexDic.removeValue(forKey: url)
                        }
                        self.operationDic.removeValue(forKey: url)
                        self.imageDic[url] = image
                    }
                }
            }
            OperationQueue().addOperation(op)
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
    public static func timerWith(_ timeInterval: TimeInterval, target: AnyObject, selector: Selector, userInfo: AnyObject? = nil, repeats: Bool = true) -> Timer
    {
        let proxy = WeakProxy()
        proxy.target = target
        proxy.selector = selector
        
        let timer = Timer(timeInterval: timeInterval, target: proxy, selector: #selector(WeakProxy.fire), userInfo: userInfo, repeats: repeats)
        
        GCD.async_globle {
            RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
        }
        
        proxy.timer = timer
        return timer
    }
    
    /// 不对target强引用,不阻塞主线程,不需要在deinit中释放
    public static func timerWith(_ timeInterval: TimeInterval, target: AnyObject, repeats: Bool = true, _ closure: @escaping (Timer?) -> Void) -> Timer
    {
        let proxy = WeakProxy()
        proxy.target = target
        proxy.closour = closure
        
        let timer = Timer(timeInterval: timeInterval, target: proxy, selector: #selector(WeakProxy.executeClosure), userInfo: nil, repeats: repeats)
        
        GCD.async_globle {
            RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
        }
        
        proxy.timer = timer
        return timer
    }
}

//MARK: - WeakProxy
private final class WeakProxy: NSObject
{
    fileprivate weak var target: AnyObject? = nil
    fileprivate var selector: Selector?
    fileprivate var closour: (Timer?) -> Void = {_ in}
    fileprivate weak var timer: Timer?
    
    @objc func fire() -> Void {
        if target != nil && selector != nil
            && target!.responds(to: selector!)
        {
            GCD.async_main{ self.target?.perform(self.selector!) }
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
    
    fileprivate func invalidateTimer() -> Void {
        if timer != nil { timer!.invalidate() }
        timer = nil
    }
    
    deinit {
        debugPrint("timer释放了")
    }
}

public struct GCD
{
    public static func async_main(_ clo: @escaping ()->()){
        DispatchQueue.main.async(execute: clo)
    }
    public static func async_globle(_ clo: @escaping ()->()){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: clo)
//        DispatchQueue.global(priority: 0).async(execute: clo)

    }
}

extension UIImageView {
    /// 后台解码图片
    func decodeInBackground(_ img: UIImage?) -> Void {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            let image = img?.decode()
            DispatchQueue.main.async(execute: {
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
            
            let imageRef = self.cgImage
            let alpha = imageRef?.alphaInfo
            
            let anyAlpha = (alpha == .first || alpha == .last ||
                alpha == .premultipliedFirst ||
                alpha == .premultipliedLast)
            if anyAlpha { return self }
            
            let width = imageRef?.width
            let height = imageRef?.height
            
            let imageColorSpaceModel = imageRef?.colorSpace?.model
            var colorspaceRef = imageRef?.colorSpace
            
            let unsupportedColorSpace = (imageColorSpaceModel?.rawValue == 0 || imageColorSpaceModel?.rawValue == -1 || imageColorSpaceModel == .cmyk || imageColorSpaceModel == .indexed)
            
            if unsupportedColorSpace { colorspaceRef = CGColorSpaceCreateDeviceRGB() }
            
//            let void = UnsafeMutableRawPointer()
            let context = CGContext.init(data: nil, width: width!, height: height!, bitsPerComponent: (imageRef?.bitsPerComponent)!, bytesPerRow: 0, space: colorspaceRef!, bitmapInfo: CGBitmapInfo().rawValue
                | CGImageAlphaInfo.premultipliedFirst.rawValue)
            
//            let context = CGContext(data: void, width: width, height: height,
//                                                bitsPerComponent: imageRef.bitsPerComponent,
//                                                bytesPerRow: 0,
//                                                space: colorspaceRef,
//                                                bitmapInfo: CGBitmapInfo().rawValue
//                                                    | CGImageAlphaInfo.premultipliedFirst.rawValue)
    
            context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
            let imageRefWithAlpha = context?.makeImage()!
            
            let imageWithAlpha = UIImage(cgImage: imageRefWithAlpha!, scale: self.scale, orientation: self.imageOrientation)
            
            return imageWithAlpha
        }
    }
}






