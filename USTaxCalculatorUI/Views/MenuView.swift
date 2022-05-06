//
//

import SwiftUI

extension USTaxData: Identifiable {
    var id:String { get { return "\(title ?? "")\(taxYear.rawValue)\(filingType.rawValue)" } }
}

struct MenuView: View {

    let data:[USTaxData]
    @State var selection: Set<Int> = [0]

    var body: some View {
        List(selection: self.$selection) {
            Section() {
                ForEach(data) { taxdata in
                    Label("\(FormattingHelper.formattedShortTitle(taxData: taxdata))",
                          systemImage: "dollarsign.circle.fill").tag(data.firstIndex(where: { td in
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
        MenuView(data: [ExampleData.single21Data()])
    }
}
