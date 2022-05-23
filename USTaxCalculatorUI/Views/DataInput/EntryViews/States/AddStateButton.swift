//
//

import SwiftUI

struct AddStateButton: View {
    let onAdd: () -> ()

    var body: some View {
        Button {
            onAdd()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add State").fontWeight(.bold)
            }
        }
        #if os(macOS)
        .buttonStyle(.plain)
        .padding(.top, 10.0)
        #endif
    }
}

struct AddStateButton_Previews: PreviewProvider {
    static var previews: some View {
        AddStateButton {}
            .macOnlyPadding(30.0)
    }
}
