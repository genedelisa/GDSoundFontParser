import XCTest
@testable import GDSoundFontParser

final class GDSoundFontParserTests: XCTestCase {
    
    func testFreeFontPresets() {
        let parser = GDSoundFontParser()
        let sf: SoundFont
        
        guard let fileURL = Bundle.module.url(forResource: "FreeFont", withExtension: "sf2") else {
            XCTFail("Could not load FreeFont.sf2")
            return
        }
        
        do {
            sf = try parser.parse(fileURL: fileURL)
            
            let presets = sf.getPresets()

            // actual, expected
            XCTAssertEqual(presets.count, 235, "the number of presets is correct")
            
            for p in presets {
                print("\(p.name) (\(p.bank):\(p.preset)) \(p.presetBagIndex)")
            }
            
            
        } catch {
            print("\(error.localizedDescription)")
            XCTFail("Could not parse")
        }
        
        
    }
    
    
}
