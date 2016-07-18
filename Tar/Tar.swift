//
//  Tar.swift
//  Tar
//
//  Created by Pruthvikar Reddy on 25/04/2016.
//  Copyright © 2016 Pruthvikar Reddy. All rights reserved.
//

import Foundation

extension String {
  func stringByAppendingPathComponent(pathComponent: String) -> String {
    return (self as NSString).stringByAppendingPathComponent(pathComponent)
  }
}

public struct Tar {

  static func compress(inPath: String, outPath: String, using: NSData.Algorithm) {
    let dataToCompress = Tar.tar(inPath)
    let compressedData = dataToCompress.compressedData(using)!
    NSFileManager.defaultManager().createFileAtPath(outPath, contents: compressedData, attributes: nil)
  }

  static func decompress(inPath: String, outPath: String, using: NSData.Algorithm) {
    let compressedData = NSFileManager.defaultManager().contentsAtPath(inPath)
    let data: NSData = (compressedData?.decompressedData(using)!)!
    Tar.untar(data, toPath: outPath)
  }

  // const definition
  private static let TAR_BLOCK_SIZE = 512
  private static let TAR_TYPE_POSITION = 156
  private static let TAR_NAME_POSITION = 0
  private static let TAR_NAME_SIZE = 100
  private static let TAR_SIZE_POSITION = 124
  private static let TAR_SIZE_SIZE = 12
  private static let TAR_MAX_BLOCK_LOAD_IN_MEMORY = 100
  /*
   * Define structure of POSIX 'ustar' tar header.
   + Provided by libarchive.
   */
  private static let	USTAR_name_offset = 0
  private static let	USTAR_name_size = 100
  private static let	USTAR_mode_offset = 100
  private static let	USTAR_mode_size = 6
  private static let	USTAR_mode_max_size = 8
  private static let	USTAR_uid_offset = 108
  private static let	USTAR_uid_size = 6
  private static let	USTAR_uid_max_size = 8
  private static let	USTAR_gid_offset = 116
  private static let	USTAR_gid_size = 6
  private static let	USTAR_gid_max_size = 8
  private static let	USTAR_size_offset = 124
  private static let	USTAR_size_size = 11
  private static let	USTAR_size_max_size = 12
  private static let	USTAR_mtime_offset = 136
  private static let	USTAR_mtime_size = 11
  private static let	USTAR_mtime_max_size = 11
  private static let	USTAR_checksum_offset = 148
  private static let	USTAR_checksum_size = 8
  private static let	USTAR_typeflag_offset = 156
  private static let	USTAR_typeflag_size = 1
  private static let	USTAR_linkname_offset = 157
  private static let	USTAR_linkname_size = 100
  private static let	USTAR_magic_offset = 257
  private static let	USTAR_magic_size = 6
  private static let	USTAR_version_offset = 263
  private static let	USTAR_version_size = 2
  private static let	USTAR_uname_offset = 265
  private static let	USTAR_uname_size = 32
  private static let	USTAR_gname_offset = 297
  private static let	USTAR_gname_size = 32
  private static let	USTAR_rdevmajor_offset = 329
  private static let	USTAR_rdevmajor_size = 6
  private static let	USTAR_rdevmajor_max_size = 8
  private static let	USTAR_rdevminor_offset = 337
  private static let	USTAR_rdevminor_size = 6
  private static let	USTAR_rdevminor_max_size = 8
  private static let	USTAR_prefix_offset = 345
  private static let	USTAR_prefix_size = 155
  private static let	USTAR_padding_offset = 500
  private static let	USTAR_padding_size = 12

  private static let NullChar: UInt8 = 0
  private static let ZeroChar: UInt8 = 48
  private static let MaxChar: UInt8 = 255
  private static let directoryFlagChar: UInt8 = 53

  private static let template_header: [UInt8] = [
    00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 48, 48, 48, 48, 48, 48, 32, 00, 48, 48, 48, 48, 48, 48, 32, 00, 48, 48, 48, 48, 48, 48, 32, 00, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 32, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 32, 32, 32, 32, 32, 32, 32, 32, 32, 48, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 117, 115, 116, 97, 114, 00, 48, 48, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 48, 48, 48, 48, 48, 48, 32, 00, 48, 48, 48, 48, 48, 48, 32, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
  ]



  public static func untar(data: NSData, toPath: String) {
    let fileManager = NSFileManager.defaultManager()
    try! fileManager.createDirectoryAtPath(toPath, withIntermediateDirectories: true, attributes: nil)

    var location : UInt64 = 0

    while location < UInt64(data.length) {
      var blockCount : UInt64 = 1
      let type = typeFor(data, atOffset: location)
      if type == NullChar || type == ZeroChar {
        let name = nameFor(data, atOffset: location)
        print(name,"folder")
        let filePath = toPath.stringByAppendingPathComponent(name)
        let size = sizeFor(data, atOffset: location)
        print(size)
        blockCount += UInt64((size - 1) / (TAR_BLOCK_SIZE)) + 1
        writeFileDataFor(data, atLocation: location + UInt64(TAR_BLOCK_SIZE), withLength: size, atPath: filePath)
      } else if type == 53 {
        let name = nameFor(data, atOffset: location)
        print(name,"53")
        let directoryPath = toPath.stringByAppendingPathComponent(name)
        try! fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
      }
      location += blockCount * UInt64(TAR_BLOCK_SIZE)
    }

  }

  public static func tar(path: String) -> NSData {

    let fm = NSFileManager.defaultManager()
    let md = NSMutableData()
    if fm.fileExistsAtPath(path) {

      for filePath in fm.enumeratorAtPath(path)! {
        var isDir: ObjCBool = ObjCBool(false)

        fm.fileExistsAtPath(path.stringByAppendingPathComponent(filePath as! String), isDirectory: &isDir)
        let tarContent = binaryEncodeData(filePath as! String, inDirectory: path, isDirectory: Bool(isDir))
        md.appendData(tarContent)
      }
      var block = [UInt8](count: TAR_BLOCK_SIZE * 2, repeatedValue: UInt8())
      memset(&block, Int32(NullChar), TAR_BLOCK_SIZE * 2)
      md.appendData(NSData(bytes: UnsafePointer<UInt8>(block), length: block.count))
      return md as NSData
    }

    return NSData()
  }



  private static func writeFileDataFor(data: NSData, atLocation: UInt64, withLength: Int, atPath: String) {
    NSFileManager.defaultManager().createFileAtPath(atPath, contents: data.subdataWithRange(NSRange(location: Int(atLocation), length: Int(withLength))), attributes: nil)
  }

  private static func typeFor(data: NSData, atOffset: UInt64) -> UInt8 {
    var type: UInt8 = 0
    let temp = data.subdataWithRange(NSRange(location: Int(atOffset) + TAR_TYPE_POSITION, length: 1))
    (temp as NSData).getBytes(&type, length: sizeof(UInt8))
    return type
  }

  private static func nameFor(data: NSData, atOffset: UInt64) -> String {
    let temp = data.subdataWithRange(NSRange(location: Int(atOffset) + TAR_NAME_POSITION, length: TAR_NAME_SIZE))
    return String(data: temp, encoding:  NSASCIIStringEncoding)!
  }

  private static func sizeFor(data: NSData, atOffset: UInt64) -> Int {
    let temp = data.subdataWithRange(NSRange(location: Int(atOffset) + TAR_SIZE_POSITION, length: TAR_SIZE_SIZE))
    let sizeString = String(data: temp, encoding: NSASCIIStringEncoding)!
    return strtol(sizeString, nil, 8)
  }


  private static func binaryEncodeData(forPath: String, inDirectory: String, isDirectory: Bool) -> NSData {

    let block = writeHeader(forPath, withBasePath: inDirectory, isDirectory: isDirectory)!
    let data = NSMutableData(bytes: block, length: TAR_BLOCK_SIZE)
    if !isDirectory {
      let path = inDirectory + "/" + forPath

      data.appendData(getContentsAsArray(path))
    }

    return data as NSData
  }

  private static func writeHeader(forPath: String, withBasePath: String, isDirectory: Bool) -> [UInt8]? {

    var buffer = template_header

    let attributesOptional = try? NSFileManager.defaultManager().attributesOfItemAtPath(withBasePath.stringByAppendingPathComponent(forPath))
    guard attributesOptional != nil else {
      return nil
    }
    var path =  forPath
    if isDirectory {
      path += "/"
    }

    let attributes : NSDictionary = attributesOptional!


//    let permissions = Int64((attributes[NSFilePosixPermissions]! as! NSNumber).shortValue)
//    let modificationDate = Int64(attributes[NSFileModificationDate]!.timeIntervalSince1970)
//    let ownerId = Int64((attributes[NSFileOwnerAccountID]! as! NSNumber).unsignedLongValue)
//    let groupId = Int64((attributes[NSFileGroupOwnerAccountID]! as! NSNumber).unsignedLongValue)
//    let ownerName = attributes[NSFileOwnerAccountName] ?? ""
//    let groupName = attributes[NSFileGroupOwnerAccountName]! as! String
//    let fileSize = Int64((attributes[NSFileSize]! as! NSNumber).unsignedLongLongValue)



    let permissions = Int64(attributes.filePosixPermissions())
    let modificationDate = Int64(attributes.fileModificationDate()!.timeIntervalSince1970)
    print(modificationDate)
    let ownerId = Int64(attributes.fileOwnerAccountID()!.integerValue)
    let groupId = Int64(attributes.fileGroupOwnerAccountID()!.integerValue)
    let ownerName = attributes.fileOwnerAccountName() ?? ""
    let groupName = attributes.fileGroupOwnerAccountName() ?? ""
    let fileSize = Int64(attributes.fileSize())
    let nameChar = getStringAsArray(path, withLength: USTAR_name_size)
    let unameChar = getStringAsArray(ownerName, withLength: USTAR_uname_size)
    memcpy(&buffer[USTAR_uname_offset], unameChar, unameChar.count)
    let gnameChar = getStringAsArray(groupName, withLength: USTAR_gname_size)
    memcpy(&buffer[USTAR_gname_offset], gnameChar, gnameChar.count)
    formatNumber(permissions & 4095, buffer: &buffer, offset: USTAR_mode_offset, size: USTAR_mode_size, maxsize: USTAR_mode_max_size)
    formatNumber(ownerId, buffer: &buffer, offset: USTAR_uid_offset, size: USTAR_uid_size, maxsize: USTAR_uid_max_size)
    formatNumber(groupId, buffer: &buffer, offset: USTAR_gid_offset, size: USTAR_gid_size, maxsize: USTAR_gid_max_size)
    formatNumber(fileSize, buffer: &buffer, offset: USTAR_size_offset, size: USTAR_size_size, maxsize: USTAR_size_max_size)
    formatNumber(modificationDate, buffer: &buffer, offset: USTAR_mtime_offset, size: USTAR_mtime_size, maxsize: USTAR_mtime_max_size)
    let nameLength = nameChar.count
    if nameLength <= USTAR_name_size {
      memcpy(&buffer[USTAR_name_offset], nameChar, nameLength)
    } else {
      fatalError("Name too long")
    }

    if isDirectory {
      formatNumber(0, buffer: &buffer, offset: USTAR_size_offset, size: USTAR_size_size, maxsize: USTAR_size_max_size)
      buffer[USTAR_typeflag_offset] = directoryFlagChar
    }

    var checksum: UInt64 = 0

    for i in buffer {
      checksum = checksum + (255 & UInt64(i))
    }

    buffer[USTAR_checksum_offset + 6] = NullChar
    formatOctal(Int64(checksum), buffer: &buffer, offset: USTAR_checksum_offset, size: 6)
//    print(path,buffer.map({Character(UnicodeScalar($0))}))
    return buffer

  }

  private static func getContentsAsArray(path: String) -> NSData {
    let content = NSData(contentsOfURL: NSURL(fileURLWithPath: path))!
    let contentSize = content.length
    let padding = (TAR_BLOCK_SIZE - (contentSize % TAR_BLOCK_SIZE)) % TAR_BLOCK_SIZE
    var buffer = [UInt8](count: padding, repeatedValue: UInt8())
    memset(&buffer, Int32(NullChar), padding)
    let data = NSMutableData(data: content)
    data.appendBytes(buffer, length: padding)
    return data
  }


  private static func getStringAsArray(string: String, withLength: Int) -> [UInt8] {
    let stringData = string.dataUsingEncoding(NSASCIIStringEncoding)
    var charArray = [UInt8](count: withLength, repeatedValue: UInt8())
    stringData?.getBytes(&charArray, length:(stringData?.length)!)
    return charArray
  }

  private static func formatNumber(value: Int64, inout buffer: [UInt8], offset: Int, size: Int, maxsize: Int) {
    var limit: Int64 = 1 << (Int64(size) * 3)

    if value >= 0 {
      for _ in size...maxsize {
        if value < limit {
          return formatOctal(value, buffer: &buffer, offset: offset, size: size)
        }
        limit <<= 3
      }
    }
    format256(value, buffer: &buffer, offset: offset, maxsize: maxsize)
    return

  }

  private static func formatOctal(value: Int64, inout buffer: [UInt8], offset: Int, size: Int) {
    let len = size

    if value < 0 {
      for i in 0..<len {
        buffer[offset + i] = ZeroChar
      }
      return
    }

    var valueCopy = value

    for i in 1...size {
      buffer[offset + size - i] = ZeroChar + UInt8(valueCopy & 7)
      valueCopy >>= 3
    }

    if valueCopy == 0 {
      return
    }

    for _ in 0..<len {
      buffer[offset] = MaxChar
    }

    return
  }


  private static func format256(value: Int64, inout buffer: [UInt8], offset: Int, maxsize: Int) {
    var valueCopy = value
    for i in 0..<maxsize {
      buffer[offset + maxsize - i] = UInt8(valueCopy & 0xff)
      valueCopy >>= 8
    }
    buffer[offset] |= 0x80
    
  }
}
