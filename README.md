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
