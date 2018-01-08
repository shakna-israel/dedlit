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

---

## Why?

dedlit was thrown together in 5mins, because I felt the existing tools were overly restrictive, or overly complex, and am writing a series of documents on implementing a language in Lua.

I don't expect it is appropriate for any other purpose, but considering how simple it is, you may find some.
