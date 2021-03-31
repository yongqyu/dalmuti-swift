//
//  KASICaller.swift
//  dalva
//
//  Created by keith.gotkeys on 2021/03/22.
//

import SwiftUI

class API_Caller : NSObject, XMLParserDelegate {
    let key:String = "wImPmIbZrjkHkjFZbZfpaOVdBi42aw6MrQOed%2B7qiupxN9pdStAtmrpMkH6oDhI6goBaZ1BSw3CzT%2BmXwv8i3w%3D%3D"
    var tag_name:String = ""
    var moonrise:Double = -1
    
    override init() {
        super.init()
    }
    
    // private
    func get_today() -> String {
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyyMMdd"
 
        return formatter.string(from: date)
    }
    
    func get_riseset(date:String, location:String) {
        // let date = self.get_today()
        let riseset_url = "http://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getAreaRiseSetInfo?serviceKey=\(self.key)&locdate=\(date)&location=\(location)"
        
        let xmlParser = XMLParser(contentsOf: URL(string: riseset_url)!)
        xmlParser!.delegate = self
        xmlParser!.parse()
    }
    
    /*<aste>185742</aste>
     <astm>061304</astm>
     <civile>175309</civile>
     <civilm>071736</civilm>
     <latitude>3733</latitude>
     <latitudeNum>37.5500000</latitudeNum>
     <location>서울</location>
     <locdate>20150101</locdate>
     <longitude>12658</longitude>
     <longitudeNum>37.5500000</longitudeNum>
     <moonrise>142856</moonrise>
     <moonset>034057</moonset>
     <moontransit>213246</moontransit>
     <naute>182553</naute>
     <nautm>064453</nautm>
     <sunrise>074648</sunrise>
     <sunset>172357</sunset>
     <suntransit>123519</suntransit>
     */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        tag_name = elementName
    }
    
    // 태그사이의 문자열
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if tag_name == "moonrise" {
            moonrise = Double(string)!
        }
    }

}

var api = API_Caller()
let td = api.get_today()
print(api.get_riseset(date: td, location: "서울"))

