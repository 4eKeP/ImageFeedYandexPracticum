//
//  Photo.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 28.10.2023.
//

import Foundation


struct Photo {
    
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: URL
        let largeImageURL: URL
        let isLiked: Bool
    
}
