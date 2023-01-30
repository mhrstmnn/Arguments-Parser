# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, Arguments_Parser, std/tables

test "one key":
  check parseInput(@["--foo"]) == newArguments(
    keys = @["foo"],
    values = {"foo": newSeq[string]()}.toTable
  )

test "one key with one value":
  check parseInput(@["--foo:bar"]) == newArguments(
    keys = @["foo"],
    values = {"foo": @["bar"]}.toTable
  )
  check parseInput(@["--foo=bar"]) == newArguments(
    keys = @["foo"],
    values = {"foo": @["bar"]}.toTable
  )
  check parseInput(@["--foo", "bar"]) == newArguments(
    keys = @["foo"],
    values = {"foo": @["bar"]}.toTable
  )

test "one key with two value":
  check parseInput(@["--foo", "foo", "bar"]) == newArguments(
    keys = @["foo"],
    values = {"foo": @["foo", "bar"]}.toTable
  )

test "one short key":
  check parseInput(@["-f"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": newSeq[string]()}.toTable
  )
  check parseInput(@["-fb"]) == newArguments(
    shortKeys = @["fb"],
    values = {"fb": newSeq[string]()}.toTable
  )

test "multiple short keys":
  check parseInput(@["-a", "-b", "-c", "-d"]) == newArguments(
    shortKeys = @["a", "b", "c", "d"],
    values = {
      "a": newSeq[string](), "b": newSeq[string](),
      "c": newSeq[string](), "d": newSeq[string]()
    }.toTable
  )

test "one short key with one value":
  check parseInput(@["-f:bar"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": @["bar"]}.toTable
  )
  check parseInput(@["-f=bar"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": @["bar"]}.toTable
  )
  check parseInput(@["-f", "bar"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": @["bar"]}.toTable
  )

test "one short key with two values":
  check parseInput(@["-f", "foo", "bar"]) == newArguments(
    shortKeys = @["f"],
    values = {"f": @["foo", "bar"]}.toTable
  )

test "one word input":
  check parseInput(@["foo"]) == newArguments(input = @["foo"])

test "two words input":
  check parseInput(@["foo", "bar"]) == newArguments(input = @["foo", "bar"])
