# nvim-toc
Generate table of contents for markdown files

# Installation
```vim
Plug 'richardbizik/nvim-toc'
```

# Configuration
Setup default command `:TOC` with `require('nvim-toc').setup({})`.  
Or you can setup your own command by calling `require('nvim-toc').generate_md_toc()` and handling the result yourself. The result of the command is a table containing lines of table of contents.
Command will generate a table of contents of an opened markdown file on the current line.

## Config options
```lua
require("nvim-toc").setup({
  toc_header = "Table of Contents"
})
```

# Example
```markdown
# Table of contents
1. [Table of contents](#table-of-contents)
2. [h1](#h1)
3. [h1](#h1)
   1. [h2](#h2)
      1. [h3](#h3)
         1. [h4](#h4)
            1. [h5](#h5)
               1. [h6](#h6)
               2. [h6](#h6)
               3. [h6](#h6)
         2. [h4](#h4)
            1. [h5](#h5)
   2. [h2](#h2)
   3. [h2](#h2)
   4. [h2](#h2)
4. [h1](#h1)

# h1
# h1
## h2
### h3
#### h4
##### h5
###### h6
###### h6
###### h6
#### h4
##### h5
## h2
## h2
## h2
# h1
```
