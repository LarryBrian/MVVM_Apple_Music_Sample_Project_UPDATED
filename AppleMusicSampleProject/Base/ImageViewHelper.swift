//
//  ImageViewHelper.swift
//  AppleMusicSampleProject
//
//  Created by Brian King on 5/16/21.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    @MainActor func loadImage(from urlString: String) async throws {
        if let _image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = _image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
             
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let _image = UIImage(data: data) {
                    imageCache.setObject(_image, forKey: urlString as NSString)
                    self.image = _image
                }
            } catch {
                print(error)
            }
        }
    }
}

