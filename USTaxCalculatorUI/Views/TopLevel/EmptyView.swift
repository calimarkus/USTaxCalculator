//
//

import SwiftUI

struct EmptyView: View {
    @Binding var showIncomeEntryPopover: Bool

    var body: some View {
        VStack(spacing: 0.0) {
            Image(systemName: "pencil.circle.fill")
                .imageScale(.large)
                .font(.system(size: 42, weight: .bold))
            Text("Nothing selected.")
                .padding()
                .navigationTitle("")
            Button {
                showIncomeEntryPopover.toggle()
            } label: {
                Text("Add a dataset")
            }.padding()
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    @State static var show: Bool = false
    static var previews: some View {
        EmptyView(showIncomeEntryPopover: $show)
            .padding()
    }
}
