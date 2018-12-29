import Foundation
import HAPHTTP

func identify(device: Device) -> Responder {
    return { context, request in
        device.delegate?.didRequestIdentification()
        return HTTPResponse(status: .noContent)
    }
}
