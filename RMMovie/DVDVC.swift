import UIKit

class DVDVC: UIViewController , UITableViewDataSource, UITableViewDelegate , http2Protocol, UISearchControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var myTableView: UITableView!
    var movies:Array <Movie> = Array <Movie>()
   // var filterMovies:Array <Movie> = Array <Movie>()
    var eHttp:http2=http2()
    
    //let url_dvd = "http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=63f2chsxdwjse98xxvtuc9c6"
    let url_dvd="http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=63f2chsxdwjse98xxvtuc9c6"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Openings"
        // self.myTableView.registerClass(ListTableViewCell.classForCoder(), forCellReuseIdentifier: "listCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        eHttp.delegate = self
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.myTableView.addSubview(refreshControl)
        eHttp.getRawData(url_dvd)
        myTableView.reloadData()
    }
    func refresh( refreshControl : UIRefreshControl)
    {
        refreshControl.beginRefreshing()
        eHttp.getRawData(url_dvd)
        myTableView.reloadData()
        refreshControl.endRefreshing()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return movies.count
     
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.myTableView.dequeueReusableCellWithIdentifier("dvdCell" ) as DVDTableViewCell
       
            cell.labelSynopsis.text = movies[indexPath.row].synopsis
            cell.labelTitle.text = movies [indexPath.row].title
            cell.imgPosterThumbnail.setImageWithURL(movies[indexPath.row].thumbnailURL)
      
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDetail") {
            if segue.destinationViewController.isKindOfClass(DVDDetailViewController) {
                let DVC:DVDDetailViewController = segue.destinationViewController as DVDDetailViewController
                let tableIndex = self.myTableView.indexPathForCell(sender as UITableViewCell)?.row
                let chosenMovie = movies[tableIndex!]
                DVC.movie = chosenMovie
            }
        }
    }
    func http2DidReceive(JSONData: NSDictionary) {
        let allData = JSONData["movies"] as [NSDictionary]
        for eachItem in  allData {
                 println("\(eachItem)")
                let title = eachItem["title"] as String
                let synopsis = eachItem["synopsis"] as String
                let posters = eachItem ["posters"] as NSDictionary
                let thumbnail = posters["thumbnail"] as String
                //let movie:Movie = Movie(title: title, synopsis: synopsis, thumbnail: thumbnail)
                let movie:Movie = Movie(title: title, synopsis: synopsis, thumbnail: thumbnail)
                movies.append(movie)
        }
        myTableView.reloadData()
    }

}
