//
//  PhotoDetailViewTests.swift
//  FlickerImageSearch
//
//  Created by Swetha on 2/3/25.
//
import XCTest
@testable import FlickerImageSearch

class PhotoDetailViewTests: XCTestCase {
    
    var photoDetailView: PhotoDetailView!
    
    func testFormattedDate_validDate() {
        let validDateString = "2025-02-01T14:30:00Z"
        let photoDetailView = PhotoDetailView(photo:PhotoItem(
            id: "http://example.com/image.jpg",
            title: "Test Image",
            description: "A beautiful photo",
            author: "John Doe",
            published: validDateString,
            media: PhotoItem.Media(m: URL("http://example.com/image.jpg")!)
        ))
        
        let formattedDate = photoDetailView.formattedDate(validDateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: validDateString)
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let expectedFormattedDate = dateFormatter.string(from: date!)
        
        XCTAssertEqual(formattedDate, expectedFormattedDate, "Date format did not match the expected output for valid date.")
    }
    
    func testFormattedDate_invalidDate() {
        let invalidDateString = "Invalid date"
        let photoDetailView = PhotoDetailView(photo:PhotoItem(
            id: "http://example.com/image.jpg",
            title: "Test Image",
            description: "A beautiful photo",
            author: "John Doe",
            published: invalidDateString,
            media: PhotoItem.Media(m: URL("http://example.com/image.jpg")!)
        ))
        let formattedDate = photoDetailView.formattedDate(invalidDateString)
        
        XCTAssertEqual(formattedDate, "", "Invalid date format should return ''.")
    }
    
    func testFormattedDate_nilDate() {
        // Given
        let nilDateString: String? = nil
        let photoDetailView = PhotoDetailView(photo:PhotoItem(
            id: "http://example.com/image.jpg",
            title: "Test Image",
            description: "A beautiful photo",
            author: "John Doe",
            published: "",
            media: PhotoItem.Media(m: URL("http://example.com/image.jpg")!)
        ))
        
        // When
        let formattedDate = photoDetailView.formattedDate(nilDateString)
        
        // Then
        XCTAssertEqual(formattedDate, "No date available", "Nil date should return 'No date available'.")
    }
    
    func testFormattedDate_emptyDate() {
        // Given
        let emptyDateString = ""
        
        // When
        let formattedDate = photoDetailView.formattedDate(emptyDateString)
        
        // Then
        XCTAssertEqual(formattedDate, "No date available", "Empty date string should return 'No date available'.")
    }
}
