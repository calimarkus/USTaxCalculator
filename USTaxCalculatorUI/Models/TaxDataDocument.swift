//
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let taxDocument = UTType(exportedAs: "com.ustaxcalc.item")
}

enum FloatEncodings {
    static let positiveInfinity = "+inf"
    static let negativeInfinity = "-inf"
    static let nan = "NaN"
}

struct TaxDataDocument : FileDocument {
    var taxDataInput: TaxDataInput

    static var readableContentTypes: [UTType] { [.taxDocument] }

    init() {
        taxDataInput = TaxDataInput()
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: FloatEncodings.positiveInfinity,
                                                                        negativeInfinity: FloatEncodings.negativeInfinity,
                                                                        nan: FloatEncodings.nan)
        self.taxDataInput = try decoder.decode(TaxDataInput.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: FloatEncodings.positiveInfinity,
                                                                      negativeInfinity: FloatEncodings.negativeInfinity,
                                                                      nan: FloatEncodings.nan)
        let encodedData = try encoder.encode(taxDataInput)
        let fileWrapper = FileWrapper(regularFileWithContents: encodedData)
        return fileWrapper
    }
}
