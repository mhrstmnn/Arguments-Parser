## A parser for command line arguments

import std/[os, tables, strutils, options]

type
  Arguments* = object
    input*, keys*, shortKeys*, flags*: seq[string]
    values*: Table[string, seq[string]]

  Argument = enum
    input, long, short

proc newArguments*(
  input, keys, shortKeys, flags = newSeq[string](),
  values = initTable[string, seq[string]]()
): Arguments = Arguments(
  input: input,
  keys: keys,
  shortKeys: shortKeys,
  flags: flags,
  values: values
)

proc removeQuotes(value: string): string =
  result = value
  for quote in ['"', '\'']:
    if result.startsWith(quote) and result.endsWith(quote):
      result.removePrefix(quote)
      result.removeSuffix(quote)
      break

proc addKeyAndValue(
  key: string,
  value: Option[string],
  resultKeys: var seq[string],
  resultValues: var Table[string, seq[string]]
) =
  if key != "" and not (key in resultKeys):
    resultKeys.add(key)
    resultValues[key] = newSeq[string]()
  if value.isSome:
    resultValues[key].add(removeQuotes(value.get))

proc splitArgument(
  prefix, argument, sep: string,
  resultKeys: var seq[string],
  resultValues: var Table[string, seq[string]]
) =
  let arguments = argument.split(sep)
  var key = arguments[0]
  key.removePrefix(prefix)
  let value = some(arguments[1])
  addKeyAndValue(key, value, resultKeys, resultValues)

proc addArgument(
  prefix, argument: string,
  firstElement: bool,
  resultKeys: var seq[string],
  resultValues: var Table[string, seq[string]]
) =
  if argument.contains(":"): splitArgument(prefix, argument, ":", resultKeys, resultValues)
  elif argument.contains("="): splitArgument(prefix, argument, "=", resultKeys, resultValues)
  else:
    if firstElement:
      var key = argument
      key.removePrefix(prefix)
      let value = none(string)
      addKeyAndValue(key, value, resultKeys, resultValues)
    else:
      resultValues[resultKeys[^1]].add(removeQuotes(argument))

proc addFlags(resultValues: Table[string, seq[string]], resultFlags: var seq[string]) =
  for key in resultValues.keys:
    if resultValues[key].len == 0: resultFlags.add(key)

proc parseInput*(arguments = commandLineParams()): Arguments =
  ## Parses all command line arguments into one arguments object
  var argumentType = input
  for argument in arguments:
    if argument == "--" or argument == "-": continue

    var firstElement = true
    if argument.startsWith("--"): argumentType = long
    elif argument.startsWith("-"): argumentType = short
    else: firstElement = false

    case argumentType
    of input: result.input.add(removeQuotes(argument))
    of long: addArgument("--", argument, firstElement, result.keys, result.values)
    of short: addArgument("-", argument, firstElement, result.shortKeys, result.values)

  addFlags(result.values, result.flags)
