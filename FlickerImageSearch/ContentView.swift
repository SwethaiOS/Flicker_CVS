//
//  ContentView.swift
//  FlickerImageSearch
//
//  Created by Swetha on 2/3/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlickrViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for images", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        viewModel.searchQuery = newValue
                    }
                    
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                if !viewModel.images.isEmpty {
                    GridView(images: viewModel.images)
                }
            }
            .navigationTitle("Flickr Search")
            .padding()
        }
    }
}

struct GridView: View {
    let images: [PhotoItem]
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 200))]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(images) { image in
                    ImageThumbnailView(image: image)
                }
            }
            .padding(.top)
        }
    }
}

struct ImageThumbnailView: View {
    let image: PhotoItem
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: PhotoDetailView(photo: image)) {AsyncImage(url: image.media.m) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            }.buttonStyle(PlainButtonStyle())
                                
            NavigationLink(destination: PhotoDetailView(photo: image)) {
                Text(image.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 100)
                    .lineLimit(1)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct PhotoDetailView: View {
    let photo: PhotoItem
    
    var body: some View {
        ScrollView {
            VStack {
                // Image
                AsyncImage(url: photo.media.m) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                
                Text(photo.title)
                    .font(.title)
                    .padding()
                
                if let description = photo.description {
                    Text(description)
                        .padding()
                } else {
                    Text("No description available.")
                        .padding()
                }
                
                Text("Author: \(String(describing: photo.author ?? ""))")
                    .font(.subheadline)
                    .padding()
                
                Text("Published on: \(formattedDate(photo.published))")
                    .font(.subheadline)
                    .padding()
               
            }
            .navigationTitle(photo.title)
        }
    }
    
        public func formattedDate(_ dateString: String?) -> String {
            guard let dateString = dateString, !dateString.isEmpty else {
                return "No date available"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            guard let date = formatter.date(from: dateString) else {
                return ""
            }
            
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
}


