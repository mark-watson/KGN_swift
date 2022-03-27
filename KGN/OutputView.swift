//
//  OutputView.swift
//  KGN
//
//  Created by Mark L. Watson on 6/21/21.
//

import SwiftUI

struct OutputView: View {
    @State public var outputText: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            TextEditor(text: $outputText).cornerRadius(10)
        }.padding()
    }
}

struct OutputView_Previews: PreviewProvider {
    static var previews: some View {
        OutputView()
    }
}
