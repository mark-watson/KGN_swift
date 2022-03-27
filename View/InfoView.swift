//
//  InfoView.swift
//  KGN
//
//  Created by Mark L. Watson on 6/20/21.
//

import SwiftUI

struct InfoView: View {
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("How to use this app")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2).padding(20)
                Text("The Knowledge Graph Navigator (KGN) app accepts natural language queries like: 'Who is Bill Gates?' or 'What is he population of Paris?', etc. You must end a question with a question mark (?).").foregroundColor(Color.black).font(.callout).padding(11)
                Text("If many SPARQL queries to DBPedia are made, it might take 20 or 30 seconds for results. SPARQL query results are cached. The technology behind this app is a combination of deep learning models and semantic web/linked data technology using the public Knowledge Graph DBPedia to answer your questions.").foregroundColor(Color.black).font(.callout).padding(11)
                Text("The is a second query mode. Intead of entering a question, you can enter a coma separated list of entity names.").foregroundColor(Color.black).font(.callout).padding(11)
                Text("Here are some exmples:").foregroundColor(Color.black).font(.callout).padding(11)
                Text("Bill Gates, Melinda Gates, Steve Jobs, Microsoft,  Seattle").foregroundColor(Color.secondary).font(.callout).padding(11)
                Text("You can also enter a sentence containing entity names:").foregroundColor(Color.black).font(.callout).padding(11)
                Text("Bill Gates and Melinda Gates and Steve Jobs visited Microsoft in Seattle").foregroundColor(Color.secondary).font(.callout).padding(11)
                Text("If you use an entity name like 'Steve Jobs' that represents several distinct people in DBPedia, then you will get a popup prompt to choose which person you intended. This also works for place names and organization names.").foregroundColor(Color.black).font(.callout).padding(11)
                Text("If there is more that one description for an entity name is found in DBPedia, then choose one or you can always leave a selection empty to igniore the entity name in the results.").foregroundColor(Color.black).font(.callout).padding(11)
            } //: VSTACK
        } //: ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.98, green: 0.75, blue: 0.75), Color.init(red: 0.7, green: 0.2, blue: 0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}
