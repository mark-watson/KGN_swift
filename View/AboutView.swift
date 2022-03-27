//
//  FindRelationshipsView.swift
//  KGN
//
//  Created by Mark L. Watson on 6/20/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("About this app")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2).padding()
                Text("The Knowledge Graph Navigator (KGN) app was written by Mark Watson. Mark has written 20 books (mostly about artificial intelligence) and holds 55 US patents. Please visit his web site at:").foregroundColor(Color.black).font(.callout).padding()
                Link("https://markwatson.com", destination: URL(string: "https://markwatson.com/")!).font(.largeTitle).foregroundColor(Color.black).padding()
                Text("Mark's recent books are available as free downloads from his web site in PDF, ePub, and Kindle formats.").foregroundColor(Color.black).font(.callout).padding()
                //Text("Mark's recent books are also available to purchase on LeanPub at:").foregroundColor(Color.black).font(.headline).padding()
                //Link("https://leanpub.com/u/markwatson", destination: URL(string: "https://leanpub.com/u/markwatson")!).font(.headline).foregroundColor(Color.gray).padding()
            } //: VSTACK
        } //: ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading) // .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.95, green: 0.85, blue: 0.65), Color.init(red: 0.6, green: 0.4, blue: 0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

