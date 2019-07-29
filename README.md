# dune-simple-setup

## make .merlin

```bash
$ dune exe bin/main.exe
5                  
2
9
```

## ocamlmerlin single locate

```bash
$ ocamlmerlin single locate -position '6:27' -filename bin/main.ml  < bin/main.ml | jq .
{
  "class": "return",
  "value": {
    "file": "/path/to/repo/lib/math.mli",
    "pos": {
      "line": 2,
      "col": 0
    }
  },
  "notifications": [],
  "timing": {
    "clock": 2,
    "cpu": 2,
    "query": 1,
    "pp": 0,
    "reader": 0,
    "ppx": 0,
    "typer": 1,
    "error": 0
  }
}
```

## reason-language-server definition

```
$ reason-language-server -v definition "$PWD" bin/main.ml 6 27 2>&1| grep -v opam | grep -v Std
# Reason Langauge Server - checking individual files to ensure they load & process correctly
Found a `dune` file at /path/to/repo/bin
]] Making a new jbuilder package at /path/to/repo/bin
=== Project root: /Users/watiko/repo/watiko/ocaml-scrap
Get ocaml stdlib dirs
New dune process
[MerlinFile]: Local 2, Deps 1 for /path/to/repo/bin/.merlin
[MerlinFile]: ## Build dir /path/to/repo/bin/../_build/default/lib/.mylib.objs/byte
[MerlinFile]: Build file for Mylib__Math : /path/to/repo/bin/../_build/default/lib/.mylib.objs/byte/mylib__Math.cmti
[MerlinFile]: Build file for Mylib__Math : /path/to/repo/bin/../_build/default/lib/.mylib.objs/byte/mylib__Math.cmi
[MerlinFile]: Build file for Mylib : /path/to/repo/bin/../_build/default/lib/.mylib.objs/byte/mylib.cmt
[MerlinFile]: Build file for Mylib : /path/to/repo/bin/../_build/default/lib/.mylib.objs/byte/mylib.cmi
[MerlinFile]: ## Build dir /path/to/repo/bin/../_build/default/bin/.main.eobjs/byte
[MerlinFile]: Build file for Main : /path/to/repo/bin/../_build/default/bin/.main.eobjs/byte/main.cmi
[MerlinFile]: Build file for Main : /path/to/repo/bin/../_build/default/bin/.main.eobjs/byte/main.cmt
[MerlinFile]:  > prefix: stdlib
[MerlinFile]: For local dir /path/to/repo/bin/../lib
[MerlinFile]: Error: No name found for dune item
[MerlinFile]: For local dir /path/to/repo/bin
[MerlinFile]:  > module Main :: Impl(/path/to/repo/bin/../_build/default/bin/.main.eobjs/byte/main.cmt, /path/to/repo/bin/main.ml)
>>> stdout

>>> stderr

Affected files: 
Cleaning bsconfig.json
<< Replacing lastDefinitions for file:///path/to/repo/bin/main.ml
  Good: file:///path/to/repo/bin/main.ml
[ref] Global defn Mylib Math.sub : Value
No path for module Mylib
Unable to resolve a definition for /path/to/repo/bin/main.ml:6:27
  Good: file:///path/to/repo/bin/main.ml
```

## maybe solution for reason-language-server

I don't know enough dune and OCaml (Reason)...

```diff
diff --git a/util/JbuildFile.re b/util/JbuildFile.re
index 25d5917..927445d 100644
--- a/util/JbuildFile.re
+++ b/util/JbuildFile.re
@@ -53,6 +53,7 @@ let includeRecursive = items => {
 
 let getLibsAndBinaries = jbuildConfig => {
   jbuildConfig->Belt.List.keepMap(item => switch item {
+    | `List([`Ident("library"), ...[`List([`Ident(_), _])] as library])
     | `List([`Ident("library"), `List(library)])
     | `List([`Ident("library"), ...library]) => {
       let (public, private) = getNamedIdent(library)
```