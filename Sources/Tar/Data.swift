//
//  Data.swift
//  Carv-Swift
//
//  Created by Pruthvikar Reddy on 06/03/2017.
//  Copyright © 2017 Pruthvikar Reddy. All rights reserved.
//

import Foundation

extension Data {
  init<T>(from value: T) {
    var value = value
    self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }
  func toValue<T>(withOffset offset: Int = 0) -> T {
    return self.withUnsafeBytes { ($0 + offset).pointee }
  }
  func toValue<T>(withByteOffset offset: Int) -> T {
    return self.subdata(in: offset..<offset + MemoryLayout<T>.size).withUnsafeBytes { ($0).pointee }
  }
}

extension Data {

  init<T>(fromArray values: [T]) {
    var values = values
    self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
  }
  func toArray<T>(fromRange range: Range<Int>) -> [T] {
    return self.withUnsafeBytes {
      [T](UnsafeBufferPointer(start: $0 + range.lowerBound, count: range.count))
    }
  }
  func toArray<T>(fromByteRange range: Range<Int>) -> [T] {
    let subdata = self.subdata(in: range.lowerBound..<range.upperBound)
    return subdata.withUnsafeBytes {
      [T](UnsafeBufferPointer(start: $0, count: subdata.count / MemoryLayout<T>.size))
    }
  }
  func toArray<T>() -> [T] {
    return self.withUnsafeBytes {
      [T](UnsafeBufferPointer(start: $0, count: self.count / MemoryLayout<T>.size))
    }
  }
}
