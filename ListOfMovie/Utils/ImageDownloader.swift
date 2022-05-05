//
//  ImageDownloader.swift
//  ListOfMovie
//
//  Created by Rizky Mashudi on 05/05/22.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
  private let _movie: Movie
  
  init(movie: Movie) {
    _movie = movie
  }
  
  override func main() {
    if isCancelled { return }
    
    guard let imageData = try? Data(contentsOf: _movie.poster) else { return }
    
    if isCancelled { return }
    
    if !imageData.isEmpty {
      _movie.image = UIImage(data: imageData)
      _movie.state = .downloaded
    }else{
      _movie.image = nil
      _movie.state = .failed
    }
  }
}
