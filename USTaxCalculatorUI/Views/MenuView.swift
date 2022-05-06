//
//

import SwiftUI

extension USTaxData: Identifiable {
    var id:String { get { return "\(title ?? "")\(taxYear.rawValue)\(filingType.rawValue)" } }
}

struct MenuView: View {

    @EnvironmentObject var dataset:TaxDataSet

    var body: some View {
        List(selection: $dataset.selection) {
            Section() {
                ForEach(dataset.taxData) { taxdata in
                    Label("\(FormattingHelper.formattedShortTitle(taxData: taxdata))",
                          systemImage: "dollarsign.circle.fill").tag(dataset.taxData.firstIndex(where: { td in
                        td.taxSummaries == taxdata.taxSummaries
                    })!)
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(TaxDataSet())
    }
}
