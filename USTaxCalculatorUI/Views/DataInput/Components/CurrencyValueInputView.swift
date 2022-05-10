//
//

import SwiftUI

struct CurrencyValueInputView: View {
    let caption: String
    var subtitle: String? = nil
    @Binding var amount: Double

    var body: some View {
        HStack(spacing: 0.0) {
            VStack(alignment: .trailing) {
                Text(caption)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            TextField("", value: $amount, format: .currency(code: "USD"))
                .font(.title3)
        }
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
                                   subtitle: "(Form XYZ)",
                                   amount: $amountB)
            CurrencyValueInputView(caption: "",
                                   amount: $amountA)
        }
        .padding()
    }
}
