//
//  GenerateSparql.swift
//  KGNbeta1
//
//  Created by Mark Watson on 2/28/20.
//  Copyright © 2020 Mark Watson. All rights reserved.
//

import Foundation

public func uri_to_display_text(uri: String) -> String {
    return uri.replacingOccurrences(of: "http://dbpedia.org/resource/Category/", with: "").replacingOccurrences(of: "http://dbpedia.org/resource/", with: "").replacingOccurrences(of: "_", with: " ")
}

public func get_SPARQL_for_finding_URIs_for_PERSON_NAME(nameString: String) -> String {
    return
        "# SPARQL to find all URIs for name: " + nameString + "\nSELECT DISTINCT ?person_uri ?comment {\n" +
        "  ?person_uri <http://xmlns.com/foaf/0.1/name> \"" + nameString + "\"@en .\n" +
        "  OPTIONAL { ?person_uri <http://www.w3.org/2000/01/rdf-schema#comment>\n" +
        "     ?comment . FILTER (lang(?comment) = 'en') } .\n" +
        "} LIMIT 10\n"
}

public func get_SPARQL_for_PERSON_URI(aURI: String) -> String {
    return
        "# <" + aURI + ">\nSELECT DISTINCT ?comment (GROUP_CONCAT(DISTINCT ?birthplace; SEPARATOR=' | ') AS ?birthplace)\n  (GROUP_CONCAT(DISTINCT ?almamater; SEPARATOR=' | ') AS ?almamater) (GROUP_CONCAT(DISTINCT ?spouse; SEPARATOR=' | ') AS ?spouse) {\n" +
        "  <" + aURI + "> <http://www.w3.org/2000/01/rdf-schema#comment>  ?comment . FILTER  (lang(?comment) = 'en') .\n" +
        "  OPTIONAL { <" + aURI + "> <http://dbpedia.org/ontology/birthPlace> ?birthplace } .\n" +
        "  OPTIONAL { <" + aURI + "> <http://dbpedia.org/ontology/almaMater> ?almamater } .\n" +
        "  OPTIONAL { <" + aURI + "> <http://dbpedia.org/ontology/spouse> ?spouse } .\n" +
        "} LIMIT 5\n"
}

public func get_display_text_for_PERSON_URI(personURI: String) -> [String] {
    var ret: String = "\(uri_to_display_text(uri: personURI))\n\n"
    let person_details_sparql = get_SPARQL_for_PERSON_URI(aURI: personURI)
    let person_details = sparqlDbPedia(query: person_details_sparql)
    
    for pd in person_details {
        //let comment = pd["comment"]
        ret.append("\(pd["comment"] ?? "")\n\n")
        let subject_uris = pd["subject_uris"]
        let uri_list: [String] = subject_uris?.components(separatedBy: " | ") ?? []
        //ret.append("<ul>\n")
        for u in uri_list {
            let subject = uri_to_display_text(uri: u)
            ret.append("\(subject)\n") }
        //ret.append("</ul>\n")
        if let spouse = pd["spouse"] {
            if spouse.count > 0 {
                ret.append("Spouse: \(uri_to_display_text(uri: spouse))\n") } }
        if let almamater = pd["almamater"] {
            if almamater.count > 0 {
                ret.append("Almamater: \(uri_to_display_text(uri: almamater))\n") } }
        if let birthplace = pd["birthplace"] {
            if birthplace.count > 0 {
                ret.append("Birthplace: \(uri_to_display_text(uri: birthplace))\n") } }
    }
    return ["# SPARQL for a specific person:\n" + person_details_sparql, ret]
}

//     "  ?place_uri <http://xmlns.com/foaf/0.1/name> \"" + placeString + "\"@en .\n" +

public func get_SPARQL_for_finding_URIs_for_PLACE_NAME(placeString: String) -> String {
    return
        "# " + placeString + "\nSELECT DISTINCT ?place_uri ?comment {\n" +
        "  ?place_uri rdfs:label \"" + placeString + "\"@en .\n" +
        "  ?place_uri <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://schema.org/Place> .\n" +
        "  OPTIONAL { ?place_uri <http://www.w3.org/2000/01/rdf-schema#comment>\n" +
        "     ?comment . FILTER (lang(?comment) = 'en') } .\n" +
        "} LIMIT 10\n"
}

public func get_SPARQL_for_PLACE_URI(aURI: String) -> String {
    return
        "# <" + aURI + ">\nSELECT DISTINCT ?comment (GROUP_CONCAT(DISTINCT ?subject_uris; SEPARATOR=' | ') AS ?subject_uris) {\n" +
        "  <" + aURI + "> <http://www.w3.org/2000/01/rdf-schema#comment>  ?comment . FILTER  (lang(?comment) = 'en') .\n" +
        "  OPTIONAL { <" + aURI + "> <http://purl.org/dc/terms/subject> ?subject_uris } .\n" +
        "} LIMIT 5\n"
}

public func get_HTML_for_place_URI(placeURI: String) -> String {
    var ret: String = "<h2>" + placeURI + "</h2>\n"
    let place_details_sparql = get_SPARQL_for_PLACE_URI(aURI: placeURI)
    let place_details = sparqlDbPedia(query: place_details_sparql)
    
    for pd in place_details {
        //let comment = pd["comment"]
        ret.append("<p><strong>\(pd["comment"] ?? "")</strong></p>\n")
        let subject_uris = pd["subject_uris"]
        let uri_list: [String] = subject_uris?.components(separatedBy: " | ") ?? []
        ret.append("<ul>\n")
        for u in uri_list {
            let subject = u.replacingOccurrences(of: "http://dbpedia.org/resource/Category:", with: "").replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "-", with: " ")
            ret.append("  <li>\(subject)</li>\n")
        }
        ret.append("</ul>\n")
    }
    return ret
}

public func get_SPARQL_for_finding_URIs_for_ORGANIZATION_NAME(orgString: String) -> String {
    return
        "# " + orgString + "\nSELECT DISTINCT ?org_uri ?comment {\n" +
        "  ?org_uri rdfs:label \"" + orgString + "\"@en .\n" +
        "  ?org_uri <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://schema.org/Organization> .\n" +
        "  OPTIONAL { ?org_uri <http://www.w3.org/2000/01/rdf-schema#comment>\n" +
        "     ?comment . FILTER (lang(?comment) = 'en') } .\n" +
        "} LIMIT 2\n"
}
//
