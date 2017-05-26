//
//  MovieTableViewController.swift
//  MovieDBTableView
//
//  Created by Phi Trinh on 5/24/17.
//  Copyright © 2017 Phi Trinh. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies(completionHandler: { (movieList, error) in
            if(error != nil) {
                print(error!)
            } else {
                self.movies = movieList!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        NSLog("\(movies.count)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie cell", for: indexPath)
        

        cell.textLabel?.text = movies[indexPath.row].title
        cell.detailTextLabel?.text = movies[indexPath.row].overview
        let queue = OperationQueue()
        queue.addOperation { () -> Void in
                if let img = Downloader.downloadImageWithURL("https://image.tmdb.org/t/p/w320\(self.movies[indexPath.row].posterPath!)") {
                    OperationQueue.main.addOperation({
                        cell.imageView?.image = img
                    })
                }
        }
        

        return cell
    }
    
    func getMovies(completionHandler: @escaping (_ movieList: [Movie]?, _ error: Error?) -> Void){
        var json = [String:Any]()
        var movieDictionary = [Any]()
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api)&language=en-US&page=1")
        let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, urlResponse, error) in
            if (error != nil) {
                completionHandler(nil, error)
            } else {
                
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    movieDictionary = json["results"] as! [Any]
                    var movieL: [Movie] = []
                    for movie in movieDictionary {
                        movieL.append(Movie(json: movie as! [String:Any]))
                    }
                    completionHandler(movieL, nil)
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "detail":
                let detailVC = segue.destination as! DetailViewController
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    detailVC.movieId = idAtIndexPath(indexPath: indexPath as NSIndexPath)
                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func idAtIndexPath(indexPath: NSIndexPath) -> Int
    {
            return movies[indexPath.row].id!
    }

}

class Downloader {
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

