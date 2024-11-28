# Nvim config

## OS Paths

| OS                   | PATH                                      |
| :------------------- | :---------------------------------------- |
| Linux, MacOS         | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)        | `%localappdata%\nvim\`                    |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim\`                 |

## Clone Config

<details><summary> Linux and Mac </summary>

```sh
git clone git@github.com:ybarsotti/nvim-config.git ${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone git@github.com:ybarsotti/nvim-config.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/dam9000/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

# Vim motions & tricks

- Select within () and {} -> `vib/viB`
- Edit multiple lines at once -> Block mode -> I (insert mode with capital i) -> escape
  - Same thing can be done for the end of line
- Toggle case -> ~ (letter) / g~<motion>
- Re-indent whole file -> gg=G
- Put vim in background -> C-z -> To return `fg` (in terminal)
- Open URL -> gx (opens in browser)
- Open via file path -> gf (open file)
- Mark location -> m<letter>
  - Return -> '<letter>
- Mark location to be used globally -> Same but with M
- GOTO line number -> <line_number>G
- Join lines -> j (joins into same line)
  - Join lines without space -> gj
