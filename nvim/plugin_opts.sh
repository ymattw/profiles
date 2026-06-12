#!/bin/bash
# Script for inspecting plugin opts.

if [ -z "$1" ]; then
    echo "Usage: $0 <plugin-name>"
    echo
    echo "All enabled plugins:"
    echo
    nvim --headless -c "lua
        for name, _ in pairs(require('lazy.core.config').plugins) do
            print(name)
        end
        print()
    " -c q | sort
    exit 1
fi

PLUGIN_NAME="$1"

# Run nvim headlessly to extract and print the merged opts
nvim --headless -c "lua
    local name = '$PLUGIN_NAME'
    local p = require('lazy.core.config').plugins[name]
    if not p then
        print('Error: Plugin ' .. name .. ' not found.')
        os.exit(1)
    end
    local o = require('lazy.core.plugin').values(p, 'opts', false)
    print(vim.inspect(o))
    print()
" -c q
