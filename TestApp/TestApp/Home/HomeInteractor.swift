//
//  HomeInteractor.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation

protocol HomeInteractorProtocol {
    func fetchMovieList(section: showType, onSuccess: @escaping () -> Void, onError: @escaping (_ message: String) -> Void)
    var dataSource: [Results]? { get }
    func saveFavorite(index: Int, onSaved: @escaping () -> Void)
    func getFavorites() -> [Results]?
}

final class HomeInteractor: DataManagerProtocol {
    var urlDomain = DataManagerConstans.urlDomain
    var apiKey = DataManagerConstans.apiKey
    var page = DataManagerConstans.page
    var data: [Results]?
}

extension HomeInteractor: HomeInteractorProtocol {
    func getFavorites() -> [Results]? {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Results].self, from: data) {
                debugPrint(decoded)
                return decoded
            }
        }
        return nil
    }
    
    func saveFavorite(index: Int, onSaved: @escaping () -> Void) {
        guard let favorite = dataSource?[index] else { return }
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let List = try? JSONDecoder().decode([Results].self, from: data) {
                debugPrint(List)
                var updatedList = [Results]()
                List.forEach { show in
                    updatedList.append(show)
                }
                if !updatedList.contains(where: {$0.id == favorite.id }) {
                    updatedList.append(favorite)
                }
                debugPrint(updatedList)
                if let encoded = try? JSONEncoder().encode(updatedList) {
                    UserDefaults.standard.set(encoded, forKey: "SavedData")
                    
                    if let data = UserDefaults.standard.data(forKey: "SavedData") {
                        if let decoded = try? JSONDecoder().decode([Results].self, from: data) {
                            debugPrint(decoded)
                        }
                    }
                    onSaved()
                    return
                }
            }
        } else {
            var updatedList = [Results]()
            updatedList.append(favorite)
            debugPrint(updatedList)
            if let encoded = try? JSONEncoder().encode(updatedList) {
                UserDefaults.standard.set(encoded, forKey: "SavedData")
                
                if let data = UserDefaults.standard.data(forKey: "SavedData") {
                    if let decoded = try? JSONDecoder().decode([Results].self, from: data) {
                        debugPrint(decoded)
                    }
                }
                onSaved()
                return
            }
        }
    }
    
    var dataSource: [Results]? {
        data
    }
    
    func fetchMovieList(section: showType, onSuccess: @escaping () -> Void, onError: @escaping (_ message: String) -> Void) {
        let url = getShowsListURL(section: section)
        fetchData(model: MovieResponse.self, urlPath: url) { result in
            switch result {
            case .failure(let fail):
                onError(fail.localizedDescription)
            case .success(let response):
                self.data = response.results
                guard let favorites = self.getFavorites(), let origin = self.data else {
                    onSuccess()
                    return
                }
                for i in 0..<origin.count {
                    for j in 0..<favorites.count {
                        if origin[i].id == favorites[j].id {
                            self.data![i].isFavorite = true
                        }
                    }
                }
                onSuccess()
                break
            }
        }
    }
}

struct MovieResponse : Codable {
    let page : Int?
    let results : [Results]?
    let total_pages : Int?
    let total_results : Int?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case total_pages = "total_pages"
        case total_results = "total_results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
    }
}

struct Results : Codable {
    let adult : Bool?
    let backdrop_path : String?
    let genre_ids : [Int]?
    let id : Int?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let release_date : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
    let name: String?
    let first_air_date: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case genre_ids = "genre_ids"
        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case poster_path = "poster_path"
        case release_date = "release_date"
        case title = "title"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
        case name
        case first_air_date = "first_air_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
        genre_ids = try values.decodeIfPresent([Int].self, forKey: .genre_ids)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
        original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        first_air_date = try values.decodeIfPresent(String.self, forKey: .first_air_date)
    }
}

//Details
struct ShowDetail : Codable {
    let adult : Bool?
    let backdrop_path : String?
    let belongs_to_collection : Belongs_to_collection?
    let budget : Int?
    let created_by : [CreatedBy]?
    let episode_run_time : [Int]?
    let first_air_date : String?
    let genres : [Genres]?
    let homepage : String?
    let id : Int?
    let imdb_id : String?
    let in_production : Bool?
    let languages : [String]?
    let last_air_date : String?
    let last_episode_to_air : Last_episode_to_air?
    let name : String?
    let next_episode_to_air : Next_episode_to_air?
    let networks : [Networks]?
    let number_of_episodes : Int?
    let number_of_seasons : Int?
    let origin_country : [String]?
    let original_language : String?
    let original_title : String?
    let original_name : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let production_companies : [Production_companies]?
    let production_countries : [Production_countries]?
    let release_date : String?
    let revenue : Int?
    let runtime : Int?
    let seasons : [Seasons]?
    let spoken_languages : [Spoken_languages]?
    let status : String?
    let tagline : String?
    let title : String?
    let video : Bool?
    let type : String?
    let vote_average : Double?
    let vote_count : Int?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case belongs_to_collection = "belongs_to_collection"
        case budget = "budget"
        case created_by = "created_by"
        case episode_run_time = "episode_run_time"
        case first_air_date = "first_air_date"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case imdb_id = "imdb_id"
        case in_production = "in_production"
        case languages = "languages"
        case last_air_date = "last_air_date"
        case last_episode_to_air = "last_episode_to_air"
        case name = "name"
        case next_episode_to_air = "next_episode_to_air"
        case networks = "networks"
        case number_of_episodes = "number_of_episodes"
        case number_of_seasons = "number_of_seasons"
        case origin_country = "origin_country"
        case original_language = "original_language"
        case original_title = "original_title"
        case original_name = "original_name"
        case overview = "overview"
        case popularity = "popularity"
        case poster_path = "poster_path"
        case production_companies = "production_companies"
        case production_countries = "production_countries"
        case release_date = "release_date"
        case revenue = "revenue"
        case runtime = "runtime"
        case seasons = "seasons"
        case spoken_languages = "spoken_languages"
        case status = "status"
        case tagline = "tagline"
        case title = "title"
        case video = "video"
        case type = "type"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
        belongs_to_collection = try values.decodeIfPresent(Belongs_to_collection.self, forKey: .belongs_to_collection)
        budget = try values.decodeIfPresent(Int.self, forKey: .budget)
        created_by = try values.decodeIfPresent([CreatedBy].self, forKey: .created_by)
        episode_run_time = try values.decodeIfPresent([Int].self, forKey: .episode_run_time)
        first_air_date = try values.decodeIfPresent(String.self, forKey: .first_air_date)
        genres = try values.decodeIfPresent([Genres].self, forKey: .genres)
        homepage = try values.decodeIfPresent(String.self, forKey: .homepage)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        imdb_id = try values.decodeIfPresent(String.self, forKey: .imdb_id)
        in_production = try values.decodeIfPresent(Bool.self, forKey: .in_production)
        languages = try values.decodeIfPresent([String].self, forKey: .languages)
        last_air_date = try values.decodeIfPresent(String.self, forKey: .last_air_date)
        last_episode_to_air = try values.decodeIfPresent(Last_episode_to_air.self, forKey: .last_episode_to_air)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        next_episode_to_air = try values.decodeIfPresent(Next_episode_to_air.self, forKey: .next_episode_to_air)
        networks = try values.decodeIfPresent([Networks].self, forKey: .networks)
        number_of_episodes = try values.decodeIfPresent(Int.self, forKey: .number_of_episodes)
        number_of_seasons = try values.decodeIfPresent(Int.self, forKey: .number_of_seasons)
        origin_country = try values.decodeIfPresent([String].self, forKey: .origin_country)
        original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
        original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        original_name = try values.decodeIfPresent(String.self, forKey: .original_name)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        production_companies = try values.decodeIfPresent([Production_companies].self, forKey: .production_companies)
        production_countries = try values.decodeIfPresent([Production_countries].self, forKey: .production_countries)
        release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        revenue = try values.decodeIfPresent(Int.self, forKey: .revenue)
        runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
        seasons = try values.decodeIfPresent([Seasons].self, forKey: .seasons)
        spoken_languages = try values.decodeIfPresent([Spoken_languages].self, forKey: .spoken_languages)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
    }
}

struct Genres : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Belongs_to_collection : Codable {
    let id : Int?
    let name : String?
    let poster_path : String?
    let backdrop_path : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case poster_path = "poster_path"
        case backdrop_path = "backdrop_path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
    }
}

struct Production_companies : Codable {
    let id : Int?
    let logo_path : String?
    let name : String?
    let origin_country : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case logo_path = "logo_path"
        case name = "name"
        case origin_country = "origin_country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        logo_path = try values.decodeIfPresent(String.self, forKey: .logo_path)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        origin_country = try values.decodeIfPresent(String.self, forKey: .origin_country)
    }
}

struct Production_countries : Codable {
    let iso_3166_1 : String?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case iso_3166_1 = "iso_3166_1"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iso_3166_1 = try values.decodeIfPresent(String.self, forKey: .iso_3166_1)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Spoken_languages : Codable {
    let english_name : String?
    let iso_639_1 : String?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case english_name = "english_name"
        case iso_639_1 = "iso_639_1"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        english_name = try values.decodeIfPresent(String.self, forKey: .english_name)
        iso_639_1 = try values.decodeIfPresent(String.self, forKey: .iso_639_1)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Seasons : Codable {
    let air_date : String?
    let episode_count : Int?
    let id : Int?
    let name : String?
    let overview : String?
    let poster_path : String?
    let season_number : Int?

    enum CodingKeys: String, CodingKey {
        case air_date = "air_date"
        case episode_count = "episode_count"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case poster_path = "poster_path"
        case season_number = "season_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        air_date = try values.decodeIfPresent(String.self, forKey: .air_date)
        episode_count = try values.decodeIfPresent(Int.self, forKey: .episode_count)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        season_number = try values.decodeIfPresent(Int.self, forKey: .season_number)
    }
}

struct Last_episode_to_air : Codable {
    let air_date : String?
    let episode_number : Int?
    let id : Int?
    let name : String?
    let overview : String?
    let production_code : String?
    let runtime : Int?
    let season_number : Int?
    let still_path : String?
    let vote_average : Double?
    let vote_count : Int?

    enum CodingKeys: String, CodingKey {
        case air_date = "air_date"
        case episode_number = "episode_number"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case production_code = "production_code"
        case runtime = "runtime"
        case season_number = "season_number"
        case still_path = "still_path"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        air_date = try values.decodeIfPresent(String.self, forKey: .air_date)
        episode_number = try values.decodeIfPresent(Int.self, forKey: .episode_number)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        production_code = try values.decodeIfPresent(String.self, forKey: .production_code)
        runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
        season_number = try values.decodeIfPresent(Int.self, forKey: .season_number)
        still_path = try values.decodeIfPresent(String.self, forKey: .still_path)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
    }
}

struct Networks : Codable {
    let name : String?
    let id : Int?
    let logo_path : String?
    let origin_country : String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case logo_path = "logo_path"
        case origin_country = "origin_country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        logo_path = try values.decodeIfPresent(String.self, forKey: .logo_path)
        origin_country = try values.decodeIfPresent(String.self, forKey: .origin_country)
    }
}

struct Next_episode_to_air : Codable {
    let air_date : String?
    let episode_number : Int?
    let id : Int?
    let name : String?
    let overview : String?
    let production_code : String?
    let runtime : Int?
    let season_number : Int?
    let still_path : String?
    let vote_average : Double?
    let vote_count : Int?

    enum CodingKeys: String, CodingKey {
        case air_date = "air_date"
        case episode_number = "episode_number"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case production_code = "production_code"
        case runtime = "runtime"
        case season_number = "season_number"
        case still_path = "still_path"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        air_date = try values.decodeIfPresent(String.self, forKey: .air_date)
        episode_number = try values.decodeIfPresent(Int.self, forKey: .episode_number)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        production_code = try values.decodeIfPresent(String.self, forKey: .production_code)
        runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
        season_number = try values.decodeIfPresent(Int.self, forKey: .season_number)
        still_path = try values.decodeIfPresent(String.self, forKey: .still_path)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
    }
}

struct CreatedBy: Codable {
    let id: Int?
    let creditID, name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        creditID = try values.decodeIfPresent(String.self, forKey: .creditID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
    }
}
