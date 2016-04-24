
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var key: String? = nil {
        didSet {
            if key != nil {
                spinStop()
            }
        }
    }
    let urlRoot = "https://api.flickr.com/services/rest/?"
    //to you these you must have your flickr apikey stored in a filed titled flickr.api
    //as a json style dictionary
    //{"key": "yourkeyhere"}
    let defaultSuffix = "method=flickr.photos.getRecent&format=json&per_page=50&"
    let searchSuffix = "method=flickr.photos.search&format=json&per_page=50&text="
    
    @IBOutlet var textBox: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    var images = [CIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spinStart()
        while key == nil {
            key = getKey()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSearch() {
        spinStart()
        let url = constructUrl()
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, res, err in
            if let responseData = data {
                print(NSString(data: responseData, encoding: 8))
                self.processFlickrResponse(responseData)
                self.collectionView.reloadData()
                self.spinStop()
            }
            
        }
        task.resume()
    }
    
    func constructUrl() -> NSURL{
        if textBox.hasText() {
            let term = parseSearch(textBox.text!)
            let urlText = "\(urlRoot)\(searchSuffix)\(term)&api_key=\(key!)"
            return NSURL(string: urlText)!
        } else {
            let urlText = "\(urlRoot)\(defaultSuffix)&api_key=\(key!)"
            return NSURL(string: urlText)!
        }

    }
    
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
    
    func getKey() -> String? {
        var key = ""
        let path = NSBundle.mainBundle().pathForResource("flickr", ofType: "api")
        do {
            let data = NSFileManager.defaultManager().contentsAtPath(path!)
            guard let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return nil
            }
            key = dict["key"] as! String
        } catch {
            print("errlr: \(error)")
        }
        return key
    }
    
    func spinStart() {
        spinner.startAnimating()
        textBox.enabled = false
        searchButton.enabled = false
    }
    
    func spinStop() {
        spinner.stopAnimating()
        textBox.enabled = true
        searchButton.enabled = true

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionCell
        cell.image.image = UIImage(CIImage: (images[indexPath.row]))
        return cell
    }
}

