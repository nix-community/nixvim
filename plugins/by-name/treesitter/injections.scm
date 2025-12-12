;; extends

;; =============================================================================
;; Global mkRaw
;; =============================================================================
(apply_expression
  function: (_) @_func
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ]
  (#match? @_func "(^|\\.)mkRaw$")
  (#set! injection.language "lua"))

;; =============================================================================
;; LUA BINDINGS
;; Matches: extraConfigLua, __raw, extraConfigLuaPre, extraConfigLuaPost
;; =============================================================================
(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    ; Direct string assignment
    ; extraConfigLua = ''...''
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    ; Function wrappers (handles 1-3 levels of nesting)
    ; extraConfigLua = mkIf true "..."
    ; extraConfigLua = mkIf true (mkOverride 10 "...")
    ; extraConfigLua = mkIf true (mkOverride 10 (mkDefault "..."))
    (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
        (parenthesized_expression (apply_expression argument: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ]))
      ]))
    ])

    ; Lists (with or without wrapped items)
    ; extraConfigLua = mkMerge [ "..." "..." ]
    ; extraConfigLua = mkMerge [ (mkIf true "...") "..." ]
    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
      ]))
    ]))
    (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])

    ; Let expressions
    ; extraConfigLua = let x = ...; in ''...''
    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#any-of? @_path "__raw" "extraConfigLua" "extraConfigLuaPre" "extraConfigLuaPost")
  (#set! injection.language "lua"))

;; =============================================================================
;; LUA CONFIG NESTED ATTRSET
;; Handles: luaConfig = { pre = ... }
;; =============================================================================

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: (attrset_expression (binding_set (binding
    attrpath: (attrpath (identifier) @_nested)
    expression: [
      ; Direct string assignment
      ; luaConfig = { pre = ''...'' }
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)

      ; Function wrappers (handles 1-3 levels of nesting)
      ; luaConfig = { pre = mkIf true "..." }
      ; luaConfig = { pre = mkIf true (mkOverride 10 "...") }
      ; luaConfig = { pre = mkIf true (mkOverride 10 (mkDefault "...")) }
      (apply_expression argument: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
        (parenthesized_expression (apply_expression argument: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (parenthesized_expression (apply_expression argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
          ]))
        ]))
      ])

      ; Let expressions
      ; luaConfig = { pre = let x = ...; in ''...'' }
      (let_expression body: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
      ])
    ]
    (#any-of? @_nested "pre" "post" "content")
  )))
  (#eq? @_path "luaConfig")
  (#set! injection.language "lua"))

;; =============================================================================
;; LUA CONFIG DOT NOTATION
;; Handles: luaConfig.pre = ...
;; =============================================================================
(binding
  attrpath: (attrpath (identifier) @ns (identifier) @name)
  expression: [
    ; Direct string assignment
    ; luaConfig.pre = ''...''
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    ; Function wrappers (handles 1-3 levels of nesting)
    ; luaConfig.pre = mkIf true "..."
    ; luaConfig.content = mkIf true (mkOverride 10 "...")
    ; luaConfig.post = mkIf true (mkOverride 10 (mkDefault "..."))
    (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
        (parenthesized_expression (apply_expression argument: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ]))
      ]))
    ])

    ; Let expressions
    ; luaConfig.pre = let x = ...; in ''...''
    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#eq? @ns "luaConfig")
  (#any-of? @name "pre" "post" "content")
  (#set! injection.language "lua"))

;; =============================================================================
;; VIM BINDINGS
;; Handles: extraConfigVim, extraConfigVimPre, extraConfigVimPost
;; =============================================================================
(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    ; Direct string assignment
    ; extraConfigVim = ''...''
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    ; Function wrappers (handles 1-3 levels of nesting)
    ; extraConfigVim = mkIf true "..."
    ; extraConfigVim = mkIf true (mkOverride 10 "...")
    ; extraConfigVim = mkIf true (mkOverride 10 (mkDefault "..."))
    (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
        (parenthesized_expression (apply_expression argument: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ]))
      ]))
    ])

    ; Lists (with or without wrapped items)
    ; extraConfigVim = mkMerge [ "..." "..." ]
    ; extraConfigVim = mkMerge [ (mkIf true "...") "..." ]
    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
      ]))
    ]))

    ; Let expressions
    ; extraConfigVim = let x = ...; in ''...''
    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#any-of? @_path "extraConfigVim" "extraConfigVimPre" "extraConfigVimPost")
  (#set! injection.language "vim"))
