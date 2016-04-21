import UIKit

class ViewController: UIViewController {
    
    var key: String? = nil {
        didSet {
            if key != nil {
                spin()
            }
        }
    }
    let urlRoot = "https://api.flickr.com/services/rest/?"
    //to you these you must have your flickr apikey stored in a filed titled flickr.api
    //as a json style dictionary
    //{"key": "yourkeyhere"}
    let defaultSuffix = "method=flickr.photos.getRecent&format=json&"
    let searchSuffix = "method=flickr.photos.search&format=json&text="
    
    @IBOutlet var textBox: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    var search: Search?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spin()
        while key == nil {
            key = getKey()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSearch() {
        var url: NSURL?
        if textBox.hasText() {
            let urlText = "\(urlRoot)\(searchSuffix)\(textBox.text!)&api_key=\(key!)"
            url = NSURL(string: urlText)
        } else {
            url = NSURL(string: "\(urlRoot)\(defaultSuffix)&api_key=\(key)")
        }
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, res, err in
            if let responseData = data {
                let repairedData = self.processFlickrResponse(responseData)
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(repairedData, options: .AllowFragments)
                    print(json)
                } catch {
                    print("error: \(error)")
                }
            }
            
        }
        task.resume()
        
    }
    
    private func processFlickrResponse(response: NSData) -> NSData {
        let range = 14...(response.length-2)
        let nsRange = NSRange(range)
        let trimmedData = response.subdataWithRange(nsRange)
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
    
    func spin() {
        if spinner.isAnimating() {
            spinner.stopAnimating()
            textBox.enabled = true
            searchButton.enabled = true
        } else {
            spinner.startAnimating()
            textBox.enabled = false
            searchButton.enabled = false
        }
    }
}

