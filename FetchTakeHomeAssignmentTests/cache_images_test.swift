import XCTest
@testable import FetchTakeHomeAssignment


//----------- TEST CASE TO TEST THE CACHING ------------
final class FetchTakeHomeAssignment: XCTestCase {
    
    var cacheImages: CacheImages!
    var testImageURL: String!
    var testKey: String!
    
    override func setUpWithError() throws {
        // Initialize CacheImages object
        cacheImages = CacheImages()

        //test image url and test key
        testImageURL = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
        testKey = "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
    }

    override func tearDownWithError() throws {
        // Clean up after the test
        cacheImages = nil
        testImageURL = nil
        testKey = nil
    }
    
    func testSaveImageToCache() {
        //Save the image to the cache
        cacheImages.saveImageToCache(from: testImageURL, forKey: testKey)
        //Get the filePath using the kye
        let filePath = cacheImages.filePath(forKey: testKey)
        //Check if the filePath exists
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path), "Image saved in the cache directory.")
    }
    
    func testLoadImageFromCache() {

        //load the image from the cache
        if let loadedImage = cacheImages.loadImageFromCache(forKey: testKey) {
            XCTAssertNotNil(loadedImage, "The image should be loaded from cache.")
        } else {
            //Fail test if image is not being loaded
            XCTFail("Failed to load image from cache.")
        }
    }
    
    func testLoadImageFromCache_whenNotSaved() {
        //Load image from the cache for a non existent key
        let loadedImage = cacheImages.loadImageFromCache(forKey: "nil_key")
        XCTAssertNil(loadedImage, "The image should be nil if not saved.")
    }
}
