import UIKit
protocol HttpProtocol{
    func didReceivedData(JSONData:NSDictionary)
}

class HttpURL: NSObject {
    
    var delegate:HttpProtocol?
    
    func getRawData(urlString:String){
        let url:NSURL = NSURL(string: urlString)
        let request:NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue() ) { (response:NSURLResponse!, data:NSData!, err:NSError!) -> Void in
            if err == nil {
                let rawData:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.delegate?.didReceivedData(rawData)
               // println ("\(rawData)")
            } else {
                let errDictionary:NSDictionary = ["err":err.localizedDescription]
                err.description
                self.delegate?.didReceivedData(errDictionary)
            }
        }
    }
}