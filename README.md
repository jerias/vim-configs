# Vim Configuration

Personal vim configuration optimized for FPGA development (Verilog/SystemVerilog) and general software engineering.

## Overview

This configuration provides a productive vim environment with:
- Modern plugin management via vim-plug
- Enhanced file navigation and buffer management
- Git integration and visual indicators
- Syntax highlighting for Verilog/SystemVerilog
- Customized statusline and color scheme

**Credits:** Originally based on configurations from [Amir Salihefendic's vimrc](https://github.com/amix/vimrc)

---

## Plugin Manager

**[vim-plug](https://github.com/junegunn/vim-plug)** - Fast, parallel plugin manager

### Managing Plugins

```vim
:PlugInstall    " Install configured plugins
:PlugUpdate     " Update all plugins
:PlugClean      " Remove unlisted plugins
:PlugStatus     " Check plugin status
```

---

## Installed Plugins

### File Navigation
- **[NERDTree](https://github.com/preservim/nerdtree)** - File system explorer
  - `F4` or `,nn` - Toggle file tree
  - `,nf` - Find current file in tree
  - `,nb` - Open bookmark

### Buffer Management
- **[vim-buffergator](https://github.com/jerias/vim-buffergator)** (custom fork) - Buffer list and navigation
  - `F3` - Toggle buffer list
  - `Shift+F3` - Update buffer list

### Code Editing
- **[vim-surround](https://github.com/tpope/vim-surround)** - Manipulate surrounding quotes, brackets, tags
  - `cs"'` - Change surrounding " to '
  - `ds"` - Delete surrounding "
  - `ysiw]` - Surround word with []

- **[tabular](https://github.com/godlygeek/tabular)** - Text alignment
  - `:Tabularize /=` - Align on = signs
  - `:Tabularize /,` - Align on commas

### Verilog/SystemVerilog
- **[verilog_systemverilog.vim](https://github.com/jerias/verilog_systemverilog.vim)** (custom fork) - Enhanced syntax and navigation
  - `,u` - Go to instance start
  - Improved syntax highlighting and indentation

### Git Integration
- **[vim-gitgutter](https://github.com/airblade/vim-gitgutter)** - Show git diff in gutter
  - Visual indicators for added/modified/deleted lines

### UI Enhancement
- **[vim-airline](https://github.com/vim-airline/vim-airline)** - Enhanced statusline
- **[vim-airline-themes](https://github.com/jerias/vim-airline-themes)** (custom fork) - Statusline themes
  - Current theme: `lightjpm`

---

## Key Mappings

### Leader Key
- Leader is set to `,` (comma)

### General
- `,w` - Fast save (`:w!`)

### File Navigation
- `F4` - Toggle NERDTree
- `,nn` - Toggle NERDTree
- `,nf` - Find current file in NERDTree
- `,nb` - NERDTree from bookmark

### Buffer Management
- `F3` - Toggle Buffergator
- `Shift+F3` - Update Buffergator

### Verilog Development
- `,u` - Go to Verilog instance start

---

## Configuration Structure

```
~/.vim/
├── autoload/
│   └── plug.vim              # vim-plug plugin manager
├── plugged/                  # Plugins installed by vim-plug (gitignored)
├── vimrcs/
│   ├── basic.vim             # Core vim settings
│   ├── plugins_config.vim    # Plugin-specific configurations
│   └── extended.vim          # Advanced features
└── temp_dirs/                # Temporary files (swap, backup, undo)
```

**Main entry point:** `~/.vimrc` sources the configuration files and initializes vim-plug

---

## Installation

### New Machine Setup

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/.vim
   ```

2. Link or source the vimrc:
   ```bash
   # Option 1: Source from ~/.vimrc
   echo "source ~/.vim/vimrcs/vimrc" >> ~/.vimrc

   # Option 2: Symlink (if ~/.vimrc is tracked elsewhere)
   # Configure ~/.vimrc to load plugins and source configs
   ```

3. Install vim-plug (already included in `autoload/`):
   ```bash
   # Already present, but if needed:
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

4. Open vim and install plugins:
   ```bash
   vim +PlugInstall +qall
   ```

### Updating Plugins

```bash
vim +PlugUpdate +qall
```

Or within vim:
```vim
:PlugUpdate
```

---

## Customization

### Adding New Plugins

1. Edit `~/.vimrc` (or your main vimrc file)
2. Add plugin between `plug#begin()` and `plug#end()`:
   ```vim
   Plug 'author/plugin-name'
   ```
3. Run `:PlugInstall`

### Removing Plugins

1. Remove or comment out the `Plug` line
2. Restart vim
3. Run `:PlugClean`

### Plugin Configuration

Plugin-specific settings are in `~/.vim/vimrcs/plugins_config.vim`

---

## Custom Settings

### Verilog Indentation
```vim
let g:verilog_disable_indent_lst="eos,standalone,moduleports"
```

### Airline Theme
```vim
let g:airline_theme="lightjpm"
let g:airline_stl_path_style = 'short'
```

### Buffergator
```vim
let g:buffergator_sort_regime = "filepath"
let g:buffergator_autoexpand_on_split = 0
```

---

## Migration History

- **2026-02-06**: Migrated from native pack management with git submodules to vim-plug
- **2026-01-15**: Migrated from pathogen to native pack management
- Previous plugin manager: pathogen (now archived in `disabled/`)

---

## Requirements

- Vim 8.0+ (for native features)
- Git (for plugin installation)
- Optional: Powerline fonts for airline symbols

---

## Troubleshooting

### Plugins not loading
```vim
:PlugStatus    " Check plugin status
:PlugInstall   " Reinstall missing plugins
```

### Plugin conflicts
```vim
:PlugClean     " Remove stale plugins
```

### Update vim-plug itself
```bash
vim +PlugUpgrade
```

---

## License

Personal configuration - use and modify as needed.

## Maintainer

Jerias Mitchell
