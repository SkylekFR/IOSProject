//
//  UIImageView+loadImage.swift
//  IOSProject
//
//  Created by Emilien Champion on 03/03/2021.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, completion: (() -> Void)? = nil) {
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            guard error == nil,
                  let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                return
            }

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion?()
            }
        }

        task.resume()
    }
}
