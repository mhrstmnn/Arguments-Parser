import unittest, arguments_parser, std/tables

test "two words input and one key":
  check parseInput(@["foo", "bar", "--foo"]) == newArguments(
    input = @["foo", "bar"],
    keys = @["foo"],
    values = {"foo": newSeq[string]()}.toTable
  )

test "empty keys":
  check parseInput(@["-", "--"]) == newArguments()
  check parseInput(@["foo", "bar", "-", "--"]) == newArguments(input = @["foo", "bar"])
  check parseInput(@["-", "foo", "--", "bar"]) == newArguments(input = @["foo", "bar"])
  check parseInput(@["-", "--", "foo", "bar"]) == newArguments(input = @["foo", "bar"])

test "write output to file":
  check parseInput(@["main.c", "-o", "main"]) == newArguments(
    input = @["main.c"],
    shortKeys = @["o"],
    values = {"o": @["main"]}.toTable
  )
