struct Day05: AdventDay {
  var data: String

  struct IngredientRange {
    let start: Int
    let end: Int

    func contains(_ id: Int) -> Bool {
      id >= start && id <= end
    }
  }

  var parsedData: (ranges: [IngredientRange], availableIds: [Int]) {
    let sections = data.split(separator: "\n\n")

    let ranges = sections[0].split(separator: "\n").map { line -> IngredientRange in
      let parts = line.split(separator: "-")
      return IngredientRange(
        start: Int(parts[0])!,
        end: Int(parts[1])!
      )
    }

    let availableIds = sections[1].split(separator: "\n").map { Int($0)! }

    return (ranges, availableIds)
  }

  func part1() async throws -> Any {
    let (ranges, availableIds) = parsedData

    let freshCount = availableIds.filter { id in
      ranges.contains { range in range.contains(id) }
    }.count

    return freshCount
  }

  func mergeRanges(_ ranges: [IngredientRange]) -> [IngredientRange] {
    let sortedRanges = ranges.sorted { $0.start < $1.start }

    return sortedRanges.reduce(into: [IngredientRange]()) { merged, current in
      if let last = merged.last, last.end >= current.start - 1 {
        merged[merged.count - 1] = IngredientRange(
          start: last.start,
          end: max(last.end, current.end)
        )
      } else {
        merged.append(current)
      }
    }
  }

  func part2() async throws -> Any {
    let (ranges, _) = parsedData

    let mergedRanges = mergeRanges(ranges)

    let totalFreshIds = mergedRanges.reduce(0) { total, range in
      total + (range.end - range.start + 1)
    }

    return totalFreshIds
  }
}

extension Array where Element == Day05.IngredientRange {
  func merge() -> [Element] {
    self
      .sorted { $0.start < $1.start }
      .reduce(into: [Element]()) { merged, current in
        if
          let last = merged.last,
          last.end >= current.start - 1
        {
          merged[merged.count - 1] = Element(
            start: last.start,
            end: Swift.max(last.end, current.end)
          )
        } else {
          merged.append(current)
        }
      }
  }
}
