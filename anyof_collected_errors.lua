local uservalues, lib, custom = ...
local locals = {}
local type = type
local lib_tablekind = lib.tablekind
local lib_valuekind = lib.valuekind
local custom_str_len = custom.str_len
local string_format = string.format
local lib_format_number = lib.format_number
locals.var_0_1 = nil
locals.var_0_2 = nil
locals.var_0_2 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "string"  ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected string, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "string" then  
    local length = custom_str_len(p_1)  
    if not length then  
      table.insert(errors, {schema_path = nil, error = "failed to get string length, invalid utf8"})  
    end  
    if length and length > 5 then  
      table.insert(errors, {schema_path = "/maxLength", error = string_format("string too long, expected at most 5, got %d", length)})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_3 = nil
locals.var_0_3 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "number"  ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected number, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "number" then  
    if p_1 < 100 then  
      table.insert(errors, {schema_path = "/minimum", error = string_format("expected %s to be greater than 100", lib_format_number(p_1))})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_4 = nil
locals.var_0_4 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (   locals.var_1_1 == "table" and locals.var_1_2 <= 1   ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected object, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "table" and locals.var_1_2 <= 1 then  
    if p_1["age"] == nil then  
      table.insert(errors, {schema_path = "/required", error = 'property ' .. "age" .. ' is required'})  
    end  
    if p_1["name"] == nil then  
      table.insert(errors, {schema_path = "/required", error = 'property ' .. "name" .. ' is required'})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_1 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  
    locals.var_0_2(p_1)   or  
    locals.var_0_3(p_1)   or  
    locals.var_0_4(p_1)    
  ) then  
    local any_of_errors = {}  
    do  
      local was_matched, error_message  
      was_matched, error_message = locals.var_0_2(p_1)  
      if not was_matched then  
        if type(error_message) == "table" then  
          for _, sub_err in ipairs(error_message) do  
            local new_path = sub_err.schema_path == "" and "/anyOf/0" or ("/anyOf/0" .. sub_err.schema_path)  
            table.insert(any_of_errors, {schema_path = new_path, error = sub_err.error})  
          end  
        else  
          table.insert(any_of_errors, {schema_path = "/anyOf/0", error = error_message})  
        end  
      end  
      local was_matched, error_message  
      was_matched, error_message = locals.var_0_3(p_1)  
      if not was_matched then  
        if type(error_message) == "table" then  
          for _, sub_err in ipairs(error_message) do  
            local new_path = sub_err.schema_path == "" and "/anyOf/1" or ("/anyOf/1" .. sub_err.schema_path)  
            table.insert(any_of_errors, {schema_path = new_path, error = sub_err.error})  
          end  
        else  
          table.insert(any_of_errors, {schema_path = "/anyOf/1", error = error_message})  
        end  
      end  
      local was_matched, error_message  
      was_matched, error_message = locals.var_0_4(p_1)  
      if not was_matched then  
        if type(error_message) == "table" then  
          for _, sub_err in ipairs(error_message) do  
            local new_path = sub_err.schema_path == "" and "/anyOf/2" or ("/anyOf/2" .. sub_err.schema_path)  
            table.insert(any_of_errors, {schema_path = new_path, error = sub_err.error})  
          end  
        else  
          table.insert(any_of_errors, {schema_path = "/anyOf/2", error = error_message})  
        end  
      end  
    end  
    for _, err in ipairs(any_of_errors) do  
      table.insert(errors, err)  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
return locals.var_0_1
