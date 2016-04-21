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
        FarmId = dict["farm"] as! Int
        ServerId = dict["server"] as! Int
        Id = dict["id"] as! Int
        Secret = dict["secret"]  as! String
        Image = CIImage(contentsOfURL: Url)
    }
}