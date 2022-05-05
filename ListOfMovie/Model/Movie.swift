//
//  Movie.swift
//  ListOfMovie
//
//  Created by Rizky Mashudi on 05/05/22.
//

import Foundation
import UIKit

class Movie {
  let title: String
  let poster: URL
  
  var image: UIImage?
  var state: DownloadState = .new
  
  init(title: String, poster: URL) {
    self.title = title
    self.poster = poster
  }
}
