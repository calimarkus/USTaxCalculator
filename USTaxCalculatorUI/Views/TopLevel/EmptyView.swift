//
//

import SwiftUI

struct EmptyView: View {
    @ObservedObject var dataset: TaxDataSet

    var body: some View {
        VStack(spacing: 0.0) {
            Text("Nothing selected")
                .padding(10.0)
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .opacity(0.5)
            Button {
                dataset.showEntryForm = true
            } label: {
                Text("Add a new entry")
            }.padding()
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    dataset.showEntryForm = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    @State static var dataset: TaxDataSet = TaxDataSet()
    static var previews: some View {
        EmptyView(dataset: dataset)
            .padding()
    }
}
