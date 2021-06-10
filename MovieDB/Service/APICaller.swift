//
//  APICaller.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.themoviedb.org/3/movie/"
        static let apiKey = "dea6d5ed2822c14b8343dc1e5babc6c4"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    //MARK: - Get List of Games
    public func getListOfFeed(with urlPath: serviceUrlPath, completion: @escaping(Result<MovieResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"\(urlPath.rawValue)"+"?api_key="+Constants.apiKey+"&language=en-US"), type: .GET) {
            baseRequest in
            print(baseRequest)
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
    
                do{
                    let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Private
    enum HTTPMethod: String{
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    enum serviceUrlPath: String {
        case top_rated
        case now_playing
        case upcoming
        case popular
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
   
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
