import unittest, arguments_parser, std/tables

test "two words input and one key":
  check parseInput(@["foo", "bar", "--foo"]) == newArguments(
    input = @["foo", "bar"],
    keys = @["foo"],
    flags = @["foo"],
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

test "example command: write output to file":
  check parseInput(@["gcc", "main.c", "-o", "main"]) == newArguments(
    input = @["gcc", "main.c"],
    shortKeys = @["o"],
    values = {"o": @["main"]}.toTable
  )

test "example command: write output to file with optimization":
  check parseInput(@["gcc", "main.c", "-o", "main", "-O2"]) == newArguments(
    input = @["gcc", "main.c"],
    shortKeys = @["o", "O2"],
    flags = @["O2"],
    values = {"o": @["main"], "O2": newSeq[string]()}.toTable
  )

test "one key with two words as value in quotes":
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

test "four words input, one in quotes":
  let arguments1 = newArguments(input = @["foo bar", "foo bar"])
  check parseInput(@["\"foo bar\"", "foo bar"]) == arguments1
  check parseInput(@["'foo bar'", "foo bar"]) == arguments1
  let arguments2 = newArguments(input = @["foo bar", "foo bar"])
  check parseInput(@["foo bar", "\"foo bar\""]) == arguments2
  check parseInput(@["foo bar", "'foo bar'"]) == arguments2

test "two words input and one quote":
  check parseInput(@["\"foo", "bar"]) == newArguments(input = @["\"foo", "bar"])
  check parseInput(@["foo", "bar\""]) == newArguments(input = @["foo", "bar\""])
  check parseInput(@["'foo", "bar"]) == newArguments(input = @["'foo", "bar"])
  check parseInput(@["foo", "bar'"]) == newArguments(input = @["foo", "bar'"])
