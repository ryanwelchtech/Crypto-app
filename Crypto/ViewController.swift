//
//  ViewController.swift
//  search
//
//  Created by Ryan Welch on 6/23/17.
//  Copyright © 2017 Ryan Welch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
	
	@IBOutlet var tableView: UITableView!
	//MARK:- Outlets
	//MARK:-
	
	//MARK:- Properties
	//MARK:-
	
	var dataArray = [String]()
	var filteredArray = [String]()
	var shouldShowSearchResults = false
	var searchController: UISearchController!
	var searchActive : Bool = false
	var refreshControl: UIRefreshControl = UIRefreshControl()
	
	var TableData:Array< String > = Array < String >()
	
	let queue = OperationQueue()
	

	//MARK:- VDL
	//MARK:-
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		queue.addOperation() {
			// do something in the background
			self.get_data_from_url("https://api.coinmarketcap.com/v1/ticker/")
			
			
			OperationQueue.main.addOperation() {
				// when done, update your UI and/or model on the main queue
				
				if #available(iOS 10.0, *) {
					self.tableView.refreshControl = self.refreshControl
				} else
				{
					self.tableView.addSubview(self.refreshControl)
				}
			}
		}
		
		self.refreshControl.addTarget(self, action: #selector(ViewController.didRefresh), for: UIControlEvents.valueChanged)

		configureSearchController() // Config Controller in VC
	}
	
	//MARK:- VC Methods
	//MARK:-
	
	func didRefresh() {
		self.get_data_from_url("https://api.coinmarketcap.com/v1/ticker/")
		self.tableView.reloadData()
		self.refreshControl.endRefreshing()
	}
	
	func get_data_from_url(_ link:String)
	{
		let url:URL = URL(string: link)!
		let session = URLSession.shared
		
		let request = NSMutableURLRequest(url: url)
		request.httpMethod = "GET"
		request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		
		
		let task = session.dataTask(with: request as URLRequest, completionHandler: {
			(
			data, response, error) in
			
			guard let _:Data = data, let _:URLResponse = response  , error == nil else {
				
				return
			}
			
			self.extract_json(data!)
			
		})
		
		task.resume()
		
	}
	
	func extract_json(_ data: Data)
	{
		
		let json: Any?
		
		do
		{
			json = try JSONSerialization.jsonObject(with: data, options: [])
		}
		catch
		{
			return
		}
		
		guard let data_list = json as? NSArray else
		{
			return
		}
		
		
		if let coins_list = json as? NSArray
		{
			for i in 0 ..< data_list.count
			{
				if let coin_obj = coins_list[i] as? NSDictionary
				{
					if let coin_name = coin_obj["name"] as? String
					{
						if let coin_symbol = coin_obj["symbol"] as? String
						{
							if let coinRank = coin_obj["rank"]  as? String
							{
								if let coinUSD = coin_obj["price_usd"] as? String
								{
									dataArray.append(coinRank + ". [" + coin_symbol + "] " + coin_name + " Price: $" + coinUSD)
								}
								
							}
							
						}
						
					}
				}
			}
			tableView.reloadData()
		}
		
		DispatchQueue.main.async(execute: {self.do_table_refresh()})
	}

	func do_table_refresh()
	{
		self.tableView.reloadData()
//		self.refreshControl.endRefreshing()
	}
	
	func configureSearchController() {
		searchController = UISearchController(searchResultsController: nil)
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search here..."
		searchController.searchBar.delegate = self as? UISearchBarDelegate
		searchController.searchResultsUpdater = self
		searchController.searchBar.sizeToFit()
		
		self.tableView.tableHeaderView = searchController.searchBar
	}
	
	//MARK:- table datasource
	//MARK:-
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		if(searchActive) {
			return filteredArray.count
		}
		return dataArray.count;
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
		
		if(searchActive){
			cell.textLabel?.text = filteredArray[indexPath.row]
		} else {
			cell.textLabel?.text = dataArray[indexPath.row];
		}
		
		return cell;
	}
	
	//MARK:- search update delegate
	//MARK:-
	
	public func updateSearchResults(for searchController: UISearchController){
		let searchString = searchController.searchBar.text
		
		
		filteredArray = dataArray.filter({ (Coin) -> Bool in
			let nameText: NSString = Coin as NSString
			return (nameText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
		})
		if(filteredArray.count == 0){
			searchActive = false;
		} else {
			searchActive = true;
		}
		self.tableView.reloadData()
		tableView.reloadData()
	}
	
	//MARK:- search bar delegate
	//MARK:-
	
	public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		shouldShowSearchResults = true
		tableView.reloadData()
	}
	
	
	public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		shouldShowSearchResults = false
		tableView.reloadData()
	}
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let indexPath = tableView.indexPathForSelectedRow
		
		//getting the current cell from the index path
		let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
		let currentItem = dataArray[(indexPath?.row)!]
		
		let alertController = UIAlertController(title: "Simplified iOS", message: "You Selected " + currentItem , preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
		alertController.addAction(defaultAction)
		
		present(alertController, animated: true, completion: nil)	}
	
}
