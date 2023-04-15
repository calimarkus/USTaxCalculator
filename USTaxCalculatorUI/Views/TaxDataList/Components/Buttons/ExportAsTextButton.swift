//
//

import SwiftUI

struct ExportAsTextButton: View {
    @Binding var taxDataInput: TaxDataInput
    @State private var showingPopover = false

    var taxSummary: String {
        let taxdata = CalculatedTaxData(taxDataInput)
        let formatter = TaxSummaryFormatter(columnWidth: 40, separatorSize: (width: 26, shift: 16))
        return formatter.taxDataSummary(taxdata)
    }

    var body: some View {
        Button {
            showingPopover = !showingPopover
            if showingPopover {
                #if os(macOS)
                NSPasteboard.general.declareTypes([.string], owner: nil)
                NSPasteboard.general.setString(taxSummary, forType: .string)
                #elseif os(iOS)
                UIPasteboard.general.string = taxSummary
                #endif
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .popover(isPresented: $showingPopover) {
                    Text("Copied to clipboard!").padding()
                }
                .help("Export as Text")
        }
    }
}

struct ExportAsTextButton_Previews: PreviewProvider {
    @State static var taxDataInput: TaxDataInput = ExampleData.exampleTaxDataJohnAndSarah_21().inputData
    static var previews: some View {
        ExportAsTextButton(taxDataInput: $taxDataInput)
            .padding()
    }
}
