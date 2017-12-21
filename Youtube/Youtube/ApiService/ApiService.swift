////
////  ApiService.swift
////  Youtube
////
////  Created by Nuno Pereira on 03/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class ApiService: NSObject {
    static let sharedInstance = ApiService();

    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"

    func fetchVideos(completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json") { (videos) in
//            completion(videos)
//        }

        //Isto e a mesma coisa que o de cima
        fetchFeedForUrlString(urlString: "\(baseUrl)/home_num_likes.json", completion: completion)
    }

    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json") { (videos) in
//            completion(videos)
//        }

        //Isto e a mesma coisa que o de cima
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }

    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {

//        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json") { (videos) in
//            completion(videos)
//        }

        //Isto e a mesma coisa que o de cima
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)

    }

    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching...", error)
                return
            }

            do {

                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String:AnyObject]] {

//                var videos = [Video]()
//
//                for dictionary in jsonDictionaries {
//                    let video = Video()
//                    video.setValuesForKeys(dictionary)
//
//                    video.title = dictionary["title"] as? String
//                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//                    video.numberOfViews = dictionary["number_of_views"] as? NSNumber
//
//                    let dictionaryChannel = dictionary["channel"] as! [String:Any]
//                    let channel = Channel()
//                    channel.name = dictionaryChannel["name"] as? String
//                    channel.profileImageName = dictionaryChannel["profile_image_name"] as? String
//
//                    video.channel = channel
//                    videos.append(video)
//
//
//                }
//                    let videos = jsonDictionaries.map({return Video(dictionary: $0)})
                    DispatchQueue.main.async {
                        completion(jsonDictionaries.map({return Video(dictionary: $0)}))
                    }
                }
            }
            catch let errJson {
                print(errJson)
            }
            }.resume()
    }

}
