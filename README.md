# dedlit

A dead simple literate Lua

---

[![builds.sr.ht status](https://builds.sr.ht/~shakna/dedlit.svg)](https://builds.sr.ht/~shakna/dedlit?)

## Install

    luarocks install dedlit

---

## Usage

dedlit takes a given file, and executes any code found fenced in triple backticks:

    ```print("Hello, World")```
    
It ignores the rest, which allows you to use whatever syntax you feel like.

The environment is preserved between evaluation, but each code section is expected to be complete.
An error will be thrown if this proves not to be the case.

It also supplies some functions, to allow controlling the lexer:

* Default pattern: The default pattern, referenced below, cannot be directly accessed. However, it is `"```(.-)```"`.

* `pushsyntax([x])`

    * Allows you to push a new pattern to match against, instead of the default.

    * If no pattern is supplied, the default pattern is pushed to the end of the stack.

    * The pattern may be a Lua pattern string.

    * The pattern may be a function, optionally taking a filename, and a string index.

        * This will be called each time, before matching.

        * e.g. `function(filename, position) return "```(.-)```" end`

    * Returns the new pattern.

* `popsyntax()`

    * Allows you to remove the top-level pattern to match against.

    * If all patterns are removed, the default pattern is pushed to the stack.

    * Returns the popped pattern.

* `syntax()`

    * Returns the currently active lexer pattern.

        * This may be a string, or a function.

* `issyntax(x)`

    * Returns a boolean if `x` matches the current lexer pattern.

    * If the lexer pattern is a function, it is *not* evaluated being comparison.

## Library Usage

If the `arg` table is not in the environment, then dedlit can be `require`d as a library.

    `require "dedlit"`

It exposes:

* `dedlit.version`

    * A table, representing the version of the library.

* `dedlit.popsyntax`

    * The same as given in the CLI.

* `dedlit.pushsyntax`

    * The same as given in the CLI.

* `dedlit.syntax`

    * The same as given in the CLI.

* `dedlit.issyntax`

    * The same as given in the CLI.

* `dedlit.get_line(string, start)`

    * Given the start index, returns the number of newlines before that position in the string.

* `dedlit.parse(str, filename, position)`

    * Parses *and* evaluates a given string, using the filename as metadata, and starting at `position` or `1` as the string index.

* `dedlit.eval(exp_tbl, line, filename)`

    * Given a table of string blocks to evaluate, and line number and filename as metadata, runs the blocks in the expected environment.

* `dedlit.litfile(filename)`

    * Runs the parser and evaluator over a file associated with the filename, and returns the result.

---

## Why?

dedlit was thrown together in 5mins, because I felt the existing tools were overly restrictive, or overly complex, and am writing a series of documents on implementing a language in Lua.

I don't expect it is appropriate for any other purpose, but considering how simple it is, you may find some.

The lexer-modifying extensions were added after spending far too long in the land of TeX. A modifying lexer allows you to work around a lot of issues of a too-simple approach, without diving too far into complexity. It allows you to make things as complicated as *you* require, and no further.

---

## License

See [LICENSE](LICENSE) for terms and conditions.
