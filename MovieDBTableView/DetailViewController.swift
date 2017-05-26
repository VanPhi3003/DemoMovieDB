//
//  DetailViewController.swift
//  MovieDBTableView
//
//  Created by Cntt36 on 5/26/17.
//  Copyright © 2017 Phi Trinh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblImage: UIImageView!
    
    @IBOutlet weak var lblOverview: UILabel!
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDetail()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetDetail(){
        if let id = movieId {
            let queue = OperationQueue()
            var json = [String:Any]()
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(api)&language=en-US")
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, urlResponse, error) in
                if (error != nil) {
                    NSLog(error as! String)
                } else {
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        if let title = json["title"] as? String {
                            NSLog(title)
                            OperationQueue.main.addOperation({
                                self.lblTitle.text = title
                            })
                        }
                        if let posterPath = json["poster_path"] as? String {
                            NSLog(posterPath)
                            queue.addOperation { () -> Void in
                                if let img = Downloader.downloadImageWithURL("https://image.tmdb.org/t/p/w320\(posterPath)") {
                                    OperationQueue.main.addOperation({
                                        self.lblImage.image = img
                                    })
                                }
                            }
                            
                        }
                        if let overview = json["overview"] as? String {
                            NSLog(overview)
                            OperationQueue.main.addOperation({
                                self.lblOverview.text = overview
                            })
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            }).resume()
            
        }
    }
}


