import unittest, Arguments_Parser, std/tables

test "two words input and one key":
  check parseInput(@["foo", "bar", "--foo"]) == newArguments(
      input = @["foo", "bar"],
      keys = @["foo"]
    )
