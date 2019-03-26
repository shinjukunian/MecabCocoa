//
//  NSAttributedString+FormattedHTML.swift
//  DocX
//
//  Created by Morten Bertz on 2019/03/14.
//  Copyright © 2019 telethon k.k. All rights reserved.
//

import Foundation

#if os(iOS)
fileprivate typealias NSFont=UIFont
#endif

enum HTMLEncodingErrors:Error{
    case failedEncoding
}


extension NSAttributedString{
    
    @objc public func annotatedRubyHTML() throws -> String{
        let data = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.html])
        guard var htmlString=String(data: data, encoding: .utf8) else{
            throw HTMLEncodingErrors.failedEncoding
        }
        
        let furiganaAttribute=NSAttributedString.Key(kCTRubyAnnotationAttributeName as String)
        var searchRange:Range<String.Index> = htmlString.startIndex ..< htmlString.endIndex
        self.enumerateAttributes(in: NSRange(location: 0, length: self.length), options: [], using: {attributes, affectedRange, _ in
            if let rubyAttribute=attributes[furiganaAttribute], let font=attributes[.font] as? NSFont{
                let rubyRef=rubyAttribute as! CTRubyAnnotation // dont know how to avoid this cast
                if let rubyText=rubyRef.rubyText{
                    let rubySizeFactor=CTRubyAnnotationGetSizeFactor(rubyRef)
                    let original=self.attributedSubstring(from: affectedRange).string
                    let fontSize=String(format: "%.1f", font.pointSize * rubySizeFactor)
                    if let tokenRange=htmlString.range(of: original, options: [], range: searchRange, locale: nil){
                        let rtArguments="style='font-size:\(fontSize)pt;layout-grid-mode:line'"
                        let htmlRuby="<ruby>\(original)<rt \(rtArguments)>\(rubyText)</rt></ruby>"
                        htmlString=htmlString.replacingCharacters(in: tokenRange, with: htmlRuby)
                        searchRange = htmlString.index(tokenRange.lowerBound, offsetBy: htmlRuby.count) ..< htmlString.endIndex
                        
                    }
                    
                    
                }
            }
        })
        
        
        return htmlString
    }
    
}


extension CTRubyAnnotation{
    var rubyText:String?{
        let positions:[CTRubyPosition]=[.before,.after,.inline,.interCharacter]
        let text=positions.map({CTRubyAnnotationGetTextForPosition(self, $0)}).compactMap({$0}).first
        return text as String?
        
    }
}
