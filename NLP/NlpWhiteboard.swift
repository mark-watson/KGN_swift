//
//  NlpWhiteboard.swift
//  KGN
//
//  Copyright © 2021 Mark Watson. All rights reserved.
//

public struct NlpWhiteboard {

    var originalText: String = ""
    var people: [String] = []
    var places: [String] = []
    var organizations: [String] = []
    var sparql: String = ""

    init() { }

    mutating func set_text(originalText: String) {
        self.originalText = originalText
        let (people, places, organizations) = getAllEntities(text:  originalText)
        self.people = people; self.places = places; self.organizations = organizations
    }
    
    mutating func query_to_choices(behindTheScenesSparqlText: inout String) -> [[[String]]] { // return inner: [comment, uri]
        var ret: Set<[[String]]> = []
        if people.count > 0 {
            for i in 0...(people.count - 1) {
                self.sparql = get_SPARQL_for_finding_URIs_for_PERSON_NAME(nameString: people[i])
                behindTheScenesSparqlText += self.sparql
                let results = sparqlDbPedia(query: self.sparql)
                if results.count > 0 {
                    ret.insert( results.map { [($0["comment"] ?? ""), ($0["person_uri"] ?? "")] })
                }
            }
        }
        if organizations.count > 0 {
            for i in 0...(organizations.count - 1) {
                self.sparql = get_SPARQL_for_finding_URIs_for_ORGANIZATION_NAME(orgString: organizations[i])
                behindTheScenesSparqlText += self.sparql
                let results = sparqlDbPedia(query: self.sparql)
                if results.count > 0 {
                    ret.insert(results.map { [($0["comment"] ?? ""), ($0["org_uri"] ?? "")] })
                }
            }
        }
        if places.count > 0 {
            for i in 0...(places.count - 1) {
                self.sparql = get_SPARQL_for_finding_URIs_for_PLACE_NAME(placeString: places[i])
                behindTheScenesSparqlText += self.sparql
                let results = sparqlDbPedia(query: self.sparql)
                if results.count > 0 {
                    ret.insert( results.map { [($0["comment"] ?? ""), ($0["place_uri"] ?? "")] })
                }
            }
        }
        //print("\n\n+++++++ ret:\n", ret, "\n\n")
        return Array(ret)
    }
}
