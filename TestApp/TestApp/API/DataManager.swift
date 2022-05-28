//
//  DataManager.swift
//  TestApp
//
//  Created by jehernandezg on 15/05/22.
//

import Foundation

enum showType: String {
    case popular = "movie/popular"
    case topRated = "movie/top_rated"
    case onTv = "tv/on_the_air"
    case airingToday = "tv/airing_today"
    
}

enum detailType: String {
    case movieDetail = "movie/"
    case TVDetail = "tv/"
}

protocol DataManagerProtocol {
    func getShowsListURL(section: showType) -> String
    func getShowsDetailURL(detail: detailType, showId: Int) -> String
    func fetchData<T: Decodable>(model: T.Type, urlPath: String, onFinished: @escaping (Result<T, Error>) -> Void)
    var urlDomain: String {get set}
    var apiKey: String {get set}
    var page: String {get set}
}

extension DataManagerProtocol {
    func getShowsListURL(section: showType) -> String {
        return "\(urlDomain)\(section.rawValue)\(apiKey)\(page)"
    }

    func getShowsDetailURL(detail: detailType, showId: Int) -> String {
        return "\(urlDomain)\(detail.rawValue)\(showId)\(apiKey)"
    }

    func fetchData<T: Decodable>(model: T.Type, urlPath: String, onFinished: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlPath) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(model, from: data) {
                    DispatchQueue.main.async {
                        print(decodedResponse)
                        onFinished(.success(decodedResponse))
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            onFinished(.failure(error ?? NSError(domain: "ABC", code: 500)))
        }
        .resume()
    }
}

struct DataManagerConstans {
    static var urlDomain = "https://api.themoviedb.org/3/"
    static var apiKey = "?api_key=61eadb867e993e137afed1b165511c52&language=en-US"
    static var page = "&page=1"
}
