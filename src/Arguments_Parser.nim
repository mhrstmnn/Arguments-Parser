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
          var key = splitArgument[0]
          key.removePrefix("--")
          if not (key in result.keys):
            result.keys.add(key)
            result.values[key] = newSeq[string]()
          result.values[key].add(splitArgument[1])
        elif argument.contains("="):
          let splitArgument = argument.split("=")
          var key = splitArgument[0]
          key.removePrefix("--")
          if not (key in result.keys):
            result.keys.add(key)
            result.values[key] = newSeq[string]()
          result.values[key].add(splitArgument[1])
        else:
          if firstElement:
            var key = argument
            key.removePrefix("--")
            if not (key in result.keys):
              result.keys.add(key)
              result.values[key] = newSeq[string]()
          else:
            result.values[result.keys[^1]].add(argument)
      of short:
        if argument.contains(":"):
          let splitArgument = argument.split(":")
          var key = splitArgument[0]
          key.removePrefix("--")
          if not (key in result.shortKeys):
            result.shortKeys.add(key)
            result.values[key] = newSeq[string]()
          result.values[key].add(splitArgument[1])
        elif argument.contains("="):
          let splitArgument = argument.split("=")
          var key = splitArgument[0]
          key.removePrefix("--")
          if not (key in result.shortKeys):
            result.shortKeys.add(key)
            result.values[key] = newSeq[string]()
          result.values[key].add(splitArgument[1])
        else:
          if firstElement:
            var key = argument
            key.removePrefix("-")
            if not (key in result.shortKeys):
              result.shortKeys.add(key)
              result.values[key] = newSeq[string]()
          else:
            result.values[result.shortKeys[^1]].add(argument)

echo "Arguments: ", parseInput()
