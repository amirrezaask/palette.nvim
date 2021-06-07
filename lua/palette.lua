local highlight = {}
highlight.__index = highlight

function highlight:_apply_link()
  vim.cmd(table.concat({'highlight', 'link', self.name, self.link}, ' '))
end
function highlight:_apply_actual()
  if type(self.name) == 'table' and vim.tbl_islist(self.name) then
    local hls = {}
    for _, name in ipairs(self.name) do
      local this_hl = highlight:apply {
        name = name,
        bg = self.bg,
        fg = self.fg,
        styles = self.styles
      }
      table.insert(hls, this_hl)
    end
  elseif type(self.name) == 'string' then
    local output = {'highlight', self.name}
    if self.bg then
      table.insert(output, string.format('guibg=%s', self.bg))
    end
    if self.fg then
      table.insert(output, string.format('guifg=%s', self.fg))
    end
    if self.styles and #self.styles > 0 then
      table.insert(output, string.format('gui=%s', table.concat(self.styles, ',')))
    else
      table.insert(output, string.format('gui=none'))
    end
    vim.cmd(table.concat(output, ' '))
  else
    vim.api.nvim_err_writeln('not supported type for name: ' .. type(self.name))
  end
end
function highlight:_apply()
  if self.link then
    self:_apply_link()
  else
    self:_apply_actual()
  end
end

function highlight:apply(opts)
  assert(opts, 'need opts')
  if opts[1] then
    opts.name = opts[1]
  end
  assert(opts.name, 'need a name')
  assert((type(opts.name) == 'string' or (type(opts.name)=='table' and vim.tbl_islist(opts.name))),
    'name should be either a table of strings or a simple string')
  local obj = setmetatable(opts, self)
  obj:_apply()
  return obj
end

highlight = setmetatable(highlight,{
  __call = function(tbl, ...)
    tbl:apply(...)
  end
})

return {
  highlight = highlight,
  styles = setmetatable({
    italic = 'italic',
    bold = 'bold',
    underline = 'underline'
  }, {
      __newindex = function()
        vim.api.nvim_err_writeln('cannot add style')
        return
      end
    })
}
