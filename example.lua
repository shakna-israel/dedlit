This is an example literate Lua file.

It is dead simple... On the surface.

```
print("Hello, World!")
```

And we can keep going:

```
print("Again!")
```

And now, the fun part. You can access the current lexer pattern with the `syntax` command:

```
print(syntax())
```

The lexer allows you to push and pop extra syntaxes.
Allowing you to temporarily shift forward and backward,
whilst always returning to the default.

This means we can push a new syntax pattern:

```
pushsyntax("##(.-)##")
```

And then we can immediately make use of it. The language has changed to accommodate us:

##
popsyntax()
##

And then once we've popped the syntax, the original is reinstated:

```
print("Back to normal!")
```
