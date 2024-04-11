//
//  AlbumsViewModel.swift
//  AppleMusicSampleProject
//
//  Created by Brian King on 5/16/21.
//

import Foundation

class AlbumsViewModel {
    
    // MARK: - VARIABLES
    var topAlbumsURL = Constants().appleMusicTopAlbumsURL
    var albums = [Album]()
    var selectedAlbum: Album?
    var isFetchedAlbumsSuccessful = false
    
    
    // MARK: - FUNCTIONS
    func fetchTopAlbumsData() async throws {
        guard let _url = URL(string: topAlbumsURL) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: _url)
            let decodedResults = try JSONDecoder().decode(AppleMusicResponse.self, from: data)
            albums = decodedResults.feed?.results ?? []
            var isFetchedAlbumsSuccessful = true
        } catch {
            var isFetchedAlbumsSuccessful = false
            print(error)
        }
    }
}
