//
//  ContentView.swift
//  FetchTakeHomeAssignment
//
//  Created by Harsh Mohan Sason on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fetchData = FetchDataFromTheUrl()
    
    var body: some View {
        VStack(alignment: .center) {
            switch fetchData.state {
            case .loading:
                Text("Loading")
                    .font(.headline)
                    .lineLimit(1)
                    .padding([.top], 5)
                ProgressView()
            case .failure(let message):
                Text("Error: \(message)").foregroundColor(.red)
            case .success:
                //Display Text if no recipes are available or the list is empty
                if(fetchData.recipeItems.isEmpty)
                {
                    Text("No recipes are available")
                        .foregroundColor(.red)
                }
                else{
                    Text("Recipes").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    List(fetchData.recipeItems, id: \.uuid)
                    { recipe in
                        DisplayMenuItem(recipeItem: recipe) //Pass eacah recipe item to DisplayMenuItem View
                    }.listStyle(PlainListStyle()) // Using a plain list style
                        .background(Color.clear).refreshable {
                            await fetchData.fetchData()
                        }
                }
            }
        } .background(Color.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task{
                await fetchData.fetchData()
            }
    }
}

struct DisplayMenuItem: View {
    var recipeItem: RecipeItem  // Pass the RecipeItem to this view
    @State private var showError = false  // To track if an error should be shown for the image being displayed
    private let fetchCacheImage = CacheImages()
    var body: some View {
        VStack{
            // Display the photo from the cache if it is not empty
            if let image =  fetchCacheImage.loadImageFromCache(forKey: recipeItem.uuid){
                Image(uiImage: image) // Convert UIImage to SwiftUI Image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
            }
            //if no image is fetched from cache, then fetch from the url
            else if let photoUrl = recipeItem.photo_url_large, let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150)
                } placeholder: {
                    if showError {
                        Text("Failed to load image")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 150)
                            .onAppear {
                                // Starting a timer when placeholder appears to show the text error to the user if image is failed to load
                                Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                                    showError = true
                                }
                            }
                    }
                }
            }
            //Display a gray frame if no image is fetched from the url
            else {
                Color.gray.frame(width: 150, height: 150)  // Default square if no image
            }
            
            //Display the item name
            Text(recipeItem.name)
                .font(.headline)
                .lineLimit(1)
                .padding([.top], 5)
            
            //Display the cuisine name
            Text(recipeItem.cuisine)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Display the source_url
            if let sourceUrl = recipeItem.source_url, let url = URL(string: sourceUrl) {
                Link("View Recipe", destination: url)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
            //Error text for the if no link is present for the recipe
            else{
                Text("No link for the recipe").font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
            
            // display the youtube_url
            if let youtubeUrl = recipeItem.youtube_url, let url = URL(string: youtubeUrl) {
                Link("Watch on YouTube", destination: url)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
            //Error text if no link is present for the youtube url
            else
            {
                Text("No link for the recipe").font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400)  // Size of each menu item
        .padding(5)
        .background(Color.clear)
        .cornerRadius(20)
        .shadow(radius: 5)
        
    }
}

#Preview {
    ContentView()
}
