local cmp_highlights = {
  PmenuSel = { bg = "#2C323C", fg = "NONE" },  -- Item selecionado (um pouco mais claro que o fundo da lista)
  Pmenu = { fg = "#C8CCD4", bg = "#21252B" },  -- Fundo da lista de opções

  CmpItemAbbrDeprecated = { fg = "#6C7086", strikethrough = true },
  CmpItemAbbrMatch = { fg = "#82AAFF", bold = true },
  CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bold = true },

  CmpItemMenu = { fg = "#C792EA", italic = true },

  CmpItemKindCopilot = { fg = "#000000", bg = "#6CC644" },

  CmpItemKindFunction = { fg = "#FFFFFF", bg = "#A377BF" },
  CmpItemKindMethod = { fg = "#FFFFFF", bg = "#6C8ED4" },
  CmpItemKindVariable = { fg = "#FFFFFF", bg = "#7E8294" },
  CmpItemKindClass = { fg = "#FFFFFF", bg = "#A377BF" },
  CmpItemKindInterface = { fg = "#FFFFFF", bg = "#58B5A8" },
  CmpItemKindText = { fg = "#FFFFFF", bg = "#9FBD73" },
  CmpItemKindKeyword = { fg = "#FFFFFF", bg = "#9FBD73" },
  CmpItemKindProperty = { fg = "#FFFFFF", bg = "#B5585F" },
  CmpItemKindUnit = { fg = "#FFFFFF", bg = "#D4A959" },
  CmpItemKindEnum = { fg = "#FFFFFF", bg = "#9FBD73" },
  CmpItemKindSnippet = { fg = "#FFFFFF", bg = "#D4A959" },
  CmpItemKindFile = { fg = "#FFFFFF", bg = "#7E8294" },
  CmpItemKindFolder = { fg = "#FFFFFF", bg = "#D4A959" },
  CmpItemKindConstructor = { fg = "#FFFFFF", bg = "#D4BB6C" },
  CmpItemKindValue = { fg = "#FFFFFF", bg = "#6C8ED4" },
  CmpItemKindColor = { fg = "#FFFFFF", bg = "#58B5A8" },
  CmpItemKindReference = { fg = "#FFFFFF", bg = "#D4BB6C" },
  CmpItemKindEnumMember = { fg = "#FFFFFF", bg = "#6C8ED4" },
  CmpItemKindTypeParameter = { fg = "#FFFFFF", bg = "#58B5A8" },
  CmpItemKindOperator = { fg = "#FFFFFF", bg = "#A377BF" },
  CmpItemKindModule = { fg = "#FFFFFF", bg = "#A377BF" },
}

for group, opts in pairs(cmp_highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
