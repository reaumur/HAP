import COperatingSystem
import Foundation

public func posix(_ cb: @autoclosure () -> Int32) throws {
    guard cb() == 0 else {
        try throwError()
    }
}

public func throwError() throws -> Never {
    guard let error = PosixError.init(rawValue: errno) else {
        fatalError("Unknown errno \(errno)")
    }
    throw error
}

public enum PosixError: Int32, Error {
    case EPERM = 1
    case ENOENT = 2
    case ESRCH = 3
    case EINTR = 4
    case EIO = 5
    case ENXIO = 6
    case E2BIG = 7
    case ENOEXEC = 8
    case EBADF = 9
    case ECHILD = 10
    case EDEADLK = 11
    case ENOMEM = 12
    case EACCES = 13
    case EFAULT = 14
    case ENOTBLK = 15
    case EBUSY = 16
    case EEXIST = 17
    case EXDEV = 18
    case ENODEV = 19
    case ENOTDIR = 20
    case EISDIR = 21
    case EINVAL = 22
    case ENFILE = 23
    case EMFILE = 24
    case ENOTTY = 25
    case ETXTBSY = 26
    case EFBIG = 27
    case ENOSPC = 28
    case ESPIPE = 29
    case EROFS = 30
    case EMLINK = 31
    case EPIPE = 32
    case EDOM = 33
    case ERANGE = 34
    case EAGAIN = 35
    case EINPROGRESS = 36
    case EALREADY = 37
    case ENOTSOCK = 38
    case EDESTADDRREQ = 39
    case EMSGSIZE = 40
    case EPROTOTYPE = 41
    case ENOPROTOOPT = 42
    case EPROTONOSUPPORT = 43
    case ESOCKTNOSUPPORT = 44
    case ENOTSUP = 45
    case EPFNOSUPPORT = 46
    case EAFNOSUPPORT = 47
    case EADDRINUSE = 48
    case EADDRNOTAVAIL = 49
    case ENETDOWN = 50
    case ENETUNREACH = 51
    case ENETRESET = 52
    case ECONNABORTED = 53
    case ECONNRESET = 54
    case ENOBUFS = 55
    case EISCONN = 56
    case ENOTCONN = 57
    case ESHUTDOWN = 58
    case ETIMEDOUT = 60
    case ECONNREFUSED = 61
    case ELOOP = 62
    case ENAMETOOLONG = 63
    case EHOSTDOWN = 64
    case EHOSTUNREACH = 65
    case ENOTEMPTY = 66
    case EPROCLIM = 67
    case EUSERS = 68
    case EDQUOT = 69
    case ESTALE = 70
    case EBADRPC = 72
    case ERPCMISMATCH = 73
    case EPROGUNAVAIL = 74
    case EPROGMISMATCH = 75
    case EPROCUNAVAIL = 76
    case ENOLCK = 77
    case ENOSYS = 78
    case EFTYPE = 79
    case EAUTH = 80
    case ENEEDAUTH = 81
    case EPWROFF = 82
    case EDEVERR = 83
    case EOVERFLOW = 84
    case EBADEXEC = 85
    case EBADARCH = 86
    case ESHLIBVERS = 87
    case EBADMACHO = 88
    case ECANCELED = 89
    case EIDRM = 90
    case ENOMSG = 91
    case EILSEQ = 92
    case ENOATTR = 93
    case EBADMSG = 94
    case EMULTIHOP = 95
    case ENODATA = 96
    case ENOLINK = 97
    case ENOSR = 98
    case ENOSTR = 99
    case EPROTO = 100
    case ETIME = 101
    case EOPNOTSUPP = 102
}

public protocol Storage: class {
    func read() throws -> Data
    func write(_: Data) throws
}

public class FileStorage: Storage {
    let filename: String

    /// Creates a new instance that will store the device configuration
    /// at the given file path.
    ///
    /// - Parameter filename: path to the file
    public init(filename: String) {
        self.filename = filename
    }

    public func read() throws -> Data {
        let fd = fopen(filename, "r")
        if fd == nil { try throwError() }
        try posix(fseek(fd, 0, COperatingSystem.SEEK_END))
        let size = ftell(fd)
        rewind(fd)
        var buffer = Data(count: size)
        _ = buffer.withUnsafeMutableBytes {
            COperatingSystem.fread($0, size, 1, fd)
        }
        fclose(fd)
        return buffer
    }

    public func write(_ newValue: Data) throws {
        let fd = COperatingSystem.fopen(filename, "w")
        _ = newValue.withUnsafeBytes {
            COperatingSystem.fwrite($0, newValue.count, 1, fd)
        }
        fclose(fd)
    }
}

public class MemoryStorage: Storage {
    var memory = Data()

    public func read() throws -> Data {
        return memory
    }

    public func write(_ newValue: Data) throws {
        memory = newValue
    }
}
