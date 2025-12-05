@testable import SwiftUIViewTree
import Testing

@Suite(.viewTree())
struct CharacterExtensionTests {

    @Test(
        //GIVEN
        arguments: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    )
    func `WHEN number THEN true`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["a", "b", "c", "d", "e", "f"]
    )
    func `WHEN a...f THEN true`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["A", "B", "C", "D", "E", "F"]
    )
    func `WHEN A...F THEN true`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == true)
    }

    @Test(
        //GIVEN
        arguments: ["g", "h", "z", "G", "H", "Z"]
    )
    func `WHEN not valid hex letters THEN false`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }

    @Test(
        //GIVEN
        arguments: ["x", "X", " ", "-", "+", "/", ":", "@", "[", "]", "{", "}", "_"]
    )
    func `WHEN not valid hex symbols THEN false`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }

    @Test(
        //GIVEN
        arguments: ["\n", "\t"]
    )
    func `WHEN whitespace THEN false`(char: Character) async throws {
        //WHEN
        let result = char.isHexDigit

        //THEN
        #expect(result == false)
    }
}
