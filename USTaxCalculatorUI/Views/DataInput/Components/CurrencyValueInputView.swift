//
//

import SwiftUI

struct CurrencyValueInputView: View {
    var caption: String? = nil
    var subtitle: String? = nil
    @Binding var amount: Double

    var body: some View {
        #if os(macOS)
            HStack(spacing: 0.0) {
                VStack(alignment: .trailing) {
                    Text(caption ?? "")
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                TextField("", value: $amount, format: .currency(code: "USD"))
                    .font(.system(.body, design: .monospaced))
            }
        #elseif os(iOS)
            VStack(alignment: .leading, spacing: 0.0) {
                if let caption = caption, caption.count > 0 {
                    VStack(alignment: .leading) {
                        Text(caption)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 5.0)
                }
                TextField("", value: $amount, format: .currency(code: "USD"))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.primary).opacity(0.8)
                    .padding(.top, 7.0)
            }
        #endif
    }
}

struct CurrencyValueInputView_Previews: PreviewProvider {
    @State static var amountA: Double = 500.0
    @State static var amountB: Double = 0.0

    static var previews: some View {
        Form {
            CurrencyValueInputView(caption: "Field 1",
                                   amount: $amountA)
            CurrencyValueInputView(caption: "Field 2",
                                   subtitle: "subtitle",
                                   amount: $amountA)
            CurrencyValueInputView(caption: "Long as title that also has a subtitle",
                                   subtitle: "(Form XYZ and some)",
                                   amount: $amountB)
            CurrencyValueInputView(amount: $amountA)
        }
        .macOnlyPadding(25.0)
    }
}
