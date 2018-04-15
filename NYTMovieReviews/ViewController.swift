//
//  ViewController.swift
//  NYTMovieReviews
//
//  Created by Vic Sukiasyan on 4/12/18.
//  Copyright © 2018 Vic Sukiasyan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var movies = [Movie]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //searchBar.showsCancelButton = true
        
    }
    
    // MARK: Search Bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        parseJSON(searchBar.text!)
        //self.definesPresentationContext = true
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            movies.removeAll()
            tableView.reloadData()
        }
    }
    
    func parseJSON(_ searchTerm: String) {
        let urlString = "http://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=789d42aacbc440d4add570e12f635526&query=\(searchTerm)"
        let url = URL(string: urlString)
    
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error ) in
            guard error == nil else {
                print("No error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: content, options: []) as? [String:Any]
            let results = json!!["results"] as? [Any]
            //print(results!)
            
            for i in results! {
                let i = i as? [String: Any]
                let link = i!["link"] as? [String: Any]
                
                var movie = Movie()
                movie.title = i!["display_title"] as? String
                movie.headline = i!["headline"] as? String
                movie.link = link!["url"] as? String
                self.movies.append(movie)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
         
            }
        }
        task.resume()
        
    }
    
    // MARK: TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row].title
        cell.detailTextLabel?.text = movies[indexPath.row].headline
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            detailViewController.movieTitle = movies[tableView.indexPathForSelectedRow!.row].title
            detailViewController.link = movies[tableView.indexPathForSelectedRow!.row].link
            
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

