import unittest, arguments_parser, std/tables

test "two words input and one key":
  check parseInput(@["foo", "bar", "--foo"]) == newArguments(
    input = @["foo", "bar"],
    keys = @["foo"],
    values = {"foo": newSeq[string]()}.toTable
  )

test "empty keys":
  check parseInput(@["-"]) == newArguments()
  check parseInput(@["--"]) == newArguments()
  check parseInput(@["-", "--"]) == newArguments()
  check parseInput(@["--", "-"]) == newArguments()

test "two words input and empty keys":
  let arguments = newArguments(input = @["foo", "bar"])
  check parseInput(@["-", "--", "foo", "bar"]) == arguments
  check parseInput(@["-", "foo", "--", "bar"]) == arguments
  check parseInput(@["foo", "-", "--", "bar"]) == arguments
  check parseInput(@["foo", "-", "bar", "--"]) == arguments
  check parseInput(@["foo", "bar", "-", "--"]) == arguments

test "write output to file":
  check parseInput(@["main.c", "-o", "main"]) == newArguments(
    input = @["main.c"],
    shortKeys = @["o"],
    values = {"o": @["main"]}.toTable
  )

test "one key with one value in quotes":
  let arguments = newArguments(
    keys = @["foo"],
    values = {"foo": @["foo bar"]}.toTable
  )
  check parseInput(@["--foo:\"foo bar\""]) == arguments
  check parseInput(@["--foo:'foo bar'"]) == arguments
  check parseInput(@["--foo=\"foo bar\""]) == arguments
  check parseInput(@["--foo='foo bar'"]) == arguments
  check parseInput(@["--foo", "\"foo bar\""]) == arguments
  check parseInput(@["--foo", "'foo bar'"]) == arguments

test "two words input in quotes":
  let arguments = newArguments(input = @["foo bar"])
  check parseInput(@["\"foo bar\""]) == arguments
  check parseInput(@["'foo bar'"]) == arguments

test "two words input and one quote":
  check parseInput(@["\"foo bar"]) == newArguments(input = @["\"foo bar"])
  check parseInput(@["foo bar\""]) == newArguments(input = @["foo bar\""])
  check parseInput(@["'foo bar"]) == newArguments(input = @["'foo bar"])
  check parseInput(@["foo bar'"]) == newArguments(input = @["foo bar'"])
