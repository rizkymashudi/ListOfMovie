//
//  ViewController.swift
//  ListOfMovie
//
//  Created by Rizky Mashudi on 05/05/22.
//

import UIKit

class ViewController: UIViewController {

  //TableView Component
  lazy var tableView: UITableView = {
    let view = UITableView()
    view.delegate = self
    view.dataSource = self
    view.rowHeight = 150
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(UITableViewCell.self, forCellReuseIdentifier: "movie-cell")
    return view
  }()
  
  //Instance pendingOperations
  private let _pendingOperations = PendingOperations()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
  }
  
  //setup view
  func setupView() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  //start operation
  fileprivate func startOperations(movie: Movie, index: IndexPath){
    if movie.state == .new {
      startDownload(movie: movie, indexPath: index)
    }
  }
  
  //startDownload
  fileprivate func startDownload(movie: Movie, indexPath: IndexPath){
    guard _pendingOperations.downloadInProgress[indexPath] == nil else { return }
    
    //instance ImageDownloader
    let downloader = ImageDownloader(movie: movie)
    
    //call if download is complete
    downloader.completionBlock = {
      if downloader.isCancelled { return }
      
      //update value downloadInProgress in main thread
      DispatchQueue.main.async {
        self._pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
        self.tableView.reloadRows(at: [indexPath], with: .automatic) //reload data
      }
    }
    
    //tell operation if download process running
    _pendingOperations.downloadInProgress[indexPath] = downloader
    _pendingOperations.downloadQueue.addOperation(downloader)
  }
  
  //pending and activate download process
  fileprivate func toggleSuspendOperations(isSuspended: Bool) {
    _pendingOperations.downloadQueue.isSuspended = isSuspended
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "movie-cell", for: indexPath)
    let movie = movies[indexPath.row]
    
    cell.textLabel?.numberOfLines = 2
    cell.textLabel?.text = movie.title
    cell.imageView?.image = movie.image
    
    if cell.accessoryView == nil {
      cell.accessoryView = UIActivityIndicatorView(style: .medium)
    }
    
    //Check if image doesnt downloaded yet and user not scrolling, show loading animation else the opposite
    guard let indicator = cell.accessoryView as? UIActivityIndicatorView else { fatalError() }
    
    if movie.state == .new {
      indicator.startAnimating()
      
      if !tableView.isDragging && !tableView.isDecelerating {
        startOperations(movie: movie, index: indexPath)
      }
    } else {
      indicator.stopAnimating()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //pause download process when user scroll tableview
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    toggleSuspendOperations(isSuspended: true)
  }
  
  //resume download process when user finish scrolling
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    toggleSuspendOperations(isSuspended: false)
  }
}

