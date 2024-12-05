//
//  fetch_data_from_url.swift
//  FetchTakeHomeAssignment
//
//  Created by Harsh Mohan Sason on 12/4/24.
//

import Foundation

//---------ENUM TO REPRESENT DIFFERENT STATES WHEN FETCHING THE DATA FROM THE URL----------
enum FetchState{
    case success(String)
    case loading
    case failure(String)
}

//Struct to represent root array of recipes
struct Recipes : Decodable{
    let recipes : [RecipeItem]
}

//----------STRUCT TO REPRESENT THE RECIPE ITEMS----------
struct RecipeItem: Decodable{
    
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var uuid: String
    var source_url: String?
    var youtube_url: String?
    
}

/*
 THIS CLASS WILL OBSERVE 2 STATES:
 1. When fetching the data from the url to throw any errors or success
 2. Return a list of recipeitems to be used in the View controller
 */
class FetchDataFromTheUrl: ObservableObject {
    @Published var state: FetchState = .loading
    @Published var recipeItems: [RecipeItem] = [] // Will hold the fetched recipe items
    private let cacheImages = CacheImages()
    //Function to fetch the data from the given URL
    func fetchData() async {
       
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
       
        do {
            // Fetch the data from the URL. No need to get response here since error state is handled by the enum
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON into the Recipe struct
            let decodedData = try JSONDecoder().decode(Recipes.self, from: data)
            
            //Cache the images
            for recipe in decodedData.recipes{
                if let imageUrl = recipe.photo_url_large {
                    cacheImages.saveImageToCache(from: imageUrl, forKey: recipe.uuid)
                            }
                else{
                    break;
                }
            }
            
            // Update the state and recipeItems
            DispatchQueue.main.async {
                self.recipeItems = decodedData.recipes
                self.state = .success("Data fetched successfully")
            }
        } catch {
            //Throw an error if any failure occures.
            DispatchQueue.main.async {
                self.state = .failure("An error occurred: \(error.localizedDescription)")
            }
        }
    }
}

