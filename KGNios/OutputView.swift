//
//  OutputView.swift
//  KGNios
//
//  Created by Mark L. Watson on 6/21/21.
//

import SwiftUI

let screenHeight: CGFloat = UIScreen.main.bounds.height

struct OutputView: View {
    @State public var outputText: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            TextEditor(text: $outputText).cornerRadius(10)
            .frame(minHeight: screenHeight * 0.75, maxHeight: .infinity)
        }.padding()
    }
}

struct OutputView_Previews: PreviewProvider {
    static var previews: some View {
        OutputView()
    }
}
