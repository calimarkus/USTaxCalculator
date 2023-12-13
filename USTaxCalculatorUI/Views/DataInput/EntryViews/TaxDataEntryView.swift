//
// TaxDataEntryView.swift
//

import SwiftUI
import TaxInputModels

#if os(macOS)
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
            .padding()
            .frame(minHeight: 400)
        }
    }

#else

    struct TaxDataEntryView: View {
        @ObservedObject var appState: GlobalAppState

        @State var taxdataId: UUID
        @State var input: TaxDataInput
        @State var onDone: (UUID, TaxDataInput) -> Void

        var body: some View {
            TabView {
                Group {
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
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        onDone(taxdataId, input)
                    }
                }
            }
        }
    }

#endif

struct TaxDataEntryView_Previews: PreviewProvider {
    @State static var appState: GlobalAppState = .init()
    @State static var input: TaxDataInput = .init()
    static var previews: some View {
        Group {
            #if os(macOS)
                TaxDataEntryView(appState: appState, input: $input)
                    .frame(height: 640)
            #else
                TaxDataEntryView(appState: appState, taxdataId: UUID(), input: TaxDataInput()) { _, _ in }
            #endif
        }
    }
}
