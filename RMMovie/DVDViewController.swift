import UIKit

class DVDViewController: UIViewController , UITableViewDataSource, UITableViewDelegate ,HttpProtocol, UISearchControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var movies:Array <Movie> = Array <Movie>()
    var filterMovies:Array <Movie> = Array <Movie>()
    var eHttp:HttpURL=HttpURL()
    
    let url_dvd = "http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=63f2chsxdwjse98xxvtuc9c6"
    let url_boxoffice = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=63f2chsxdwjse98xxvtuc9c6&limit=20&country=us"
    let url_opening = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?limit=16&country=us&apikey=63f2chsxdwjse98xxvtuc9c6"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DVD"
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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filterMovies.count
        }else {
            return movies.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("dvdCell" ) as ListTableViewCell
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.labelSynopsis.text = filterMovies[indexPath.row].synopsis
            cell.labelTitle.text = filterMovies [indexPath.row].title
            cell.imgPosterThumbnail.setImageWithURL(filterMovies[indexPath.row].thumbnailURL)
          } else {
            cell.labelSynopsis.text = movies[indexPath.row].synopsis
            cell.labelTitle.text = movies [indexPath.row].title
            cell.imgPosterThumbnail.setImageWithURL(movies[indexPath.row].thumbnailURL)
         }
        return cell
     }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDetail") {
            if segue.destinationViewController.isKindOfClass(DetailViewController) {
                let DVC:DetailViewController = segue.destinationViewController as DetailViewController
                let tableIndex = self.myTableView.indexPathForCell(sender as UITableViewCell)?.row
                let chosenMovie = movies[tableIndex!]
                DVC.movie = chosenMovie
            }
        }
    }
    func didReceivedData(JSONData: NSDictionary) {
        let allData = JSONData["movies"] as [NSDictionary]
        for eachItem in  allData {
            //println("\(eachItem)")
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
    // mark - search
    
    /*
    func filterContentForSearchText(searchText:String,scope:String) {
        //convert to nsarray for searching
        /*
        movies.filter { (T) -> Bool in
           
        } */
        
        let  filterMovies = movies.filter { $0  }
        println("=======search text is \(searchText)")
        var resultPredicate = NSPredicate(format: "name contains[cd] %@", searchText)
        let NS_movies:NSArray = NSArray(array: movies)
        println("=====\(NS_movies)")
        let NS_filteredMovied:NSArray = NS_movies.filteredArrayUsingPredicate(resultPredicate) as NSArray
        for ea in NS_filteredMovied {
            filterMovies.append(ea as Movie)
        }
        println("\n[ ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")
        

    } */
 
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filterMovies = self.movies.filter({( movie: Movie) -> Bool in
            let movieMatch = ( scope == "All") || (movie.title == scope)
            let stringMatch = movie.title.rangeOfString(searchText)
            return movieMatch && (stringMatch != nil)
        })
    }
 
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
 }
