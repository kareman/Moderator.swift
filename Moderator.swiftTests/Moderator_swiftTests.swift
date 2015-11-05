//
// Moderator_swiftTests.swift
// Moderator.swiftTests
//
// Created by Kåre Morstøl on 03.11.15.
// Copyright © 2015 NotTooBad Software. All rights reserved.
//

import XCTest
@testable import Moderator

extension Array {
	var toStrings: [String] {
		return map {String($0)}
	}
}

extension String.CharacterView: CustomDebugStringConvertible {
	public var debugDescription: String {
		return String(self)
	}
}

class Moderator_Tests: XCTestCase {

	func testPreprocessor () {
		let arguments = ["lskdfj", "--verbose", "--this=that", "-b", "-lkj"]

		let result = ArgumentParser().preprocess(arguments)
		XCTAssertEqual(result.toStrings, ["lskdfj", "--verbose", "--this", "that", "-b", "-lkj"])
	}

	func testParsingBoolShortName () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "-a", "-lkj", "string"]
		let parsed = parser.add(BoolArgument(short: "a", long: "alpha"))
		let unparsed = parser.add(BoolArgument(short: "b", long: "bravo"))

		do {
			try parser.parse(arguments)
			XCTAssertEqual(parsed.value, true)
			XCTAssertEqual(unparsed.value, false)
		} catch {
			XCTFail(String(error))
		}
	}

	func testParsingBoolLongName () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "--alpha", "-lkj", "string"]
		let parsed = parser.add(BoolArgument(short: "a", long: "alpha"))
		let unparsed = parser.add(BoolArgument(short: "b", long: "bravo"))

		do {
			try parser.parse(arguments)
			XCTAssertEqual(parsed.value, true)
			XCTAssertEqual(unparsed.value, false)
		} catch {
			XCTFail(String(error))
		}
	}

	func testParsingStringArgumentShortName () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "-a", "alphasvalue", "string"]
		let parsed = parser.add(StringArgument(short: "a", long: "alpha"))
		let unparsed = parser.add(StringArgument(short: "b", long: "bravo"))

		do {
			try parser.parse(arguments)
			XCTAssertEqual(parsed.value, "alphasvalue")
			XCTAssertNil(unparsed.value)
		} catch {
			XCTFail(String(error))
		}
	}

	func testParsingStringArgumentLongName () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "--alpha", "alphasvalue", "string"]
		let parsed = parser.add(StringArgument(short: "a", long: "alpha"))
		let unparsed = parser.add(StringArgument(short: "b", long: "bravo"))

		do {
			try parser.parse(arguments)
			XCTAssertEqual(parsed.value, "alphasvalue")
			XCTAssertNil(unparsed.value)
		} catch {
			XCTFail(String(error))
		}
	}

	func testParsingStringArgumentWithEqualSign () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "--alpha=alphasvalue", "string"]
		let parsed = parser.add(StringArgument(short: "a", long: "alpha"))

		do {
			try parser.parse(arguments)
			XCTAssertEqual(parsed.value, "alphasvalue")
		} catch {
			XCTFail(String(error))
		}
	}

	func testParsingStringArgumentWithMissingValueThrows () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "--alpha"]
		let parsed = parser.add(StringArgument(short: "a", long: "alpha"))

		do {
			try parser.parse(arguments)
			XCTFail("Should have thrown error about missing value")
		} catch {
			XCTAssertNil(parsed.value)
			XCTAssertTrue(String(error).containsString("Missing value"))
		}
	}

	func testParsingStringArgumentWithFlagValueThrows () {
		let parser = ArgumentParser()
		let arguments = ["--verbose", "-a", "-b"]
		let parsed = parser.add(StringArgument(short: "a", long: "alpha"))

		do {
			try parser.parse(arguments)
			XCTFail("Should have thrown error about incorrect value")
		} catch {
			XCTAssertNil(parsed.value)
			XCTAssertTrue(String(error).containsString("Illegal value"))
		}
	}

	func testStrictParsingThrowsErrorOnUnknownArguments () {
		let parser = ArgumentParser()
		let arguments = ["--alpha", "-c"]
		parser.add(BoolArgument(short: "a", long: "alpha", helptext: "The leader."))
		parser.add(BoolArgument(short: "b", long: "bravo", helptext: "Well done!"))

		do {
			try parser.parse(arguments, strict: true)
			XCTFail("Should have thrown error about incorrect value")
		} catch {
			XCTAssertTrue(String(error).containsString("Unknown arguments"))
			XCTAssertTrue(String(error).containsString("The leader."), "Error should have contained usage text.")
			XCTAssertTrue(String(error).containsString("Well done!"), "Error should have contained usage text.")
		}
	}

	func testStrictParsing () {
		let parser = ArgumentParser()
		let arguments = ["--alpha", "-b"]
		parser.add(BoolArgument(short: "a", long: "alpha"))
		parser.add(BoolArgument(short: "b", long: "bravo"))

		do {
			try parser.parse(arguments, strict: true)
		} catch {
			XCTFail("Should not throw error " + String(error))
		}
	}

	func testUsageText () {
		let parser = ArgumentParser()
		parser.add(BoolArgument(short: "a", long: "alpha", helptext: "The leader."))
		parser.add(StringArgument(short: "b", long: "bravo", helptext: "Well done!"))
		parser.add(BoolArgument(short: "x", long: "hasnohelptext"))

		let usagetext = parser.usagetext
		XCTAssert(usagetext.containsString("alpha"))
		XCTAssert(usagetext.containsString("The leader"))
		XCTAssert(usagetext.containsString("bravo"))
		XCTAssert(usagetext.containsString("Well done"))

		XCTAssertFalse(parser.usagetext.containsString("hasnohelptext"))
	}
}
