//
//

import SwiftUI

struct TaxDataEntryView: View {
    @ObservedObject var dataset: TaxDataSet
    @State var input: TaxDataInput = .emptyInput()

    var body: some View {
        TabView {
            FederalEntryTab(input: $input)
                .tabItem {
                    Text("Federal Income")
                }
            StateEntryTab(input: $input)
                .tabItem {
                    Text("State Income")
                }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
        .navigationTitle("\(FormattingHelper.formattedTitle(taxDataInput: input))")
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    do {
                        let taxdata = try USTaxData(input)
                        if let editingIndex = dataset.editingIndex {
                            dataset.taxData.remove(at: editingIndex)
                            dataset.taxData.insert(taxdata, at: editingIndex)
                            dataset.selection = [editingIndex]
                        } else {
                            dataset.taxData.append(taxdata)
                            dataset.selection = [dataset.taxData.count - 1]
                        }
                    } catch {
                        // TBD - handle invalid inputs
                    }
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    @State static var dataset: TaxDataSet = .init()
    static var previews: some View {
        TaxDataEntryView(dataset: dataset)
            .frame(height: 640)
    }
}
