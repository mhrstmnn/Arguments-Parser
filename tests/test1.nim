# Make sure the test filenames start with the letter 't'.
# To run the tests, simply execute `nimble test`.

import unittest, arguments_parser, std/[tables, algorithm]

test "one key":
  check parseInput(@["--foo"]) == newArguments(
    keys = @["foo"],
    flags = @["foo"],
    values = {"foo": newSeq[string]()}.toTable
  )

test "one key with one value":
  let arguments = newArguments(
    keys = @["foo"],
    values = {"foo": @["bar"]}.toTable
  )
  check parseInput(@["--foo:bar"]) == arguments
  check parseInput(@["--foo=bar"]) == arguments
  check parseInput(@["--foo", "bar"]) == arguments

test "one key with two values":
  check parseInput(@["--foo", "foo", "bar"]) == newArguments(
    keys = @["foo"],
    values = {"foo": @["foo", "bar"]}.toTable
  )

test "one short key":
  check parseInput(@["-f"]) == newArguments(
    shortKeys = @["f"],
    flags = @["f"],
    values = {"f": newSeq[string]()}.toTable
  )
  check parseInput(@["-fb"]) == newArguments(
    shortKeys = @["fb"],
    flags = @["fb"],
    values = {"fb": newSeq[string]()}.toTable
  )

test "multiple short keys":
  var
    arguments = parseInput(@["-a", "-b", "-c", "-d"])
    argumentsFlags = arguments.flags
  check arguments.shortKeys == @["a", "b", "c", "d"]
  argumentsFlags.sort()
  check argumentsFlags == @["a", "b", "c", "d"]
  check arguments.values == {
    "a": newSeq[string](),
    "b": newSeq[string](),
    "c": newSeq[string](),
    "d": newSeq[string]()
  }.toTable

test "one short key with one value":
  let arguments = newArguments(
    shortKeys = @["f"],
    values = {"f": @["bar"]}.toTable
  )
  check parseInput(@["-f:bar"]) == arguments
  check parseInput(@["-f=bar"]) == arguments
  check parseInput(@["-f", "bar"]) == arguments

test "one short key with two values":
  check parseInput(@["-f", "foo", "bar"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": @["foo", "bar"]}.toTable
  )

test "one word input":
  check parseInput(@["foo"]) == newArguments(input = @["foo"])

test "two words input":
  check parseInput(@["foo", "bar"]) == newArguments(input = @["foo", "bar"])
