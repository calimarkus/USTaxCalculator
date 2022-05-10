//
//

import SwiftUI

struct EmptyView: View {
    @Binding var showIncomeEntryPopover: Bool

    var body: some View {
        VStack(spacing: 0.0) {
            Text("Nothing selected")
                .padding(10.0)
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .opacity(0.5)
            Button {
                showIncomeEntryPopover.toggle()
            } label: {
                Text("Add a dataset")
            }.padding()
        }
        .navigationTitle("")
    }
}

struct EmptyView_Previews: PreviewProvider {
    @State static var show: Bool = false
    static var previews: some View {
        EmptyView(showIncomeEntryPopover: $show)
            .padding()
    }
}
