import XCTest
@testable @_exported import XMLParsing

fileprivate let testRootURL = URL(fileURLWithPath: #file).deletingLastPathComponent()

class XMLParsingTests: XCTestCase {
  let decoder = XMLDecoder()
  let encoder = XMLEncoder()

  override func setUp() {
    // reset
    decoder.dateDecodingStrategy = .secondsSince1970
    encoder.dateEncodingStrategy = .deferredToDate
  }

  func decodeAndEncodeTemplate<T: Codable>(
    dateDecodingStrategy: XMLDecoder.DateDecodingStrategy? = nil,
    dateEncodingStrategy: XMLEncoder.DateEncodingStrategy? = nil,
    path: String, rootKey: String, header: XMLHeader, _ type: T.Type = T.self) -> (T, Data) {
    dateDecodingStrategy.map { decoder.dateDecodingStrategy = $0 }
    dateEncodingStrategy.map { encoder.dateEncodingStrategy = $0 }

    var decoded: T!
    var data: Data!
    XCTAssertNoThrow(decoded = try decoder.decode(T.self, from: loadXMLSample(at: path)))
    XCTAssertNoThrow(data = try encoder.encode(decoded, withRootKey: rootKey, header: header))
    return (decoded, data)
  }

  func testBooks() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    _ = decodeAndEncodeTemplate(dateDecodingStrategy: .formatted(formatter), dateEncodingStrategy: .formatted(formatter), path: "Books/book", rootKey: "book", header: .init(version: 1.0), Book.self)
  }

  func testCatalog() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    _ = decodeAndEncodeTemplate(dateDecodingStrategy: .formatted(formatter), dateEncodingStrategy: .formatted(formatter), path: "Books/books", rootKey: "catalog", header: .init(version: 1.0), Catalog.self)
  }

  func testMenu() {
    _ = decodeAndEncodeTemplate(path: "BreakfastMenu/breakfast", rootKey: "breakfast_menu", header: .init(version: 1.0, encoding: "UTF-8"), Menu.self)
  }

  func testCD() {
_ = decodeAndEncodeTemplate(path: "CDs/cd_catalog", rootKey: "CATALOG", header: .init(version: 1.0), CDCatalog.self)
  }

  func testNote() {
    _ = decodeAndEncodeTemplate(path: "Notes/note", rootKey: "note", header: .init(), Note.self)
    XCTAssertThrowsError(try decoder.decode(Note.self, from: loadXMLSample(at: "Notes/note_error")))
  }

  func testPlant() {
    _ = decodeAndEncodeTemplate(path: "Plants/plant_catalog", rootKey: "CATALOG", header: .init(version: 1.0, encoding: "UTF-8"), PlantCatalog.self)
  }

  func testRSS() {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//    _ = decodeAndEncodeTemplate(dateDecodingStrategy: .formatted(dateFormatter),
//                                dateEncodingStrategy: .formatted(dateFormatter),
//                                path: "RJI/RJI_RSS_Sample", rootKey: "rss",
//                                header: .init(version: 1.0, encoding: "UTF-8"), RSS.self)
  }

  private let sampleXMLRootDirectory = testRootURL.appendingPathComponent("Sample XML")

  func loadXMLSample(at path: String) -> Data {
    try! .init(contentsOf: sampleXMLRootDirectory.appendingPathComponent(path).appendingPathExtension("xml"))
  }
}
