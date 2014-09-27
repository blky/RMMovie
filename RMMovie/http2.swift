import UIKit
protocol http2Protocol{
    func http2DidReceive(JSONData:NSDictionary)
}

class http2: NSObject {
    
    var delegate:http2Protocol?
    
    func getRawData(urlString:String){
        let url:NSURL = NSURL(string: urlString)
        let request:NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue() ) { (response:NSURLResponse!, data:NSData!, err:NSError!) -> Void in
            if err == nil {
                let rawData:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.delegate?.http2DidReceive(rawData)
                // println ("\(rawData)")
            }
        }
    }
}