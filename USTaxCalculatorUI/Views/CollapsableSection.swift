//
//

import SwiftUI

struct CustomLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .primary : .secondary)
    }
}

struct CollapsableSection<CollapsableContent: View, FixedContent: View>: View {

    @State var expanded:Bool = true

    let title:String
    let collapsableContent: CollapsableContent
    let fixedContent: FixedContent

    init(title: String,
         @ViewBuilder collapsableContent: () -> CollapsableContent,
         @ViewBuilder fixedContent: () -> FixedContent
    ) {
        self.title = title
        self.collapsableContent = collapsableContent()
        self.fixedContent = fixedContent()
    }

    var body: some View {
        Section(header: HStack(){
            Button() { withAnimation { expanded.toggle() } } label: {
                Text(title)
                Image(systemName: expanded ? "chevron.up.square.fill" : "chevron.down.square.fill")
            }.buttonStyle(CustomLinkStyle())
        }) {
            if (expanded) {
                collapsableContent
            }
            fixedContent
        }
    }
}

struct CollapsableSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollapsableSection(
                title: "preview",
                collapsableContent: {
                    Text("x")
                }, fixedContent: {
                    Text("y")
                }
            )
        }
    }
}
