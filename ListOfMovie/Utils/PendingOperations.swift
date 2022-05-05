//
//  PendingOperations.swift
//  ListOfMovie
//
//  Created by Rizky Mashudi on 05/05/22.
//

import Foundation

class PendingOperations {
  lazy var downloadInProgress: [IndexPath: Operation] = [:]
  
  //create maximum of queue is 2
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "com.dicoding.imageDownload"
    queue.maxConcurrentOperationCount = 2
    
    return queue
  }()
}
