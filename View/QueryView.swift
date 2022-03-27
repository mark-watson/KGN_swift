//
//  QueryEntityView.swift
//  KGN
//
//  Created by Mark L. Watson on 6/20/21.
//

import SwiftUI
import CoreML


var bb = NlpWhiteboard()

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isVisible: Bool
    @Binding var generatedSparql: String
    @Binding var enteredText: String
    @Binding var choices: [[[String]]] // [[["a name", "a_uri"]]]
    @Binding var outputText: String
    @State var selectedEntityUris: [String]
    @State var selectedName: String?
    @State var choiceIndices: [Int] = [-1, -1, -1, -1, -1]
    @State var sliderValue: Float
    @Binding var result: String
    
    func getOneMatchDisplayListText() -> [String] {
        var ret: [String] = []
        for entityIndex in 0..<choices.count {
            for i in 0..<choices[entityIndex].count {
                if choices[entityIndex].count == 1 {
                    let s =  String(choices[entityIndex][i][0]).prefix(90) + "...\n"
                    ret.append(String(s))
                }
            }
        }
        return ret
    }
    let w1:CGFloat = 575
    let w2:CGFloat = 675
    
    var body: some View {
        let rr = getOneMatchDisplayListText()
        VStack {
            VStack {
                Text("Matching entities with only one 'hit' in DBPedia:").font(.headline).padding()
                ForEach(0..<rr.count) {
                    Text(rr[$0]).multilineTextAlignment(.leading)
                }
                Text("For entities with multiple 'hits', choose one from each selector, then hit Done:").font(.headline).padding()
            }
            NavigationView {
                Form {
                    if choiceIndices.count > 0 && self.choices.count > 0 && self.choices[0].count > 1 {
                        Picker("Choose one:", selection: self.$choiceIndices[0]) {
                            ForEach(0..<self.choices[0].count) {
                                Text(splitLongStrings(self.choices[0][$0][0], limit: 60))
                                Divider()
                            }
                        }.frame(minWidth: w1, idealWidth: w2)
                    }
                    if choiceIndices.count > 1 && self.choices.count > 1 && self.choices[1].count > 1 {
                        Picker("Choose one:", selection: self.$choiceIndices[1]) {
                            ForEach(0..<self.choices[1].count) {
                                Text(splitLongStrings(self.choices[1][$0][0], limit: 60))
                                Divider()
                            }
                        }.frame(minWidth: w1, idealWidth: w2)
                    }
                    if choiceIndices.count > 2 && self.choices.count > 2 && self.choices[2].count > 1 {
                        Picker("Choose one:", selection: self.$choiceIndices[2]) {
                            ForEach(0..<self.choices[2].count) {
                                Text(splitLongStrings(self.choices[2][$0][0], limit: 60))
                                Divider()
                            }
                        }.frame(minWidth: w1, idealWidth: w2)
                    }
                    if choiceIndices.count > 3 && self.choices.count > 3 && self.choices[3].count > 1 {
                        Picker("Choose one:", selection: self.$choiceIndices[3]) {
                            ForEach(0..<self.choices[3].count) {
                                Text(splitLongStrings(self.choices[3][$0][0], limit: 60))
                                Divider()
                            }
                        }.frame(minWidth: w1, idealWidth: w2)
                    }
                    if choiceIndices.count > 4 && self.choices.count > 4 && self.choices[4].count > 1 {
                        Picker("Choose one:", selection: self.$choiceIndices[4]) {
                            ForEach(0..<self.choices[4].count) {
                                Text(splitLongStrings(self.choices[4][$0][0], limit: 60))
                                Divider()
                            }
                        }.frame(minWidth: w1, idealWidth: w2)
                    }
                }.frame(minWidth: w1, idealWidth: w2)
            }//.frame(minWidth: 350, idealWidth: 450, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Button("Done") {
                self.result = "NO RESULTS FOR QUERY"
                self.selectedEntityUris = []
                if choiceIndices.count > 1 {
                    for i in 0..<self.choices.count { // choiceIndices.count {
                        if choiceIndices[i] == -1 && self.choices[i].count == 1 {
                            self.sliderValue += 5
                            self.outputText = self.outputText + self.choices[i][0][0]  + "\n\n"
                            self.selectedEntityUris.append(self.choices[i][0][1])
                        } else if self.choiceIndices[i] > -1 {
                            self.sliderValue += 15
                            self.outputText = self.outputText + self.choices[i][self.choiceIndices[i]][0]  + "\n\n"
                            self.selectedEntityUris.append(self.choices[i][self.choiceIndices[i]][1])
                        }
                    }
                }
                // call Relationships code here:
                var relationshipData: [String] = []
                for uri1 in self.selectedEntityUris {
                    for uri2 in self.selectedEntityUris {
                        if uri1 != uri2 {
                            relationshipData.append(contentsOf: dbpediaGetRelationships(entity1Uri: "<"+uri1+">", entity2Uri: "<"+uri2+">"))
                        }
                    }
                }
                self.outputText = "RELATIONSHIPS:\n\n" + relationshipsoEnglish(rs: relationshipData) + "\n\nENTITY DETAILS:\n" + self.outputText
                presentationMode.wrappedValue.dismiss()
            }
            .padding(5)
            .background(Color(red: 0, green: 0, blue: 0.95))
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        }.padding(5).frame(width: 600)
    }
}
struct QueryView: View {
    @State public var entityQuery: String = "Bill Gates and Melinda Gates and Steve Jobs visited Microsoft in Seattle" //  what is the population of Paris?" // " where is the headquarters of IBM?" // " who is Bill Gates"
    @State public var outputText: String = ""
    @State public var behindTheScenesSparqlText: String = ""
    @State public var behindTheScenesDeepLearningText: String = ""
    @State public var sliderValue: Float = 0
    @State public var showProgress: Bool = false
    @State public var selectedEntityUris: [String] = []
    @State var choices : [[[String]]] = [[["a name", "a_uri"]]]
    @State private var alertIsShowing = false
    @State private var dialogResult = "Click the buttons above to test the dialogs."
    @State private var sheetIsShowing = false
    @State var result = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Text("Knowledge Graph Navigator")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2).padding()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Enter entity query:").bold()
                    TextEditor(text: $entityQuery).fixedSize(horizontal: false, vertical: true).textFieldStyle(RoundedBorderTextFieldStyle())
                    //TextField("Enter entity query", text: $entityQuery).textFieldStyle(RoundedBorderTextFieldStyle())
                }.lineLimit(4).padding()
                
                // BUTTON: START
                Button(action: {
                    showProgress = true
                    outputText = ""
                    behindTheScenesSparqlText = ""
                    sliderValue = 0
                    entityQuery = entityQuery.trimmingCharacters(in: .whitespacesAndNewlines)
                    if entityQuery.last! == "?" {
                        // QA using entity detection, SPARQL, and BERT:
                        let bert = BERT()
                        let entities = getAllEntities(text: entityQuery)
                        var contextText = ""
                        if entities.0.count > 0 {
                            for person in entities.0 {
                                sliderValue += 11
                                let genSparqlAndCtext: [String] = getPersonDescription(personName: person)
                                contextText += genSparqlAndCtext[1] + " "
                                behindTheScenesSparqlText += genSparqlAndCtext[0] + "\n"
                            }
                        }
                        if entities.1.count > 0 {
                            for place in entities.1 {
                                sliderValue += 11
                                let genSparqlAndCtext: [String] = getPlaceDescription(placeName: place)
                                contextText += genSparqlAndCtext[1] + " "
                                behindTheScenesSparqlText += genSparqlAndCtext[0] + "\n"
                            }
                        }
                        if entities.2.count > 0 {
                            for org in entities.2 {
                                sliderValue += 11
                                print("=== ORG entity:", org)
                                let genSparqlAndCtext: [String] = getOrganizationDescription(organizationName: org)
                                contextText += genSparqlAndCtext[1] + " "
                                behindTheScenesSparqlText += genSparqlAndCtext[0] + "\n"

                            }
                        }
                        // Use BERT Transformer deep learning model:
                        let answer = bert.findAnswer(for: entityQuery, in: String(contextText.prefix(283)))
                        outputText = String(answer)
                    } else {
                        // ENTITY and REALTIONSHIP QUERIES:
                        bb.set_text(originalText: "and " + entityQuery.replacingOccurrences(of: ",", with: " and "))
                        self.sliderValue += 27
                        self.choices = bb.query_to_choices(behindTheScenesSparqlText: &behindTheScenesSparqlText)
                        if self.choices.count > 0 {
                            self.sheetIsShowing = true
                        } else {
                            outputText = "NO RESULTS FOR QUERY"
                            //behindTheScenesSparqlText = ""
                        }
                    }
                    self.sliderValue = 100
                    
                }) {
                    HStack(spacing: 8) {
                        Text("Process query").font(.headline).foregroundColor(.black)
                    }
                    //.padding(.horizontal, 16)
                    //.background(Color(red: 0, green: 0, blue: 0.7))
                    //.background(Capsule().strokeBorder(Color.white, lineWidth: 3.25))
                }.padding(5)
                .background(Color(red: 0, green: 0, blue: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous)) //: BUTTON
                #if os(macOS)
                ScrollView(showsIndicators: true) {
                    TextEditor(text: $outputText).cornerRadius(10)
                }.padding()
                #else
                ScrollView(showsIndicators: true) {
                    TextEditor(text: $outputText).cornerRadius(10)
                        .frame(minHeight: screenHeight * 0.75, maxHeight: .infinity)
                }.padding()
                #endif
                
                GroupBox() {
                    DisclosureGroup("Behind the scenes SPARQL queries") {
                        ScrollView(showsIndicators: true) {
                            TextEditor(text: $behindTheScenesSparqlText).cornerRadius(10)//.padding()
                        }.background(Color.white)
                    }
                }
                HStack {
                    ProgressView("Working…", value: sliderValue, total: 100.0).padding()
                }.opacity(showProgress ? 1 : 0)
            } //: VSTACK
        } //: ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.7, green: 0.7, blue: 0.94), Color.init(red: 0.3, green: 0.3, blue: 0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .sheet(isPresented: $sheetIsShowing) {
            SheetView(isVisible: self.$sheetIsShowing, generatedSparql: $behindTheScenesSparqlText, enteredText: $entityQuery, choices: self.$choices, outputText: self.$outputText, selectedEntityUris: selectedEntityUris, sliderValue: sliderValue, result: self.$result)
        }
    }}
