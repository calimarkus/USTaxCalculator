//
//

import SwiftUI

struct ExplainableValueButton: View {
    @State private var showingPopover = false

    let valueText: String
    var infoText: String? = nil
    var bold: Bool = false
    var valueColor: Color? = nil

    var body: some View {
        let text = Text(valueText)
            .font(.system(.body, design: .monospaced))
            .fontWeight(bold ? .bold : .regular)
            .foregroundColor(valueColor)

        HStack {
            if let info = infoText {
                Button {
                    showingPopover = !showingPopover
                } label: {
                    text
                    Image(systemName: "info.circle")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingPopover) {
                    Text(info)
                        .padding()
                        .font(.system(.body, design: .monospaced))
                }
            } else {
                text
                Spacer().frame(width: 23)
            }
        }
    }
}

struct ExplainableValueButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ExplainableValueButton(valueText: "$20.00")
            ExplainableValueButton(valueText: "$500.50",
                                   infoText: "additional info")
            ExplainableValueButton(valueText: "$123.00",
                                   infoText: "additional info",
                                   bold: true)
            ExplainableValueButton(valueText: "$200.00",
                                   infoText: "additional info",
                                   bold: false,
                                   valueColor: .orange)
        }.padding()
    }
}
