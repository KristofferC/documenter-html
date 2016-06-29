# Documenter.jl

*A documentation generator for Julia.*

A package for building documentation from docstrings and markdown files.

---

**Note**

Please read through the [Documentation](http://docs.julialang.org/en/release-0.4/manual/documentation/)
section of the main Julia manual if this is your first time using Julia's documentation system.
Once you've read through how to write documentation for your code then come back here.

---

## Package Features

- Write all your documentation in [Markdown](https://en.wikipedia.org/wiki/Markdown).
- Minimal configuration.
- Supports Julia `0.4` and `0.5-dev`.
- Doctests Julia code blocks.
- Cross references for docs and section headers.
- [``\LaTeX`` syntax](@ref latex_syntax) support.
- Checks for missing docstrings and incorrect cross references.
- Generates tables of contents and docstring indexes.
- Use `git push` to automatically build and deploy docs from Travis to GitHub Pages.

The [Package Guide](@ref) provides a tutorial explaining how to get started using Documenter.

Some examples of packages using Documenter can be found on the [Examples](@ref) page.

See the [Index](@ref main-index) for the complete list of documented functions and types.

## Manual Outline

```@contents
Pages = [
    "man/guide.md",
    "man/examples.md",
    "man/syntax.md",
    "man/doctests.md",
    "man/hosting.md",
    "man/latex.md",
]
Depth = 2
```

## Library Outline

```@contents
Pages = ["lib/public.md", "lib/internals.md"]
Depth = 2
```

## [Index](@id main-index)

### Modules

```@index
Pages = ["lib/public.md", "lib/internals.md"]
Order = [:module]
```

### Functions

```@index
Pages = ["lib/public.md", "lib/internals.md"]
Order = [:function]
```

### Types

```@index
Pages = ["lib/public.md", "lib/internals.md"]
Order = [:type]
```
