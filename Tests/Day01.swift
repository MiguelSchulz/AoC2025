import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    // The dial should land on 0 exactly 3 times:
    // After R48 (52 + 48 = 100 -> 0)
    // After L55 (55 - 55 = 0)
    // After L99 (99 - 99 = 0)
    try await #expect(String(describing: challenge.part1()) == "3")
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData)
    // With the new method, we count all times the dial passes through 0:
    // L68: passes through 0 once (during rotation)
    // R48: ends at 0 (counted)
    // R60: passes through 0 once (during rotation)
    // L55: ends at 0 (counted)
    // L99: ends at 0 (counted)
    // L82: passes through 0 once (during rotation)
    // Total: 6
    try await #expect(String(describing: challenge.part2()) == "6")
  }
}
