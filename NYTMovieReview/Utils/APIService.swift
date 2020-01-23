//
//  APIService.swift
//  NYTMovieReview
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {

    private let apiKey = "nZTgYslq0AqwIY7PMIAXxRoyxlrr6RrQ"
    lazy var endPoint: String = {
        return "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=\(apiKey)"
    }()
    
    func getDataWith(offset: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = "\(endPoint)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your list")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
         guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["results"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
