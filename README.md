# Tar
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*A simple implementation of Tar written in Swift.*

Tar exposes the following headers

```Swift
public static func untar(path: String, toPath: String, using: NSData.Algorithm? = nil)
public static func untar(data: NSData, toPath: String, using: NSData.Algorithm? = nil)
public static func tar(path: String, toPath: String, using: NSData.Algorithm? = nil)
public static func tar(path: String, using: NSData.Algorithm? = nil) -> NSData
```

NSData.Algorithm is an enum that represents the 4 different types of compression offered by Apple's Compression library

```Swift
public enum Algorithm {
  case LZ4
  case LZFSE
  case LZMA
  case ZLIB
}
```

## Installation

Tar is Carthage compatible. To install add the following to your Cartfile.
```
github "pruthvikar/Tar" 
```
For additional info on Carthage installation please visit [https://github.com/Carthage/Carthage](https://github.com/Carthage/Carthage).

## License

Tar is available under the GNU General Public License. See the LICENSE file for more info.


*Inspired by [daltoniam/tarkit](https://github.com/daltoniam/tarkit)*
