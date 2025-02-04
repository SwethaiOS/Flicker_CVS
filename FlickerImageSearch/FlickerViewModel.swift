//
//  FlickerViewModel.swift
//  FlickerImageSearch
//
//  Created by Swetha on 2/3/25.
//
import Foundation
import RxSwift
import RxCocoa
import Combine

class FlickrViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = false

    @Published var searchQuery = ""
    @Published var images: [PhotoItem] = []
     
    init() {
        Setup()
    }
    
    private func Setup() {
        $searchQuery
        .removeDuplicates()
        .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
        .sink { [weak self] query in
            self?.fetchPhotos(query)
        }
        .store(in: &cancellables)
    }
    
    private func fetchPhotos(_ query: String) {
            guard !query.isEmpty else { return }
            
            let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
            guard let requestURL = URL(string: url) else {
                return
            }
            self.isLoading = true

            URLSession.shared.dataTask(with: requestURL) { data, response, error in
                if let error = error {
                    print("Error fetching photos: \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(FlickrResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.images = response.items
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding photos: \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}
