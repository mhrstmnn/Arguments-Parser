## A parser for command line arguments

import std/[os, tables, strutils]

type Arguments = object
  input: seq[string]
  shortKeys: seq[string]
  keys: seq[string]
  values: Table[string, seq[string]]

proc newArguments*(
    input = newSeq[string](),
    shortKeys = newSeq[string](),
    keys = newSeq[string](),
    values = initTable[string, seq[string]]()
  ): Arguments = Arguments(
    input: input,
    shortKeys: shortKeys,
    keys: keys,
    values: values
  )

proc parseInput*(arguments: seq[string] = commandLineParams()): Arguments =
  ## Parses all command line arguments into one arguments object

  echo arguments
  # for argument in arguments:
  #   if argument.startsWith("--") or argument.startsWith("-"):
  #     if argument.contains(":") or argument.contains("="):

  result.keys = @["foo"]

echo parseInput()
