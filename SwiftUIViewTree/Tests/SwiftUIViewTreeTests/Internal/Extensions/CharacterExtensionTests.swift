@testable import SwiftUIViewTree
import Testing

@Suite(.viewTree())
struct CharacterExtensionTests {

    @Test(
        //GIVEN
        arguments: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    )
    func isHexDigit_numbers_areHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["a", "b", "c", "d", "e", "f"]
    )
    func isHexDigit_lowercaseLetters_areHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["A", "B", "C", "D", "E", "F"]
    )
    func isHexDigit_uppercaseLetters_areHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["g", "h", "z", "G", "H", "Z"]
    )
    func isHexDigit_lettersOutsideHex_areNotHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }

    @Test(
        //GIVEN
        arguments: ["x", "X", " ", "-", "+", "/", ":", "@", "[", "]", "{", "}", "_"]
    )
    func isHexDigit_symbols_areNotHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }

    @Test(
        //GIVEN
        arguments: ["\n", "\t"]
    )
    func isHexDigit_whitespace_areNotHex(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }
}
