//
//

import SwiftUI

struct TaxDataEntryView: View {
    @ObservedObject var appState: GlobalAppState
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
        .frame(minHeight: 400)
        .navigationTitle("\(FormattingHelper.formattedTitle(taxDataInput: input))")
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    do {
                        let taxdata = try CalculatedTaxData(input)
                        appState.saveData(taxdata)
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
    @State static var appState: GlobalAppState = .init()
    static var previews: some View {
        TaxDataEntryView(appState: appState)
            .frame(height: 640)
    }
}
