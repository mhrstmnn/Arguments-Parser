## A parser for command line arguments

import std/[os, tables, strutils]

type
  Arguments = object
    input: seq[string]
    keys: seq[string]
    shortKeys: seq[string]
    values: Table[string, seq[string]]

  Argument = enum
    input, long, short

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

  var argumentType = input

  for argument in arguments:
    echo argument

    var firstElement = false

    if argument.startsWith("--"):
      argumentType = long
      firstElement = true
    elif argument.startsWith("-"):
      argumentType = short
      firstElement = true

    case argumentType
      of input:
        result.input.add(argument)
      of long:
        if argument.contains(":"):
          let splitArgument = argument.split(":")
          result.keys.add(splitArgument[0])
          result.values[splitArgument[0]].add(splitArgument[1])
        elif argument.contains("="):
          let splitArgument = argument.split("=")
          result.keys.add(splitArgument[0])
          result.values[splitArgument[0]].add(splitArgument[1])
        else:
          if firstElement:
            result.keys.add(argument)
          else:
            result.values[result.keys[^1]].add(argument)
      of short:
        if argument.contains(":"):
          let splitArgument = argument.split(":")
          result.shortKeys.add(splitArgument[0])
          result.values[splitArgument[0]].add(splitArgument[1])
        elif argument.contains("="):
          let splitArgument = argument.split("=")
          result.shortKeys.add(splitArgument[0])
          result.values[splitArgument[0]].add(splitArgument[1])
        else:
          if firstElement:
            result.shortKeys.add(argument)
          else:
            result.values[result.shortKeys[^1]].add(argument)

echo "Arguments: ", parseInput()
