local M = {}

local ts_utils = require "nvim-treesitter.ts_utils"

function M.get_toc(toc)
    local counters = { { i = 0 } }
    local previous_level = 1
    local text = { "# " .. M.toc_header }
    for _, v in pairs(toc) do
        local line = ""
        local number = 0
        if v.level > previous_level then
            for _ = previous_level, v.level - 1 do
                table.insert(counters, { i = 0 })
            end
        elseif v.level < previous_level then
            for _ = v.level, previous_level - 1 do
                table.remove(counters, #counters)
            end
        end
        previous_level = v.level
        counters[#counters].i = counters[#counters].i + 1
        number = counters[#counters].i
        for _ = 2, v.level do
            line = line .. "   "
        end
        local link = v.title:gsub("%s+", "-"):lower()
        line = line .. number .. ". " .. "[" .. v.title .. "](#" .. link .. ")"

        table.insert(text, line)
    end
    return text
end

function M.generate_md_toc()
    local toc = {}
    local cursor_node = ts_utils.get_node_at_cursor()
    local query = vim.treesitter.query.parse(
        "markdown",
        [[
              [
                (atx_heading heading_content: (_) @title)
                (atx_h1_marker) @type
                (atx_h2_marker) @type
                (atx_h3_marker) @type
                (atx_h4_marker) @type
                (atx_h5_marker) @type
                (atx_h6_marker) @type
              ]
            ]]
    )
    local table_entry = {}
    for id, node, metadata in query:iter_captures(cursor_node:root(), 0) do
        local name = query.captures[id] -- name of the capture in the query

        -- typically useful info about the node:
        local type = node:type() -- type of the captured node
        local text = vim.treesitter.get_node_text(node, 0)

        if name == "type" then
            if type == "atx_h1_marker" then table_entry.level = 1 end
            if type == "atx_h2_marker" then table_entry.level = 2 end
            if type == "atx_h3_marker" then table_entry.level = 3 end
            if type == "atx_h4_marker" then table_entry.level = 4 end
            if type == "atx_h5_marker" then table_entry.level = 5 end
            if type == "atx_h6_marker" then table_entry.level = 6 end
        end
        if name == "title" and text ~= M.toc_header then
            table_entry.title = (text:gsub("^%s*(.-)%s*$", "%1"))
            table.insert(toc, table_entry)
            table_entry = {}
        end
    end

    return M.get_toc(toc)
end

function M.get_toc_position()
    local query = vim.treesitter.query.parse(
        "markdown",
        " [ (atx_heading heading_content: (_) @title (#eq? @title \"" .. M.toc_header .. "\")) ]"
    )
    local cursor_node = ts_utils.get_node_at_cursor()
    for id, node, metadata in query:iter_captures(cursor_node:root(), 0) do
        local name = query.captures[id] -- name of the capture in the query
        local text = vim.treesitter.get_node_text(node, 0)

        if name == "title" and text == M.toc_header then
            -- find the parent section
            local section = node:parent()

            while section:parent() ~= nil and section:type() ~= "section" do
                section = section:parent()
            end
            local startRow, startCol, endRow, endCol = section:range(false)
            return startRow, startCol, endRow, endCol
        end
        break
    end
    return nil
end

function M.setup(config)
    if config ~= nil then
        if config.toc_header ~= nil then
            M.toc_header = config.toc_header
        end
    end
    vim.api.nvim_create_autocmd(
        "BufEnter",
        {
            pattern = "*.md,*.markdown",
            callback = function()
                -- create command to generate/update table of contents for markdown files at current cursor position
                vim.api.nvim_buf_create_user_command(0, 'TOC',
                    function()
                        local toc = M.generate_md_toc()
                        local startRow, _, endRow, _ = M.get_toc_position()
                        if startRow ~= nil then
                            vim.api.nvim_buf_set_lines(0, startRow, endRow-1, true, toc)
                        else
                            local line = vim.api.nvim_win_get_cursor(0)[1]
                            vim.api.nvim_buf_set_lines(0, line - 1, line, true, toc)
                        end
                    end,
                    { nargs = 0 }
                )
            end
        }
    )
end

return M
