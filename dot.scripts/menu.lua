local module = {}

local function scandir(directory,match)
  local i, t, popen = 0, {}, io.popen
  --for filename in popen('ls "'..directory..'"'):lines() do
  for filename in popen('find "'..directory..'" -name "' .. match .. '" -printf "%f\n" | sort'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

function module.gen(command, path, match, icon)
  
  if string.find(path, '/$') == nil then
    path = path .. '/'
  end

  local res = {}
  local files = scandir(path,match)

  for i, files in ipairs(files) do
    print(i .. ' ' .. path .. files)
    res[i] = { files, command .. ' ' .. path .. files, icon }
  end

  return res
end

return module
