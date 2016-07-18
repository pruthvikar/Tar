import Foundation
import Compression

/// A convenience class for compressing an NSData object.
///
/// Example:
/// ```
/// let compression = Compression(algorithm: .ZLIB)
/// let compressedData = compression.compressData(data)
/// let decompressedData = compresison.decompressData(compressedData)
/// ```
///
extension NSData {

  public enum Algorithm {
    case LZ4
    case LZFSE
    case LZMA
    case ZLIB

    public func algorithm() -> compression_algorithm {
      switch self {
      case .LZ4: return COMPRESSION_LZ4
      case .LZFSE: return COMPRESSION_LZFSE
      case .LZMA: return COMPRESSION_LZMA
      case .ZLIB: return COMPRESSION_ZLIB
      }
    }
  }

  public func compressedData(usingAlgorithm: Algorithm) -> NSData? {
    return processData(self, algorithm: usingAlgorithm, compress: true)
  }

  public func decompressedData(usingAlgorithm: Algorithm) -> NSData? {
    return processData(self, algorithm: usingAlgorithm, compress: false)
  }

  private func processData(inputData: NSData, algorithm: Algorithm, compress: Bool) -> NSData? {
    guard inputData.length > 0 else { return nil }

    var stream = UnsafeMutablePointer<compression_stream>.alloc(1).memory

    let initStatus = compression_stream_init(&stream, compress ? COMPRESSION_STREAM_ENCODE : COMPRESSION_STREAM_DECODE, algorithm.algorithm())
    guard initStatus != COMPRESSION_STATUS_ERROR else {
      print("[Compression] \(compress ? "Compression" : "Decompression") with \(algorithm) failed to init stream with status \(initStatus).")
      return nil
    }

    defer {
      compression_stream_destroy(&stream)
    }

    let bufferSize = 4096

    stream.src_ptr = UnsafePointer<UInt8>(inputData.bytes)
    stream.src_size = inputData.length

    let buffer = UnsafeMutablePointer<UInt8>.alloc(bufferSize)
    stream.dst_ptr = buffer
    stream.dst_size = bufferSize
    let outputData = NSMutableData()

    while true {
      let status = compression_stream_process(&stream, Int32(compress ? COMPRESSION_STREAM_FINALIZE.rawValue : 0))
      if status == COMPRESSION_STATUS_OK {
        guard stream.dst_size == 0 else { continue }
        outputData.appendBytes(buffer, length: bufferSize)
        stream.dst_ptr = buffer
        stream.dst_size = bufferSize
      } else if status == COMPRESSION_STATUS_END {
        guard stream.dst_ptr > buffer else { continue }
        outputData.appendBytes(buffer, length: stream.dst_ptr - buffer)
        return outputData
      } else if status == COMPRESSION_STATUS_ERROR {
        print("[Compression] \(compress ? "Compression" : "Decompression") with \(algorithm) failed with status \(status).")
        return nil
      }
    }
  }
}