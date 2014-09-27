import UIKit

class DetailViewController: UIViewController {
    var movie:Movie?
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSynopsis: UILabel!
    @IBOutlet weak var ivDisplay: UIView!
    var spinning = MBProgressHUD()


    @IBAction func cancelButtonClick(sender: AnyObject) {
         navigationController?.popViewControllerAnimated(true )
     }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true )
        navigationController?.setNavigationBarHidden(true , animated: false )
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true )
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie?.title
        self.ivDisplay.alpha = 0
        view.addSubview(spinning)
        spinning.show(true )
        self.labelTitle.text = movie?.title
        self.labelSynopsis.text = movie?.synopsis
        //poster download and animation
        let movieDetail:Movie = self.movie!
        let url:NSURL = movieDetail.OriginalURL
        let request1 = NSURLRequest(URL:movieDetail.DetailURL)
        let request2 = NSURLRequest(URL:movieDetail.OriginalURL)
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: NSOperationQueue.mainQueue())
            {(response: NSURLResponse! , data:NSData!, error:NSError!) -> Void in
                if error == nil
                {
                    var image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgPoster.alpha = 0
                        self.imgPoster.image = image
                         UIImageView.animateWithDuration(1, animations: { () -> Void in
                            self.imgPoster.alpha = 0.8
                        })
                    })
                } else {
                    self.title = "NETWROK ERROR !!!!"
                    println("Error: \(error.localizedDescription)")
                }
        }
        NSURLConnection.sendAsynchronousRequest(request2, queue: NSOperationQueue.mainQueue())
            {(response: NSURLResponse! , data:NSData!, error:NSError!) -> Void in
                if error == nil
                {
                    var image = UIImage(data: data)
                   // var images :[UIImage] = [image]
                    dispatch_async(dispatch_get_main_queue(), {
                        self.ivDisplay.alpha = 0
                        self.imgPoster.image = image
                        self.spinning.hidden = true
                        UIImageView.animateWithDuration(0.5, animations: { () -> Void in
                            self.imgPoster.alpha = 1
                            self.ivDisplay.alpha = 0.7
                            self.labelTitle.text = self.movie?.title
                            self.labelSynopsis.text = self.movie?.synopsis
                        })
                    })
                } else {
                    self.title = "NETWROK ERROR !!!!"
                    println("Error: \(error.localizedDescription)")
                }
        }
        self.imgPoster.setImageWithURL(url)
    }
}
