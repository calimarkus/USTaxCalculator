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
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Federal Income")
                }
            StateEntryTab(input: $input)
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("State Income")
                }
        }
        #if os(macOS)
        .padding()
        .frame(minHeight: 400)
        #endif
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    @State static var appState: GlobalAppState = .init()
    @State static var input: TaxDataInput = .init()
    static var previews: some View {
        TaxDataEntryView(appState: appState, input: $input)
        #if os(macOS)
            .frame(height: 640)
        #endif
    }
}
