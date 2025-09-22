{
  flake.modules.homeManager.base = {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          indent_style = "space";
          indent_size = 4;
          insert_final_newline = true;
          trim_trailing_whitespace = true;
          end_of_line = "lf";
          charset = "utf-8";
        };
        # Batch files use tabs for indentation
        "*.{bat,sh}" = {
          indent_style = "tab";
        };
        # C/C++ indentation
        "*.{c,cpp,h,hpp}" = {
          indent_style = "tab";
          indent_size = 8;
        };
        # Css, Scss
        "*.{css,scss}" = {
          indent_size = 2;
        };
        "*.html" = {
          indent_size = 2;
        };
        # Go
        "{go.mod,go.sum,*.go}" = {
          indent_style = "tab";
          indent_size = 8;
        };
        # Java and related files
        "*.{java,gradle,groovy}" = {
          indent_style = "tab";
          indent_size = 4;
        };
        # Javascript, Typescript, JSX, TSX
        "*.{js,ts,jsx,tsx}" = {
          indent_size = 4;
          indent_style = "space";
        };
        "**/admin/js/vendor/**" = {
          indent_style = "ignore";
          indent_size = "ignore";
        };
        # Minified JavaScript files shouldn't be changed
        "**.min.js" = {
          indent_style = "ignore";
          insert_final_newline = false;
        };
        # The JSON files contain newlines inconsistently
        "*.json" = {
          indent_size = 2;
          insert_final_newline = false;
        };
        # Makefiles always use tabs for indentation
        "Makefile" = {
          indent_style = "tab";
          indent_size = 8;
        };
        "*.nix" = {
          indent_style = "space";
          indent_size = 2;
        };
        # PHP
        "*.php" = {
          indent_size = 4;
        };
        # Docstrings and comments use max_line_length = 79
        "*.py" = {
          max_line_length = 79;
        };
        # Ruby
        "*.{rb,gemspec}" = {
          indent_size = 2;
        };
        # Rust
        "*.rs" = {
          indent_style = "space";
          indent_space = 4;
        };
        # Haskell
        "*.hs" = {
          indent_style = "space";
          indent_space = 4;
          max_line_length = 80;
        };
        "*.txt" = {
          max_line_length = 79;
        };
        # The yaml files contain newlines inconsistently
        "*.{yaml,yml}" = {
          indent_size = 2;
          insert_final_newline = true;
        };
        "*.{yaml.tpl,yml.tpl}" = {
          indent_size = 2;
          insert_final_newline = true;
        };
        "*.ya?ml.tpl" = {
          indent_size = 2;
          insert_final_newline = true;
        };
        "*.{xml,xsd}" = {
          max_line_length = "off";
          indent_size = 2;
        };
        # Zig
        "*.zig" = {
          indent_space = 4;
          indent_style = "space";
        };
      };
    };
  };
}
