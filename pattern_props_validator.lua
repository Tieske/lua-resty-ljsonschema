local uservalues, lib, custom = ...
local locals = {}
local type = type
local lib_tablekind = lib.tablekind
local lib_valuekind = lib.valuekind
local math_fmod = math.fmod
local pairs = pairs
local custom_match_pattern = custom.match_pattern
locals.var_0_1 = nil
locals.var_0_2 = nil
locals.var_0_2 = function(p_1)
  local errors = {}  
  locals.var_1_1 =   type(p_1)  
  locals.var_1_2 =   locals.var_1_1 == "table" and lib_tablekind(p_1, custom.array_mt)  
  if not (  locals.var_1_1 == "string"  ) then  
  print("current_path:", "")  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected string, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
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
  if not (   (locals.var_1_1 == "number" and math_fmod(p_1, 1.0) == 0.0)   ) then  
  print("current_path:", "")  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected integer, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
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
  if not (   locals.var_1_1 == "table" and locals.var_1_2 <= 1   ) then  
  print("current_path:", "")  
    table.insert(errors, {schema_path = "/type", error = "wrong type: expected object, got " .. lib_valuekind(p_1, custom.array_mt, custom.null)})  
  end  
  if locals.var_1_1 == "table" and locals.var_1_2 <= 1 then  
    for prop, value in pairs(p_1) do  
      if custom_match_pattern(prop, "^S_") then  
        local ok, err = locals.var_0_2(value)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/patternProperties/^S_" or ("/patternProperties/^S_" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/patternProperties/^S_", error = err})  
          end  
        end  
      end  
      if custom_match_pattern(prop, "^I_") then  
        local ok, err = locals.var_0_3(value)  
        if not ok then  
          if type(err) == "table" then  
            for _, sub_err in ipairs(err) do  
              local new_path = sub_err.schema_path == "" and "/patternProperties/^I_" or ("/patternProperties/^I_" .. sub_err.schema_path)  
              table.insert(errors, {schema_path = new_path, error = sub_err.error})  
            end  
          else  
            table.insert(errors, {schema_path = "/patternProperties/^I_", error = err})  
          end  
        end  
      end  
    end  
  end  
  if #errors > 0 then  
    return false, errors  
  end  
  return true  
end
return locals.var_0_1
