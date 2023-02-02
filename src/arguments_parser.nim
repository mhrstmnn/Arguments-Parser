## A parser for command line arguments

import std/[os, tables, strutils]

type
  Arguments = object
    input*, keys*, shortKeys*: seq[string]
    values*: Table[string, seq[string]]

  Argument = enum
    input, long, short

proc newArguments*(
  input, keys, shortKeys = newSeq[string](),
  values = initTable[string, seq[string]]()
): Arguments = Arguments(
  input: input,
  keys: keys,
  shortKeys: shortKeys,
  values: values
)

proc removeQuotes(value: var string) =
  for quote in ['"', '\'']:
    value.removePrefix(quote)
    value.removeSuffix(quote)

proc addKeyAndValue(
  key: string,
  value: var string,
  keys: var seq[string],
  values: var Table[string, seq[string]]
) =
  if key != "" and not (key in keys):
    keys.add(key)
    values[key] = newSeq[string]()
  if value != "":
    removeQuotes(value)
    values[key].add(value)

proc checkArgument(
  prefix, argument: string,
  firstElement: bool,
  keys: var seq[string],
  values: var Table[string, seq[string]]
) =
  if argument.contains(":"):
    let splitArgument = argument.split(":")
    var key = splitArgument[0]
    key.removePrefix(prefix)
    var value = splitArgument[1]
    addKeyAndValue(key, value, keys, values)
  elif argument.contains("="):
    let splitArgument = argument.split("=")
    var key = splitArgument[0]
    key.removePrefix(prefix)
    var value = splitArgument[1]
    addKeyAndValue(key, value, keys, values)
  else:
    if firstElement:
      var key = argument
      key.removePrefix(prefix)
      var value = ""
      addKeyAndValue(key, value, keys, values)
    else:
      var value = argument
      removeQuotes(value)
      values[keys[^1]].add(value)

proc parseInput*(arguments: seq[string] = commandLineParams()): Arguments =
  ## Parses all command line arguments into one arguments object
  var argumentType = input
  for argument in arguments:
    if argument == "--" or argument == "-": continue
    var firstElement = true
    if argument.startsWith("--"): argumentType = long
    elif argument.startsWith("-"): argumentType = short
    else: firstElement = false
    case argumentType
      of input:
        var value = argument
        removeQuotes(value)
        result.input.add(value)
      of long: checkArgument("--", argument, firstElement, result.keys, result.values)
      of short: checkArgument("-", argument, firstElement, result.shortKeys, result.values)
