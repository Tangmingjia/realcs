func animation(ImageName: String, ImageView: UIImageView){
    guard let imgPath = Bundle.main.path(forResource: ImageName, ofType: "gif") else { return }
    guard let imgData = NSData(contentsOfFile: imgPath) else { return }
    
    // 2、从data中读取数据：将data转成CGImageSource对象
    guard let imgSource = CGImageSourceCreateWithData(imgData, nil) else {
        return
    }
    
    // 3、获取在CGImageSource中图片的个数
    let imgCount = CGImageSourceGetCount(imgSource)
    
    // 4、遍历所有图片
    var imgs = [UIImage]()
    var totalDuration: TimeInterval = 0
    for i in 0..<imgCount {
        // 4.1、取出图片
        guard let cgimg = CGImageSourceCreateImageAtIndex(imgSource, i, nil) else { continue }
        let img = UIImage(cgImage: cgimg)
        if i == 0 { // 保证执行完一次gif后不消失
            ImageView.image = img
        }
        imgs.append(img)
        
        // 4.2、取出持续的时间
        guard let properties = CGImageSourceCopyPropertiesAtIndex(imgSource, i, nil) as? NSDictionary else { continue }
        guard let dict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
        guard let duration = dict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
        totalDuration += duration.doubleValue
    }
    // 5、设置imageView的属性
    ImageView.animationImages = imgs
    ImageView.animationDuration = totalDuration
    ImageView.animationRepeatCount = 0  // 执行一次，设置为0时无限执行
    
    // 6、开始/停止播放
    ImageView.startAnimating()
//    ImageView.stopAnimating()
}
