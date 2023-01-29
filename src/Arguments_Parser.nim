## A parser for command line arguments

import std/[os, tables, strutils]

type Arguments = object
  input: seq[string]
  keys: seq[string]
  shortKeys: seq[string]
  values: Table[string, seq[string]]

proc newArguments*(
    input = newSeq[string](),
    keys = newSeq[string](),
    shortKeys = newSeq[string](),
    values = initTable[string, seq[string]]()
  ): Arguments = Arguments(
    input: input,
    keys: keys,
    shortKeys: shortKeys,
    values: values
  )

proc parseInput*(arguments: seq[string] = commandLineParams()): Arguments =
  ## Parses all command line arguments into one arguments object

  type Argument = enum
    input, long, short

  var argumentType = input

  for argument in arguments:
    if argument.startsWith("--"):
      argumentType = long
    elif argument.startsWith("-"):
      argumentType = short

    case argumentType
      of input:
        result.input.add(argument)
      of long:
        if argument.contains(":"):
          result.keys.add(argument.split(":")[0])
          result.values[argument.split(":")[0]].add(argument.split(":")[1])
        elif argument.contains("="):
          result.keys.add(argument.split("=")[0])
          result.values[argument.split("=")[0]].add(argument.split("=")[1])
        else:
          result.values[result.keys[^1]].add(argument)
      of short:
        if argument.contains(":"):
          result.shortKeys.add(argument.split(":")[0])
          result.values[argument.split(":")[0]].add(argument.split(":")[1])
        elif argument.contains("="):
          result.shortKeys.add(argument.split("=")[0])
          result.values[argument.split("=")[0]].add(argument.split("=")[1])
        else:
          result.values[result.shortKeys[^1]].add(argument)

echo "Arguments: ", parseInput()
