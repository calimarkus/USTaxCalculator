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
    let content: (Bool) -> CollapsableContent

    init(title: String, expanded: Binding<Bool>, @ViewBuilder content: @escaping (_ expanded: Bool) -> CollapsableContent)
    {
        self.title = title
        self._expanded = expanded
        self.content = content
    }

    var body: some View {
        Section(header: HStack {
            Button {
                withAnimation { expanded.toggle() }
            } label: {
                Text(title)
                Image(systemName: expanded ? "chevron.up.square.fill" : "chevron.down.square.fill")
            }.buttonStyle(CustomLinkStyle())
        }) {
            content(expanded)
        }
    }
}

struct CollapsableSection_Previews: PreviewProvider {
    @State static var expanded: Bool = false
    static var previews: some View {
        List {
            CollapsableSection(title: "Preview", expanded: $expanded) { _ in
                Text("x")
                Text("y")
            }
        }
    }
}
