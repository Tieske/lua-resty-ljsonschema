local uservalues, lib, custom = ...
local locals = {}
local type = type
local lib_tablekind = lib.tablekind
local lib_valuekind = lib.valuekind
local ipairs = ipairs
local lib_deepeq = lib.deepeq
local string_format = string.format
local custom_str_len = custom.str_len
local custom_match_pattern = custom.match_pattern
local lib_format_number = lib.format_number
local pairs = pairs
locals.var_0_1 = nil
locals.var_0_2 = nil
locals.var_0_2 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  
    p_1 == "red"   or  
    p_1 == "green"   or  
    p_1 == "blue"    
  ) then  
    table.insert(errors, {schema_path = "/enum", error = "matches none of the enum values"})  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_3 = nil
locals.var_0_4 = nil
locals.var_0_4 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "string"  ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected string, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_3 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (   locals.var_1_1 == "table" and locals.var_1_2 >= 1   ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected array, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "table" and locals.var_1_2 >= 1 then  
    local itemcount = #p_1  
    if itemcount < 2 then  
      table.insert(errors, {schema_path = "/minItems", error = "expect array to have at least 2 items"})  
    end  
    if itemcount > 5 then  
      table.insert(errors, {schema_path = "/maxItems", error = "expect array to have at most 5 items"})  
    end  
    for i, item in ipairs(p_1) do  
      local ok, err = locals.var_0_4(item)  
      if not ok then  
        if type(err) == "table" then  
          for _, sub_err in ipairs(err) do  
            local new_path = sub_err.schema_path == "" and "/items" or ("/items" .. sub_err.schema_path)  
            table.insert(errors, {schema_path = new_path, error = sub_err.error})  
          end  
        else  
          table.insert(errors, {schema_path = "/items", error = err})  
        end  
        if #errors > 0 then  
          errors[#errors].schema_path = item_path .. errors[#errors].schema_path  
        end  
      end  
    end  
    for i=2, #p_1 do  
      for j=1, i-1 do  
        if lib_deepeq(p_1[i], p_1[j]) then  
          table.insert(errors, {schema_path = "/uniqueItems", error = string_format("expected unique items but items %d and %d are equal", i, j)})  
        end  
      end  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_5 = nil
locals.var_0_5 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "string"  ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected string, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "string" then  
    local length = custom_str_len(p_1)  
    if not length then  
      table.insert(errors, {schema_path = "", error = "failed to get string length, invalid utf8"})  
    end  
    if length and length < 5 then  
      table.insert(errors, {schema_path = "/minLength", error = string_format("string too short, expected at least 5, got %d", length)})  
    end  
    if length and length > 10 then  
      table.insert(errors, {schema_path = "/maxLength", error = string_format("string too long, expected at most 10, got %d", length)})  
    end  
    if not custom_match_pattern(p_1, "^[a-z]+$") then  
      table.insert(errors, {schema_path = "/pattern", error = string_format([[failed to match pattern ]] .. "^[a-z]+$" .. [[ with %q]], p_1)})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_6 = nil
locals.var_0_6 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "number"  ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected number, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "number" then  
    if p_1 < 10 then  
      table.insert(errors, {schema_path = "/minimum", error = string_format("expected %s to be greater than 10", lib_format_number(p_1))})  
    end  
    if p_1 > 100 then  
      table.insert(errors, {schema_path = "/maximum", error = string_format("expected %s to be smaller than 100", lib_format_number(p_1))})  
    end  
    if p_1 % 5 ~= 0 then  
      table.insert(errors, {schema_path = "/multipleOf", error = string_format("expected %s to be a multiple of 5", p_1)})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
locals.var_0_7 = {}
locals.var_0_7["enum_field"] = true
locals.var_0_7["arr_field"] = true
locals.var_0_7["str_field"] = true
locals.var_0_7["num_field"] = true
locals.var_0_1 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (   locals.var_1_1 == "table" and locals.var_1_2 <= 1   ) then  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected object, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "table" and locals.var_1_2 <= 1 then  
    local propcount = 0  
    do  
      local propvalue = p_1["enum_field"]  
      if propvalue ~= nil then  
        local ok, err = locals.var_0_2(propvalue)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/properties/enum_field" or ("/properties/enum_field" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/properties/enum_field", error = err})  
          end  
        end  
      end  
    end  
    do  
      local propvalue = p_1["arr_field"]  
      if propvalue ~= nil then  
        local ok, err = locals.var_0_3(propvalue)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/properties/arr_field" or ("/properties/arr_field" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/properties/arr_field", error = err})  
          end  
        end  
      end  
    end  
    do  
      local propvalue = p_1["str_field"]  
      if propvalue ~= nil then  
        local ok, err = locals.var_0_5(propvalue)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/properties/str_field" or ("/properties/str_field" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/properties/str_field", error = err})  
          end  
        end  
      else  
        table.insert(errors, {schema_path = "/required", error = 'property ' .. "str_field" .. ' is required'})  
      end  
    end  
    do  
      local propvalue = p_1["num_field"]  
      if propvalue ~= nil then  
        local ok, err = locals.var_0_6(propvalue)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/properties/num_field" or ("/properties/num_field" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/properties/num_field", error = err})  
          end  
        end  
      else  
        table.insert(errors, {schema_path = "/required", error = 'property ' .. "num_field" .. ' is required'})  
      end  
    end  
    for prop, value in pairs(p_1) do  
      if not locals.var_0_7[prop] then  
        table.insert(errors, {schema_path = "/additionalProperties", error = "additional properties forbidden, found " .. prop})  
      end  
      propcount = propcount + 1  
    end  
    if propcount < 2 then  
      table.insert(errors, {schema_path = "/minProperties", error = "expect object to have at least 2 properties"})  
    end  
    if propcount > 10 then  
      table.insert(errors, {schema_path = "/maxProperties", error = "expect object to have at most 10 properties"})  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
return locals.var_0_1
