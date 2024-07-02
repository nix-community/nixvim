;; extends

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @lua)
    (indented_string_expression (string_fragment) @lua)
  ]
  (#match? @_path "^extraConfigLua(Pre|Post)?$"))

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @vim)
    (indented_string_expression (string_fragment) @vim)
  ]
  (#match? @_path "^extraConfigVim(Pre|Post)?$"))
