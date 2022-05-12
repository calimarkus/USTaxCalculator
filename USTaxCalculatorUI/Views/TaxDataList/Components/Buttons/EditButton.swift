//
//

import SwiftUI

struct EditButton: View {
    @Binding var isEditing: Bool

    var body: some View {
        Button {
            isEditing.toggle()
        } label: {
            if isEditing {
                Text("Done")
            } else {
                Image(systemName: "square.and.pencil")
            }
        }
    }
}

struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50.0) {
            EditButton(isEditing: .constant(false))
            EditButton(isEditing: .constant(true))
        }
    }
}
