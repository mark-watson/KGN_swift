//  NLPutils.swift
//  KGN
//
//  Copyright © 2021 Mark Watson. All rights reserved.
//

import Foundation
import NaturalLanguage

public func getPersonDescription(personName: String) -> [String] {
    let sparql = get_SPARQL_for_finding_URIs_for_PERSON_NAME(nameString: personName)
    let results = sparqlDbPedia(query: sparql)
    return [sparql, results.map { ($0["comment"] ?? $0["abstract"] ?? "") }.joined(separator: " . ")]
}


public func getPlaceDescription(placeName: String) -> [String] {
    let sparql = get_SPARQL_for_finding_URIs_for_PLACE_NAME(placeString: placeName)
    let results = sparqlDbPedia(query: sparql)
    return [sparql, results.map { ($0["comment"] ?? $0["abstract"] ?? "") }.joined(separator: " . ")]
}

public func getOrganizationDescription(organizationName: String) -> [String] {
    let sparql = get_SPARQL_for_finding_URIs_for_ORGANIZATION_NAME(orgString: organizationName)
    let results = sparqlDbPedia(query: sparql)
    print("=== getOrganizationDescription results =\n", results)
    return [sparql, results.map { ($0["comment"] ?? $0["abstract"] ?? "") }.joined(separator: " . ")]
}

let tokenizer = NLTokenizer(unit: .word)
let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

let tokenizerOptions: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

public func getEntities(text: String) -> [(String, String)] {
    var words: [(String, String)] = []
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
        let word = (text as NSString).substring(with: tokenRange)
        let tagType = tag?.rawValue ?? "unkown"
        if tagType != "unkown" && tagType != "OtherWord" {
            words.append((word, tagType))
        }
    }
    return words
}

public func tokenizeText(text: String) -> [String] {
    var tokens: [String] = []
    tokenizer.string = text
    tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
        tokens.append(String(text[tokenRange]))
        return true
    }
    return tokens
}

let entityTagger = NLTagger(tagSchemes: [.nameType])
let entityOptions: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
let entityTagTypess: [NLTag] = [.personalName, .placeName, .organizationName]

public func getAllEntities(text: String) -> ([String],[String],[String]) {
    var words: [(String, String)] = []
    var people: [String] = []
    var places: [String] = []
    var organizations: [String] = []
    entityTagger.string = text
    entityTagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: entityOptions) { tag, tokenRange in
        if let tag = tag, entityTagTypess.contains(tag) {
            let word = String(text[tokenRange])
            if tag.rawValue == "PersonalName" {
                people.append(word)
            } else if tag.rawValue == "PlaceName" {
                places.append(word)
            } else if tag.rawValue == "OrganizationName" {
                organizations.append(word)
            } else {
                print("\nERROR in getEntities(): unkown entity type: |\(tag.rawValue)|")
            }
            words.append((word, tag.rawValue))
        }
        return true
    }
    return (people, places, organizations)
}

func splitLongStrings(_ s: String, limit: Int) -> String {
    var ret: [String] = []
    let tokens = s.split(separator: " ")
    var subLine = ""
    for token in tokens {
        if subLine.count > limit {
            ret.append(subLine)
            subLine = ""
        } else {
            subLine = subLine + " " + token
        }
    }
    if subLine.count > 0 {
        ret.append(subLine)
    }
    return ret.joined(separator: "\n")
}

