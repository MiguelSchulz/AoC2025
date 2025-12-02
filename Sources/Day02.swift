struct Day02: AdventDay {
  var data: String

  struct IDRange {
    let start: Int
    let end: Int
  }

  var ranges: [IDRange] {
    data.trimmingCharacters(in: .whitespacesAndNewlines)
      .split(separator: ",")
      .map { rangeString in
        let parts = rangeString.split(separator: "-")
        return IDRange(start: Int(parts[0])!, end: Int(parts[1])!)
      }
  }

  func isInvalidID(_ number: Int) -> Bool {
    let digits = String(number)

    guard digits.count % 2 == 0 else { return false }

    let halfLength = digits.count / 2
    let firstHalf = digits.prefix(halfLength)
    let secondHalf = digits.suffix(halfLength)

    guard firstHalf == secondHalf else { return false }
    guard firstHalf.first != "0" else { return false }

    return true
  }

  func isInvalidIDWithRepeats(_ number: Int) -> Bool {
    let digits = String(number)
    let length = digits.count

    guard length >= 2 else { return false }

    for patternLength in 1...(length / 2) {
      guard length % patternLength == 0 else { continue }

      let pattern = String(digits.prefix(patternLength))

      guard pattern.first != "0" else { continue }

      let repeatCount = length / patternLength
      let repeated = String(repeating: pattern, count: repeatCount)

      if repeated == digits {
        return true
      }
    }

    return false
  }

  func part1() async throws -> Any {
    ranges.reduce(0) { sum, range in
      let invalidIDs = (range.start...range.end).filter(isInvalidID)
      return sum + invalidIDs.reduce(0, +)
    }
  }

  func part2() async throws -> Any {
    ranges.reduce(0) { sum, range in
      let invalidIDs = (range.start...range.end).filter(isInvalidIDWithRepeats)
      return sum + invalidIDs.reduce(0, +)
    }
  }
}