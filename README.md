FlickrTV
===============
Class project for tvOS

User Experience
----------------------
The user is greeted with a search box when
the application opens. Once they enter text in this box and select
the search button, the application will start the
activity indicator animation.

TODO: insert main blank SS

after the images have been retrieved they will be
displayed on the screen.

TODO: insert populated SS

Code
-------------

the application utilizes two simple objects to 
represent the results provided by a flickr search

the search object
This object hold the term used to search flickr
and the resulting images.
``` swift
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

```
and the image object
this object is constructed by the response from flickr
in the form of a dictionary, the actual image is
then pulled down using the url constructed 
from the initial response.
``` swift
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
```
the following code in the view controller is used
to make the call to Flickr, trim the extra
characters in the response and then process
the respose into an array of Images
``` swift
func parseSearch(term: String) -> String { 
         let set = NSCharacterSet(charactersInString: ".,/';[]\\") 
         let trimmedString = term.stringByTrimmingCharactersInSet(set) 
         var finalString = "" 
         for char in trimmedString.characters { 
             if char == " " { 
                 finalString.appendContentsOf("%20") 
             } else { 
                 finalString.appendContentsOf("char") 
             } 
         } 
         return finalString 
     } 
      
     private func processFlickrResponse(response: NSData) { 
         do { 
             let formattedData = formatData(response) 
             let dictionary = try convertDataToDictionar(formattedData) 
             parseDictionary(dictionary) 
         images = parseDictionary(dictionary) 
     } catch { 
         print(error) 
     } 
} 
  
 private func formatData(response: NSData) -> NSData { 
     let range = 14...(response.length-2) 
     let nsRange = NSRange(range) 
     return response.subdataWithRange(nsRange) 
     } 
      
     private func convertDataToDictionar(data: NSData) throws -> NSDictionary { 
             return try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary 
     } 
          
     private func parseDictionary(dictionary: NSDictionary) -> [CIImage] { 
         print(dictionary) 
         var images = [CIImage]() 
         let outerDict = dictionary["photos"] as! NSDictionary 
         let dictArray = outerDict["photo"] as! [NSDictionary] 
         for dict in dictArray { 
             images.append(Image(dict: dict).Image!) 
             collectionView.reloadData() 
         } 
         return images 
     } 
```
