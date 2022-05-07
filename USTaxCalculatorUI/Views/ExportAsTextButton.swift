//
//

import SwiftUI

struct ExportAsTextButton: View {

    @State private var showingPopover = false

    let taxdata:USTaxData
    var taxSummary:String { get {
        let formatter = TaxSummaryFormatter(columnWidth: 39, separatorSize: (width: 26, shift: 16))
        return formatter.taxDataSummary(taxdata)
    }}

    var body: some View {
        Button() {
            showingPopover = !showingPopover
            if showingPopover {
                NSPasteboard.general.declareTypes([.string], owner: nil)
                NSPasteboard.general.setString(taxSummary, forType: .string)
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .popover(isPresented: $showingPopover) {
                    Text("Copied to clipboard!").padding()
                }
        }
    }
}

struct ExportAsTextButton_Previews: PreviewProvider {
    static var previews: some View {
        ExportAsTextButton(taxdata: TaxDataSet().activeTaxData)
    }
}
