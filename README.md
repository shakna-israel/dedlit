# dedlit

A dead simple literate Lua

---

## Install

    luarocks install dedlit

---

## Usage

dedlit takes a given file, and executes any code found fenced in triple backticks:

    ```print("Hello, World")```
    
It ignores the rest, which allows you to use whatever syntax you feel like.

It also supplies four functions, to allow controlling the lexer:

* `pushsyntax(x)` - Allows you to push a new pattern to match against, instead of the default triple backtick.

* `popsyntax()` - Allows you to remove the top-level pattern to match against. If all patterns are removed, things return to the default.

* `syntax()` - Returns the current lexer pattern as a string.

* `issyntax(x)` - Returns a boolean if `x` matches the current lexer pattern.

---

## Why?

dedlit was thrown together in 5mins, because I felt the existing tools were overly restrictive, or overly complex, and am writing a series of documents on implementing a language in Lua.

I don't expect it is appropriate for any other purpose, but considering how simple it is, you may find some.

The lexer-modifying extensions were added after spending far too long in the land of TeX. A modifying lexer allows you to work around a lot of issues of a too-simple approach, without diving too far into complexity. It allows you to make things as complicated as *you* require, and no further.

---

## License

See [LICENSE](LICENSE) for terms and conditions.
