import Kingfisher
class BMKLocalSyncTileLayer: BMKSyncTileLayer {
    /**
     @brief 通过同步方法获取瓦片数据，子类必须实现该方法
     这个方法会在多个线程中调用，需要考虑线程安全
     @param (x, y, zoom)x,y表示瓦片的行列号，zoom为地图的缩放等级
     @return UIImage所对应瓦片的UIImage对象
     */

    override func tileFor(x: Int, y: Int, zoom: Int) -> UIImage? {
        var image : UIImage? = nil
        if let url = URL(string: String(format: "http://\(Host!)/images/\(mapPath!)%ld/%ld_%ld.png", zoom, x, y)){
            if ImageCache.default.isCached(forKey: url.absoluteString) == false{
                do {
                    image = UIImage(data: try Data(contentsOf: url))
                    ImageCache.default.store(image!, forKey: url.absoluteString)
                    image = ImageCache.default.retrieveImageInDiskCache(forKey: url.absoluteString)
                }catch{
                }
            }else{
                image = ImageCache.default.retrieveImageInDiskCache(forKey: url.absoluteString)
            }
        }
        return image
    }
}
