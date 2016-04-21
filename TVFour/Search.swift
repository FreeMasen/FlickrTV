import Foundation
import CoreImage

class Search {
    
    var Term: String
    var Results: [CIImage]?
    var DateTime = NSDate()
    
    init(term: String) {
        Term = term
    }
    
    func complete(result: [CIImage]) {
        Results = result
    }
    
    static func getImage(url: String) -> CIImage {
        return CIImage(contentsOfURL: NSURL(fileURLWithPath: url))!
    }
}