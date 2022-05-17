//
//

import SwiftUI

struct TaxDataEntryView: View {
    @ObservedObject var appState: GlobalAppState
    @Binding var input: TaxDataInput

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
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    @State static var appState: GlobalAppState = .init()
    @State static var input: TaxDataInput = TaxDataInput()
    static var previews: some View {
        TaxDataEntryView(appState: appState, input: $input)
            .frame(height: 640)
    }
}
