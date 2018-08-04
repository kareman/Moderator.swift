#if swift(>=4.0)
// No Swift 4 back compat mode.
// This keeps the compiler happy.
#elseif swift(>=3.0)
extension String {
	func dropFirst(_ n: Int = 1) -> String.CharacterView {
		return self.characters.dropFirst(n)
	}

	var first: Character? {
		return self.characters.first
	}

	var count: Int {
		return self.characters.count
	}
	
	func split(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [String.CharacterView] {
		return self.characters.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences) 
	}
}
#endif
