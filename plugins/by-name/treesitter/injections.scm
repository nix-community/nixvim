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
  (#match? @_path "(^(extraConfigLua(Pre|Post)?|__raw))$"))

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
  (#match? @_func "(^|\\.)mkRaw$")
  (#set! injection.combined))

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
  (#match? @_path "(^extraConfigVim(Pre|Post)?)$"))

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
  (#match? @namespace "^luaConfig$")
  (#match? @name "^(pre|post|content)$"))

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
          (#match? @_nested_path "^(pre|post|content)$"))))
  ]
  (#match? @_path "^luaConfig$"))
