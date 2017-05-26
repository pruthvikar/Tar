//
//  TarTests.swift
//  TarTests
//
//  Created by Pruthvikar Reddy on 25/04/2016.
//  Copyright © 2016 Pruthvikar Reddy. All rights reserved.
//

import XCTest
@testable import Tar

class TarTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testTar() {
    let testData = Tar.tar(Bundle(for: TarTests.self).path(forResource: "tar", ofType: "")!)

    let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle(for: TarTests.self).path(forResource: "TestData", ofType: "tar")!))

    if !(testData.count == data.count){
      XCTFail("Tar - data is not equal")
    }
  }

  func testUntar() {
    let testPath = NSTemporaryDirectory().stringByAppendingPathComponent(UUID().uuidString)
    Tar.untar(try! Data(contentsOf: URL(fileURLWithPath: Bundle(for: TarTests.self).path(forResource: "TestData", ofType: "tar")!)), toPath: testPath)
    let dataPath = Bundle(for: TarTests.self).path(forResource: "tar", ofType: "")!
    print("datapath ",dataPath,"\ntestPath",testPath)
    if !(FileManager.default.contentsEqual(atPath: dataPath.stringByAppendingPathComponent("TestData"), andPath: testPath.stringByAppendingPathComponent("TestData"))){
      XCTFail("Untar - data is not equal")
    }
  }

  static var allTests = [
    ("testTar", testTar),
    ("testUntar", testUntar)
    ]
}
