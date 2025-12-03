struct Day03: AdventDay {
  var data: String

  struct BatteryPack {
    let joltageRatings: [Int]

    init(joltageString: Substring) {
      self.joltageRatings = joltageString.compactMap { Int(String($0)) }
    }

    func highestJoltageCombination(selecting count: Int) -> Int {
      guard joltageRatings.count >= count else { return 0 }

      func selectBest(remaining: Int, startIndex: Int, accumulated: Int) -> Int {
        guard remaining > 0 else { return accumulated }

        let endIndex = joltageRatings.count - remaining

        // Find max digit and its index in a single pass
        var maxDigit = joltageRatings[startIndex]
        var maxIndex = startIndex

        for i in startIndex...endIndex {
          if joltageRatings[i] > maxDigit {
            maxDigit = joltageRatings[i]
            maxIndex = i
          }
        }

        // Tail recursion: accumulate result and continue
        return selectBest(
          remaining: remaining - 1,
          startIndex: maxIndex + 1,
          accumulated: accumulated * 10 + maxDigit
        )
      }

      return selectBest(remaining: count, startIndex: 0, accumulated: 0)
    }
  }

  var entities: [BatteryPack] {
    data
      .split(separator: "\n")
      .map { BatteryPack(joltageString: $0) }
  }

  func part1() async throws -> Any {
    return entities.map { $0.highestJoltageCombination(selecting: 2) }.reduce(0, +)
  }

  func part2() async throws -> Any {
    return entities.map { $0.highestJoltageCombination(selecting: 12) }.reduce(0, +)
  }
}
