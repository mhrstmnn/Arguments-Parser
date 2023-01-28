## A parser for command line arguments

import std/[os, tables]

type Arguments* = object
  input*: seq[string]
  shortKeys*: seq[string]
  keys*: seq[string]
  values*: Table[string, seq[string]]

proc parseInput*(arguments = commandLineParams()): Arguments =
  ## Parses all command line arguments into one arguments object
  echo arguments
