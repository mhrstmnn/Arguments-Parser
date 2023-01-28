# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, Arguments_Parser
import std/tables

test "one key":
  check parseInput(@["--foo"]) == Arguments(
      input: @[],
      shortKeys: @[],
      keys: @["foo"],
      values: initTable[string, seq[string]]()
    )

test "one key with one value":
  check parseInput(@["--foo:bar"]) == Arguments(
      input: @[],
      shortKeys: @[],
      keys: @["foo"],
      values: {"foo": @["bar"]}.toTable
    )
  check parseInput(@["--foo=bar"]) == Arguments(
      input: @[],
      shortKeys: @[],
      keys: @["foo"],
      values: {"foo": @["bar"]}.toTable
    )
  check parseInput(@["--foo", "bar"]) == Arguments(
      input: @[],
      shortKeys: @[],
      keys: @["foo"],
      values: {"foo": @["bar"]}.toTable
    )

test "one key with two value":
  check parseInput(@["--foo", "foo", "bar"]) == Arguments(
      input: @[],
      shortKeys: @[],
      keys: @["foo"],
      values: {"foo": @["foo", "bar"]}.toTable
    )

test "one short key":
  check parseInput(@["-f"]) == Arguments(
      input: @[],
      shortKeys: @["f"],
      keys: @[],
      values: initTable[string, seq[string]]()
    )

test "multiple short keys":
  check parseInput(@["-abcd"]) == Arguments(
      input: @[],
      shortKeys: @["a", "b", "c", "d"],
      keys: @[],
      values: initTable[string, seq[string]]()
    )

test "one short key with one value":
  check parseInput(@["-f:bar"]) == Arguments(
      input: @[],
      shortKeys: @["f"],
      keys: @[],
      values: {"f": @["bar"]}.toTable
    )
  check parseInput(@["-f=bar"]) == Arguments(
      input: @[],
      shortKeys: @["f"],
      keys: @[],
      values: {"f": @["bar"]}.toTable
    )
  check parseInput(@["-f", "bar"]) == Arguments(
      input: @[],
      shortKeys: @["f"],
      keys: @[],
      values: {"f": @["bar"]}.toTable
    )

test "one short key with two values":
  check parseInput(@["-f", "foo", "bar"]) == Arguments(
      input: @[],
      shortKeys: @["f"],
      keys: @[],
      values: {"f": @["foo", "bar"]}.toTable
    )

test "one word input":
  check parseInput(@["foo"]) == Arguments(
      input: @["foo"],
      shortKeys: @[],
      keys: @[],
      values: initTable[string, seq[string]]()
    )

test "two words input":
  check parseInput(@["foo", "bar"]) == Arguments(
      input: @["foo", "bar"],
      shortKeys: @[],
      keys: @[],
      values: initTable[string, seq[string]]()
    )
