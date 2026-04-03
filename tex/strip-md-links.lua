-- strip-md-links.lua
-- Pandoc Lua filter: converts links to local .md files into plain text.
-- In a combined PDF all spec files are already merged,
-- so file-level cross-references are meaningless and leak build paths.

function Link(el)
  local target = el.target
  if target:match("%.md$") or target:match("%.md#") or target:match("%.md%s") then
    -- Return just the link text, dropping the URL
    return el.content
  end
  return el
end
