local File = {}
local base_path = "academy"

file.CreateDir(base_path)

base_path = base_path .. "/"

local file_Find = file.Find
local file_Read = file.Read
local file_Write = file.Write

---@param path string
function File.Find(path)
    return file_Find(base_path .. path, "DATA")
end

---@param path string
function File.Read(path)
    return file_Read(base_path .. path, "DATA")
end

---@param path string
---@param content string
function File.Write(path, content)
    local clean_path = string.gsub(path, " ", "_")
    clean_path = string.gsub(clean_path, ":", "-")
    
    local full_path = base_path .. clean_path
    local dir_to_create = string.GetPathFromFilename(full_path)

    file.CreateDir(dir_to_create)
    return file_Write(full_path, content)
end

Arbitrage.file = File