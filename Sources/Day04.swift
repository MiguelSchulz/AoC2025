struct Day04: AdventDay {
  var data: String

  var grid: [[Character]] {
    data.split(separator: "\n").map { Array($0) }
  }

  func part1() async throws -> Any {
    let grid = self.grid  // Cache the grid once!
    let rows = grid.count
    guard rows > 0 else { return 0 }
    let cols = grid[0].count

    let directions = [
      (-1, -1), (-1, 0), (-1, 1),  // top row
      (0, -1), (0, 1),  // middle row (left and right)
      (1, -1), (1, 0), (1, 1),  // bottom row
    ]

    var accessibleCount = 0

    for row in 0..<rows {
      for col in 0..<cols {
        guard grid[row][col] == "@" else { continue }

        let neighborCount = directions.filter { dy, dx in
          let newRow = row + dy
          let newCol = col + dx
          return newRow >= 0 && newRow < rows
            && newCol >= 0 && newCol < cols
            && grid[newRow][newCol] == "@"
        }.count

        if neighborCount < 4 {
          accessibleCount += 1
        }
      }
    }

    return accessibleCount
  }

  func part2() async throws -> Any {
    var currentGrid = grid
    var totalRemoved = 0

    while true {
      let accessible = findAccessibleRolls(in: currentGrid)
      if accessible.isEmpty {
        break
      }

      // Remove accessible rolls
      for (row, col) in accessible {
        currentGrid[row][col] = "."
      }

      totalRemoved += accessible.count
    }

    return totalRemoved
  }

  func findAccessibleRolls(in grid: [[Character]]) -> [(Int, Int)] {
    let rows = grid.count
    guard rows > 0 else { return [] }
    let cols = grid[0].count

    let directions = [
      (-1, -1), (-1, 0), (-1, 1),
      (0, -1), (0, 1),
      (1, -1), (1, 0), (1, 1),
    ]

    var accessible: [(Int, Int)] = []

    for row in 0..<rows {
      for col in 0..<cols {
        guard grid[row][col] == "@" else { continue }

        let neighborCount = directions.filter { dy, dx in
          let newRow = row + dy
          let newCol = col + dx
          return newRow >= 0 && newRow < rows
            && newCol >= 0 && newCol < cols
            && grid[newRow][newCol] == "@"
        }.count

        if neighborCount < 4 {
          accessible.append((row, col))
        }
      }
    }

    return accessible
  }
}