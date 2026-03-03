# Custom bash functions

# Update node/npm/npx symlinks in ~/.local/bin to current nvm version
update-node-links() {
    local node_path=$(which node 2>/dev/null)
    if [[ -z "$node_path" ]]; then
        echo "Error: node not found. Is nvm loaded?"
        return 1
    fi

    local bin_dir=$(dirname "$node_path")
    mkdir -p ~/.local/bin

    ln -sf "$bin_dir/node" ~/.local/bin/node
    ln -sf "$bin_dir/npm" ~/.local/bin/npm
    ln -sf "$bin_dir/npx" ~/.local/bin/npx

    echo "Updated symlinks to: $bin_dir"
    ls -la ~/.local/bin/{node,npm,npx}
}
