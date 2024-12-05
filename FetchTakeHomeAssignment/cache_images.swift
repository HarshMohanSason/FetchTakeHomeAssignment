//
//  cache_images.swift
//  FetchTakeHomeAssignment
//
//  Created by Harsh Mohan Sason on 12/4/24.
//

import Foundation
import UIKit


//Managing caching of the images
class CacheImages{
    
    private let fileManager = FileManager.default //instance for FileManager to manage file system
    private let cacheDirectory: URL //instance to store temp files in the directory
    
    //Initializing paths
    init() {
        // Defining cache directory path
        let cachesPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0] //path to the cache directory
        cacheDirectory = cachesPath.appendingPathComponent("ImageCache") //Appending ImageCache to the directory path
        
        // Creating the directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) { //Check If the ImageCache directory does not exist
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true) //create the directory
        }
    }
    
    // Function to get image file path in the cache
       func filePath(forKey key: String) -> URL {
          return cacheDirectory.appendingPathComponent(key)
      }
    
    // Function to save image to disk
    func saveImageToCache(from urlString: String, forKey key: String) {
        guard let url = URL(string: urlString) else { return }  // Converting the string to a URL
        
        do {

            let data = try Data(contentsOf: url) // Fetch image data from the URL
            
            // Convert data to UIImage
            guard let image = UIImage(data: data) else { return }
            
            // Convert UIImage to PNG data
            guard let imageData = image.pngData() else { return }
            
            // Get the file path and save the image data
            let filePath = self.filePath(forKey: key)
            try imageData.write(to: filePath)  // Save the image data to disk
        } catch {
            print("Error saving image to cache: \(error)")
        }
    }
    
    // Function to load image from cache. Using the object uuid from the JSON data as a key
    func loadImageFromCache(forKey key: String) -> UIImage? {
        let filePath = self.filePath(forKey: key)
        
        // Check if the image exists in the cache directory
        if let imageData = try? Data(contentsOf: filePath), let image = UIImage(data: imageData) {
            return image
        }
        
        return nil  // Returning nil if the image doesn't exist in cache
    }
    
    
}
