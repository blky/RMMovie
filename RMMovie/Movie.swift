import Foundation

class Movie  {
    
    let title:String
    let synopsis:String
    let thumbnail:String
    
    init (title:String, synopsis:String,thumbnail:String){
        self.title = title
        self.synopsis = synopsis
        self.thumbnail = thumbnail
    }
    
    var thumbnailURL:NSURL {
        get {
            return NSURL(string: thumbnail)
        }
    }
    var OriginalURL:NSURL {
        get{
            return NSURL (string: thumbnail.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori"))
        }
    }
    var DetailURL:NSURL {
        get{
            return NSURL (string: thumbnail.stringByReplacingOccurrencesOfString("_tmb", withString: "_det"))
        }
    }

    
}