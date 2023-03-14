local M = {}

-- get visual selection
local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
  local _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")

  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return cscol - 1, cecol
  else
    return cecol - 1, cscol
  end
end

-- check that cursor on uri in normal mode
function M.checkIfCursorOnUri(mode, i, j)
  if mode ~= "n" then
    return true
  end

  local col = vim.api.nvim_win_get_cursor(0)[2]
  if i <= (col + 1) and j >= (col + 1) then
    print(i, col, j)
    return true
  end

  return false
end

-- cut line if in visual mode
function M.cutWithVisualMode(mode, line)
  if mode ~= "v" then
    return line
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", false)
  local i, j = visual_selection_range()
  return string.sub(line, i + 1, j)
end

return M