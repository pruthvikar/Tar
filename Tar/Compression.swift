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
extension Data {

  public enum Algorithm {
    case lz4
    case lzfse
    case lzma
    case zlib

    public func algorithm() -> compression_algorithm {
      switch self {
      case .lz4: return COMPRESSION_LZ4
      case .lzfse: return COMPRESSION_LZFSE
      case .lzma: return COMPRESSION_LZMA
      case .zlib: return COMPRESSION_ZLIB
      }
    }
  }

  public func compressedData(_ usingAlgorithm: Algorithm) -> Data? {
    return processData(self, algorithm: usingAlgorithm, compress: true)
  }

  public func decompressedData(_ usingAlgorithm: Algorithm) -> Data? {
    return processData(self, algorithm: usingAlgorithm, compress: false)
  }

  fileprivate func processData(_ inputData: Data, algorithm: Algorithm, compress: Bool) -> Data? {
    guard inputData.count > 0 else { return nil }

    var stream = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1).pointee

    let initStatus = compression_stream_init(&stream, compress ? COMPRESSION_STREAM_ENCODE : COMPRESSION_STREAM_DECODE, algorithm.algorithm())
    guard initStatus != COMPRESSION_STATUS_ERROR else {
      print("[Compression] \(compress ? "Compression" : "Decompression") with \(algorithm) failed to init stream with status \(initStatus).")
      return nil
    }

    defer {
      compression_stream_destroy(&stream)
    }

    let bufferSize = 4096

    stream.src_ptr = (inputData as NSData).bytes.bindMemory(to: UInt8.self, capacity: inputData.count)
    stream.src_size = inputData.count

    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    stream.dst_ptr = buffer
    stream.dst_size = bufferSize
    let outputData = NSMutableData()

    while true {
      let status = compression_stream_process(&stream, Int32(compress ? COMPRESSION_STREAM_FINALIZE.rawValue : 0))
      if status == COMPRESSION_STATUS_OK {
        guard stream.dst_size == 0 else { continue }
        outputData.append(buffer, length: bufferSize)
        stream.dst_ptr = buffer
        stream.dst_size = bufferSize
      } else if status == COMPRESSION_STATUS_END {
        guard stream.dst_ptr > buffer else { continue }
        outputData.append(buffer, length: stream.dst_ptr - buffer)
        return outputData as Data
      } else if status == COMPRESSION_STATUS_ERROR {
        print("[Compression] \(compress ? "Compression" : "Decompression") with \(algorithm) failed with status \(status).")
        return nil
      }
    }
  }
}
