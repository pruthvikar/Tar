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

  func testArchiveZLIB() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "zlib")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!.compressedData(.ZLIB)!
    if testData != data {

      XCTFail("ZLIB Archive - files are not equal")
    }
  }

  func testArchiveLZMA() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lzma")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!.compressedData(.LZMA)!
    if testData != data {
      XCTFail("LZMA Archive - files are not equal")
    }
  }

  func testArchiveLZ4() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lz4")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!.compressedData(.LZ4)!
    if testData != data {
      XCTFail("LZ4 Archive - files are not equal")
    }
  }

  func testArchiveLZFSE() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lzfse")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!.compressedData(.LZFSE)!
    if testData != data {

      XCTFail("LZFSE Archive - files are not equal")
    }
  }


  func testUnarchiveZLIB() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "zlib")!)!.decompressedData(.ZLIB)!
    if testData != data {

      XCTFail("ZLIB Unarchive - files are not equal")
    }
  }

  func testUnarchiveLZMA() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lzma")!)!.decompressedData(.LZMA)!
    if testData != data {
      XCTFail("LZMA Unarchive - files are not equal")
    }
  }

  func testUnarchiveLZFSE() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lzfse")!)!.decompressedData(.LZFSE)!
    if testData != data {
      XCTFail("LZFSE Unarchive - files are not equal")
    }
  }

  func testUnarchiveLZ4() {
    let testData = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "txt")!)!

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "lz4")!)!.decompressedData(.LZ4)!
    if testData != data {
      XCTFail("LZ4 Unarchive - files are not equal")
    }
  }

  func testTar() {
    let testData = Tar.tar(NSBundle(forClass: TarTests.self).pathForResource("tar", ofType: "")!)

    let data = NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "tar")!)!

    if !(testData.length == data.length){
      XCTFail("Tar - data is not equal")
    }
  }

  func testUntar() {
    let testPath = NSTemporaryDirectory().stringByAppendingPathComponent(NSUUID().UUIDString)
    Tar.untar(NSData(contentsOfFile: NSBundle(forClass: TarTests.self).pathForResource("TestData", ofType: "tar")!)!, toPath: testPath)
    let dataPath = NSBundle(forClass: TarTests.self).pathForResource("tar", ofType: "")!
    print("datapath ",dataPath,"\ntestPath",testPath)
    if !(NSFileManager.defaultManager().contentsEqualAtPath(dataPath.stringByAppendingPathComponent("TestData"), andPath: testPath.stringByAppendingPathComponent("TestData"))){
      XCTFail("Untar - data is not equal")
    }
  }
  
}
