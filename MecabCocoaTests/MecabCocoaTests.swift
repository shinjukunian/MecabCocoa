//
//  MecabCocoaTests.swift
//  MecabCocoaTests
//
//  Created by Morten Bertz on 2018/09/11.
//  Copyright © 2018 Morten Bertz. All rights reserved.
//

import XCTest
import MecabCocoa

class MecabCocoaTests: XCTestCase {

    let dictionaries:[dictionaryType]=[.iOSTokenizer,.ipadic,.jumandic,.naist_jdic,.unidic]
    
    let kanji:NSString="熊"
    let hiragana:NSString="くま"
    let katakana:NSString="クマ"
    let romaji:NSString="kuma"
    
    let mixed:NSString="クマが怖い。"
    let mixedKanji:NSString="熊が怖い"
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleString() {
        let string="熊"
        let allowedReadings=["kuma","くま","クマ"]
        
        for dict in dictionaries{
            let result=MecabTokenizer().parseToNode(with: string, with: dict)
            XCTAssertNotNil(result)
            guard let firstToken=result.first else{XCTFail("No Token Found for \(dict.description)");return}
            XCTAssertTrue(result.count == 1, "Too many tokens found for \(dict.description)")
            XCTAssertEqual(firstToken.surface, string)
            XCTAssertNotNil(firstToken.features)
            let reading=firstToken.reading()
            XCTAssertNotNil(reading)
            XCTAssertTrue(allowedReadings.contains(reading ?? ""))
            
            let nsString=string as NSString
            let nsReadings=nsString.readings(for: dict)
            XCTAssertTrue(nsReadings.count == 1, "Too many tokens found for \(dict.description)")
            XCTAssertNotNil(nsReadings.first)
            XCTAssertTrue(allowedReadings.contains(nsReadings.first ?? ""))
            
            let furigana=nsString.furiganaReplacements(for: dict)
            XCTAssertTrue(furigana.count == 1, "Too many tokens found for \(dict.description)")
            XCTAssertNotNil(furigana.first)
            let range=furigana.first?.key.rangeValue
            XCTAssertNotNil(range)
            XCTAssertEqual(range ?? NSMakeRange(0, 0), NSMakeRange(0, 1))
            XCTAssertEqual(furigana.first?.value ?? "", "くま")
            
            
        }
    }
    
    func testScript(){
        XCTAssertEqual(kanji.scriptType(), .kanji)
        XCTAssertEqual(hiragana.scriptType(), .hiragana)
        XCTAssertEqual(katakana.scriptType(), .katakana)
        XCTAssertEqual(romaji.scriptType(), [])
        XCTAssertEqual(mixed.scriptType(), [.kanji,.katakana,.hiragana])
    }
    
    
    func testTransliteration() {
        XCTAssertEqual(hiragana.transliteratingHiraganaToKatakana(), "クマ")
        XCTAssertEqual(katakana.transliteratingKatakanaToHiragana(), "くま")
        XCTAssertEqual(romaji.transliteratingRomajiToHiragana(), "くま")
        for dict in dictionaries{
            XCTAssertEqual(mixedKanji.hiraganaString(with: dict), "くまがこわい")
            XCTAssertEqual(mixedKanji.romajiString(with: dict), "kuma ga kowai","conversion failed for \(dict.description)")
            
        }
        
    }
    
    func testUtility() {
        let characters=Array(mixedKanji.kanjiCharacters.array) as? [String]
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters ?? [String](), ["熊","怖"], "Detecting Kanji Characters Failed")
    }
    
    func testFurigana() {
        for dict in dictionaries{
            for transliteration in [transliterationType.hiragana,.katakana,.romaji]{
                let furigana=mixedKanji.furiganaReplacements(for: dict, transliteration: transliteration)
                XCTAssertNotNil(furigana)
                XCTAssertTrue(furigana.count == 2)
            }
            
        }
    }
    
    
    func testFormattedExport(){
        let string = """
        ウィキ（Wiki）とは、不特定多数のユーザーが共同してウェブブラウザから直接コンテンツを編集するウェブサイトである。一般的なウィキにおいては、コンテンツはマークアップ言語によって記述されるか、リッチテキストエディタによって編集される[1]。
        ウィキはウィキソフトウェア（ウィキエンジンとも呼ばれる）上で動作する。ウィキソフトウェアはコンテンツ管理システムの一種であるが、サイト所有者や特定のユーザーによってコンテンツが作られるわけではないという点において、ブログなど他のコンテンツ管理システムとは異なる。またウィキには固まったサイト構造というものはなく、サイトユーザーのニーズに沿って様々にサイト構造を作り上げることが可能であり、そうした点でも他のシステムとは異なっている[2]。
"""

        let tokens=(string as NSString).furiganaReplacements(for: .iOSTokenizer)
        let att=NSMutableAttributedString(string: string)
        let furiganaAttribute=NSAttributedString.Key(kCTRubyAnnotationAttributeName as String)
        for token in tokens{
            let ruby=CTRubyAnnotationCreateWithAttributes(.auto, .auto, .before, token.value as CFString, [:] as CFDictionary)
            att.addAttribute(furiganaAttribute, value: ruby, range: token.key.rangeValue)
        }
        let html=try! att.annotatedRubyHTML()
        XCTAssert(html.isEmpty == false)
        
        
        
    }
    
    
    
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension dictionaryType:CustomStringConvertible{
    public var description: String {
        switch self {
        case .iOSTokenizer:
            return "iosTokenizer"
        case .ipadic:
            return "IPADIC"
        case .jumandic:
            return "jumandic"
        case .naist_jdic:
            return "NAIST_JDic"
        case .unidic:
            return "Unidic"
        }
    }
    
    
}
