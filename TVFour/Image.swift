import Foundation
import CoreImage

struct Image {
    
    private var FarmId: Int
    private var ServerId: Int
    private var Id: Int
    private var Secret: String
    private var Url: NSURL {
        return NSURL(string: "https://farm\(FarmId).staticflickr.com/\(ServerId)/\(Id)_\(Secret)_q.jpg")!
    }
    var Image: CIImage?
    
    init(dict: NSDictionary) {
        let fid = dict["farm"] as! Int
        let sid = dict["server"] as! String
        let id = dict["id"] as! String
        let sec = dict["secret"] as! String

        FarmId = fid
        ServerId = Int(sid)!
        Id = Int(id)!
        Secret = String(sec)
        Image = CIImage(contentsOfURL: Url)
    }
}