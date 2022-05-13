//
//

import SwiftUI

struct CustomLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
    }
}

struct NonCollapsableSection<CollapsableContent: View>: View {
    let title: String
    var isFirst: Bool = false
    var titleInset: Double = 10.0

    @ViewBuilder let content: () -> CollapsableContent

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, isFirst ? 0.0 : 6.0)
            .padding(.bottom, 2.0)
            .padding(.leading, titleInset)

        content()
    }
}

struct CollapsableSection<CollapsableContent: View>: View {
    let title: String
    var isFirst: Bool = false
    var titleInset: Double = 10.0

    @Binding var expandedBinding: Bool
    @ViewBuilder let content: (Bool) -> CollapsableContent

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Button {
                    withAnimation {
                        expandedBinding.toggle()
                    }
                } label: {
                    HStack {
                        Text(title)
                            .font(.headline)
                        Image(systemName: expandedBinding
                            ? "chevron.down.square.fill"
                            : "chevron.up.square.fill")
                    }
                }
                .buttonStyle(CustomLinkStyle())
            }
            .padding(.top, isFirst ? 0.0 : 6.0)
            .padding(.bottom, 2.0)
            .padding(.leading, titleInset)

            content(expandedBinding)
        }
    }
}

struct CollapsableSection_Previews: PreviewProvider {
    @State static var expanded: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            CollapsableSection(title: "First one",
                               isFirst: true,
                               titleInset: 5.0,
                               expandedBinding: $expanded) { _ in
                GroupBox {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Some longer text here")
                            Text("Some longer text here")
                        }
                        Text("And more text")
                    }.padding()
                }
            }
            CollapsableSection(title: "Second",
                               titleInset: 0.0,
                               expandedBinding: $expanded) { _ in
                Text("x")
                Text("y")
            }
            NonCollapsableSection(title: "Fixed Third", titleInset: 0.0) {
                Text("x")
                Text("y")
            }
        }.padding()
    }
}
