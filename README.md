# nvim-toc
Generate table of contents for markdown files

# Installation
```vim
Plug 'richardbizik/nvim-toc'
```

# Commands
- :TOC - creates an ordered list table of contents
- :TOCList - creates an unordered list table of contents

# Configuration
Setup default command `:TOC` and `:TOCList` with `require('nvim-toc').setup({})`. The default commands will try to find existing table of contents based on `toc_header` configuration or they will create a new one on cursor position if it does not exist. 
You can setup your own command by calling `require('nvim-toc').generate_md_toc(format)` and handling the result yourself.  
Format options are currently list or numbered
```lua
require('nvim-toc').generate_md_toc("list")
require('nvim-toc').generate_md_toc("numbered")
```
The result of the command is a table containing lines of table of contents.
Command will generate a table of contents of an opened markdown file on the current line.

## Config options
```lua
require("nvim-toc").setup({
  toc_header = "Table of Contents"
})
```

# Example
```markdown
# Table of contents (:TOC)
1. [h1](#h1)
2. [h1](#h1)
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
3. [h1](#h1)

# Table of contents (:TOCList)
- [h1](#h1)
- [h1](#h1)
  - [h2](#h2)
    - [h3](#h3)
      - [h4](#h4)
        - [h5](#h5)
          - [h6](#h6)
          - [h6](#h6)
          - [h6](#h6)
      - [h4](#h4)
        - [h5](#h5)
  - [h2](#h2)
  - [h2](#h2)
  - [h2](#h2)
- [h1](#h1)

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
