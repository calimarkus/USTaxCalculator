//
//

import SwiftUI

struct CustomLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .primary : .secondary)
    }
}

struct CollapsableSection<CollapsableContent: View>: View {
    @Binding var expanded: Bool

    let title: String
    let canExpand: Bool
    let content: (Bool) -> CollapsableContent

    init(title: String,
         expandedBinding: Binding<Bool>? = nil,
         @ViewBuilder content: @escaping (_ expanded: Bool) -> CollapsableContent)
    {
        self.title = title
        if let binding = expandedBinding {
            _expanded = binding
            canExpand = true
        } else {
            _expanded = Binding(get: { true }, set: { _ in })
            canExpand = false
        }
        self.content = content
    }

    var body: some View {
        Section(header: Group {
            let titleView = Text(title).font(.title3)
            if canExpand {
                Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    HStack {
                        titleView
                        if canExpand {
                            Image(systemName: expanded ? "chevron.up.square.fill" : "chevron.down.square.fill")
                        }
                    }
                }
                .buttonStyle(CustomLinkStyle())
            } else {
                titleView
            }
        }.padding(.bottom, 10.0)
        ) {
            content(expanded)
        }
    }
}

struct CollapsableSection_Previews: PreviewProvider {
    @State static var expanded: Bool = false
    static var previews: some View {
        List {
            CollapsableSection(title: "Preview", expandedBinding: $expanded) { _ in
                Text("x")
                Text("y")
            }
            CollapsableSection(title: "Fixed section") { _ in
                Text("x")
                Text("y")
            }
        }
    }
}
