;; extends

(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#any-of? @_path "__raw" "extraConfigLua" "extraConfigLuaPre" "extraConfigLuaPost"))

(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: (apply_expression
    argument: [
      (string_expression
        ((string_fragment) @injection.content
          (#set! injection.language "lua")))
      (indented_string_expression
        ((string_fragment) @injection.content
          (#set! injection.language "lua")))
    ])
  (#any-of? @_path "__raw" "extraConfigLua" "extraConfigLuaPre" "extraConfigLuaPost"))

(apply_expression
  function: (_) @_func
  argument: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#match? @_func "(^|\\.)mkRaw$"))

(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "vim")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "vim")))
  ]
  (#any-of? @_path "extraConfigVim" "extraConfigVimPre" "extraConfigVimPost"))

(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: (apply_expression
    argument: [
      (string_expression
        ((string_fragment) @injection.content
          (#set! injection.language "vim")))
      (indented_string_expression
        ((string_fragment) @injection.content
          (#set! injection.language "vim")))
    ])
  (#any-of? @_path "extraConfigVim" "extraConfigVimPre" "extraConfigVimPost"))

(binding
  attrpath: (attrpath
    (identifier) @namespace
    (identifier) @name)
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#eq? @namespace "luaConfig")
  (#any-of? @name "pre" "post" "content"))

(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: [
    (attrset_expression
      (binding_set
        (binding
          attrpath: (attrpath
            (identifier) @_nested_path)
          expression: [
            (string_expression
              ((string_fragment) @injection.content
                (#set! injection.language "lua")))
            (indented_string_expression
              ((string_fragment) @injection.content
                (#set! injection.language "lua")))
          ]
          (#any-of? @_nested_path "pre" "post" "content"))))
  ]
  (#eq? @_path "luaConfig"))
