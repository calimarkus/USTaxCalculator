//
//

import SwiftUI

struct EntryViewTitle: View {
    let title: String
    let onSave: () -> ()
    let onAddState: () -> ()

    var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Color.secondary
                    .opacity(0.25)
                    .frame(height: 44.0)
                HStack {
                    Button {
                        onAddState()
                    } label: {
                        Text("Add State")
                    }
                    Spacer()
                    Text(title)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Button {
                        onSave()
                    } label: {
                        Text("Save")
                    }
                }
                .padding(.trailing, 20.0)
                .padding(.leading, 20.0)
            }
            Color.secondary
                .frame(height: 1.0)
                .opacity(0.5)
        }
    }
}

struct EntryViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        EntryViewTitle(title: "Some text",
                       onSave: {},
                       onAddState: {})
            .padding()
    }
}
