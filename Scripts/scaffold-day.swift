#!/usr/bin/env swift

import Foundation

// MARK: - Validation

guard CommandLine.arguments.count > 1 else {
    print("❌ Error: Day number required")
    print("Usage: ./Scripts/scaffold-day.swift <day>")
    print("Example: ./Scripts/scaffold-day.swift 2")
    exit(1)
}

guard let day = Int(CommandLine.arguments[1]), day >= 1, day <= 25 else {
    print("❌ Error: Day must be between 1 and 25")
    exit(1)
}

let dayString = String(format: "%02d", day)
let fileManager = FileManager.default
let currentDirectory = fileManager.currentDirectoryPath

// MARK: - File Paths

let sourcePath = "\(currentDirectory)/Sources/Day\(dayString).swift"
let dataPath = "\(currentDirectory)/Sources/Data/Day\(dayString).txt"
let testPath = "\(currentDirectory)/Tests/Day\(dayString).swift"
let mainPath = "\(currentDirectory)/Sources/AdventOfCode.swift"

// Check if day already exists
if fileManager.fileExists(atPath: sourcePath) {
    print("⚠️  Day \(day) already exists!")
    print("Files found:")
    print("  - \(sourcePath)")
    exit(1)
}

// MARK: - Templates

let sourceTemplate = """
struct Day\(dayString): AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\\n").map(String.init)
  }

  func part1() async throws -> Any {
    return 0
  }

  func part2() async throws -> Any {
    return 0
  }
}
"""

let testTemplate = """
import Testing

@testable import AdventOfCode

struct Day\(dayString)Tests {
  let testData = \"\"\"

    \"\"\"

  @Test func testPart1() async throws {
    let challenge = Day\(dayString)(data: testData)
    try await #expect(String(describing: challenge.part1()) == "0")
  }

  @Test func testPart2() async throws {
    let challenge = Day\(dayString)(data: testData)
    try await #expect(String(describing: challenge.part2()) == "0")
  }
}
"""

// MARK: - Interactive Input

print("📝 Setting up Day \(day)...\n")

// Ask for puzzle input
print("📥 Do you want to add your puzzle input now? (y/n)")
let addInput = readLine()?.lowercased() == "y"

var puzzleInput = ""
if addInput {
    print("\n📋 Paste your puzzle input (press Ctrl+D when done):")
    print("---")
    var lines: [String] = []
    while let line = readLine() {
        lines.append(line)
    }
    puzzleInput = lines.joined(separator: "\n")
    print("---")
    print("✅ Captured \(lines.count) lines of input\n")
}

// Ask for test data
print("🧪 Do you want to add test data now? (y/n)")
let addTestData = readLine()?.lowercased() == "y"

var testDataContent = ""
var testPart1Answer = "0"
var testPart2Answer = "0"

if addTestData {
    print("\n📋 Paste your test data (press Ctrl+D when done):")
    print("---")
    var testLines: [String] = []
    while let line = readLine() {
        testLines.append(line)
    }
    testDataContent = testLines.joined(separator: "\n")
    print("---")
    print("✅ Captured \(testLines.count) lines of test data")

    print("\n🎯 Expected answer for Part 1? (press Enter to skip)")
    if let answer = readLine(), !answer.isEmpty {
        testPart1Answer = answer
    }

    print("🎯 Expected answer for Part 2? (press Enter to skip)")
    if let answer = readLine(), !answer.isEmpty {
        testPart2Answer = answer
    }
    print()
}

// Update templates with captured data
let finalTestTemplate = """
import Testing

@testable import AdventOfCode

struct Day\(dayString)Tests {
  let testData = \"\"\"
    \(testDataContent)
    \"\"\"

  @Test func testPart1() async throws {
    let challenge = Day\(dayString)(data: testData)
    try await #expect(String(describing: challenge.part1()) == "\(testPart1Answer)")
  }

  @Test func testPart2() async throws {
    let challenge = Day\(dayString)(data: testData)
    try await #expect(String(describing: challenge.part2()) == "\(testPart2Answer)")
  }
}
"""

// MARK: - Create Files

print("📝 Creating files...")

// Create source file
do {
    try sourceTemplate.write(toFile: sourcePath, atomically: true, encoding: .utf8)
    print("✅ Created \(sourcePath)")
} catch {
    print("❌ Failed to create source file: \(error)")
    exit(1)
}

// Create data file with puzzle input
do {
    try puzzleInput.write(toFile: dataPath, atomically: true, encoding: .utf8)
    print("✅ Created \(dataPath)\(addInput ? " with puzzle input" : "")")
} catch {
    print("❌ Failed to create data file: \(error)")
    exit(1)
}

// Create test file
do {
    try finalTestTemplate.write(toFile: testPath, atomically: true, encoding: .utf8)
    print("✅ Created \(testPath)\(addTestData ? " with test data" : "")")
} catch {
    print("❌ Failed to create test file: \(error)")
    exit(1)
}

// MARK: - Update AdventOfCode.swift

do {
    let mainContent = try String(contentsOfFile: mainPath, encoding: .utf8)

    // Find the allChallenges array and add new day
    let pattern = "(let allChallenges: \\[any AdventDay\\] = \\[[^\\]]*)"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
        print("⚠️  Could not create regex")
        exit(1)
    }

    let range = NSRange(mainContent.startIndex..., in: mainContent)
    guard let match = regex.firstMatch(in: mainContent, range: range) else {
        print("⚠️  Could not find allChallenges array in AdventOfCode.swift")
        print("Please manually add: Day\(dayString)(),")
        exit(0)
    }

    let matchRange = Range(match.range(at: 1), in: mainContent)!
    let arrayContent = String(mainContent[matchRange])

    // Add new day before the closing bracket
    let updatedArray = arrayContent + "\n  Day\(dayString)(),"
    let updatedContent = mainContent.replacingCharacters(in: matchRange, with: updatedArray)

    try updatedContent.write(toFile: mainPath, atomically: true, encoding: .utf8)
    print("✅ Added Day\(dayString)() to allChallenges array")
} catch {
    print("⚠️  Could not update AdventOfCode.swift: \(error)")
    print("Please manually add: Day\(dayString)(),")
}

// MARK: - Summary

print("""

🎉 Day \(day) scaffolded successfully!

Next steps:
""")

if !addInput {
    print("  1. Add puzzle input to: Sources/Data/Day\(dayString).txt")
}
if !addTestData {
    print("  \(addInput ? "1" : "2"). Add test data to: Tests/Day\(dayString).swift")
}

let stepNum = (addInput && addTestData) ? "1" : (addInput || addTestData) ? "2" : "3"
print("""
  \(stepNum). Implement solution in: Sources/Day\(dayString).swift
  \(Int(stepNum)! + 1). Run tests: swift test --filter Day\(dayString)Tests
  \(Int(stepNum)! + 2). Run solution: swift run AdventOfCode \(day)
""")
