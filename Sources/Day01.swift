struct Day01: AdventDay {
  var data: String

  enum Direction {
    case left
    case right
  }

  struct Rotation {
    let direction: Direction
    let distance: Int
  }

  var rotations: [Rotation] {
    data.split(separator: "\n").compactMap { line in
      let trimmed = line.trimmingCharacters(in: .whitespaces)
      guard !trimmed.isEmpty else { return nil }
      let direction: Direction = trimmed.first == "L" ? .left : .right
      guard let distance = Int(trimmed.dropFirst()) else { return nil }
      return Rotation(direction: direction, distance: distance)
    }
  }

  func part1() async throws -> Any {
    rotations
      .reduce((position: 50, count: 0)) { state, rotation in
        let offset = rotation.direction == .left ? -rotation.distance : rotation.distance
        let newPosition = (state.position + offset).wrappedToDialRange()
        return (newPosition, state.count + (newPosition == 0 ? 1 : 0))
      }
      .count
  }

  func part2() async throws -> Any {
    rotations
      .reduce((position: 50, count: 0)) { state, rotation in
        let offset = rotation.direction == .left ? -rotation.distance : rotation.distance
        let newPosition = (state.position + offset).wrappedToDialRange()

        let crossings: Int
        switch rotation.direction {
        case .left:
          if state.position == 0 {
            crossings = rotation.distance / 100
          } else if rotation.distance >= state.position {
            crossings = (rotation.distance - state.position) / 100 + 1
          } else {
            crossings = 0
          }
        case .right:
          crossings = (state.position + rotation.distance) / 100 - state.position / 100
        }

        return (newPosition, state.count + crossings)
      }
      .count
  }
}

extension Int {
  fileprivate func wrappedToDialRange() -> Int {
    (self % 100 + 100) % 100
  }
}
