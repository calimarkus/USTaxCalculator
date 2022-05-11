//
//

import SwiftUI

struct AddStateButton: View {
    let onAdd: () -> ()

    var body: some View {
        Button {
            onAdd()
        } label: {
            Image(systemName: "plus.circle.fill")
            Text("Add State")
                .fontWeight(.bold)
        }
        .buttonStyle(.plain)
        .padding(.top, 10.0)
    }
}

struct AddStateButton_Previews: PreviewProvider {
    static var previews: some View {
        AddStateButton() {}
            .padding()
    }
}
