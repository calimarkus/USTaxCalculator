//
//

import SwiftUI

struct ExplainableView<Content: View>: View {
    @State private var showingPopover = false

    var infoText: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack {
            if let info = infoText {
                Button {
                    showingPopover = !showingPopover
                } label: {
                    content()
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
                content()
                Spacer().frame(width: 23)
            }
        }
    }
}

struct ExplainableValueButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .trailing) {
            ExplainableView {
                Text("$20.00").font(.system(.body, design: .monospaced))
            }
            ExplainableView(infoText: "") {
                Text("$500.50").font(.system(.body, design: .monospaced))
            }
            ExplainableView(infoText: "") {
                Text("$123.00").font(.system(.body, design: .monospaced)).fontWeight(.bold)
            }
            ExplainableView(infoText: "") {
                Text("$200.00").font(.system(.body, design: .monospaced)).foregroundColor(.orange)
            }
        }.padding()
    }
}
