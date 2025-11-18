-- Test suite for collect_all_errors functionality
-- This test file contains specialized tests for the collect_all_errors option.
-- These tests use exact error matching. Tests with parts format handle non-deterministic
-- pairs() iteration order. General compliance tests with collect_all_errors are in suite_spec.lua

local json = require 'cjson'
json.decode_array_with_array_mt(true)
local jsonschema = require 'resty.ljsonschema'

local function readjson(path)
  if path:match('%.json$') then
    local f = assert(io.open(path))
    local body = json.decode((assert(f:read('*a'))))
    f:close()
    return body
  elseif path:match('%.lua$') then
    return dofile(path)
  end
  error('cannot read ' .. path)
end


local function assert_contains_all_error_entries(actual_errors, expected_entries)
  -- Handle case where actual_errors might contain strings instead of tables
  local actual_error_map = {}
  for _, err_entry in ipairs(actual_errors) do
    local key
    if type(err_entry) == "table" and err_entry.schema_path and err_entry.error then
      key = err_entry.schema_path .. ":" .. (err_entry.instance_path or "") .. ":" .. err_entry.error
    elseif type(err_entry) == "table" and err_entry.error and not err_entry.schema_path then
      -- Handle tables with only error field (like format errors)
      key = "" .. ":" .. "" .. ":" .. err_entry.error
    elseif type(err_entry) == "string" then
      -- For string errors, use empty schema_path and instance_path
      key = "" .. ":" .. "" .. ":" .. err_entry
    else
      error("Unexpected error format: " .. type(err_entry) .. " - " .. tostring(err_entry))
    end
    actual_error_map[key] = true
  end
  
  -- Check each expected entry exists
  for _, expected in ipairs(expected_entries) do
    local key = expected.schema_path .. ":" .. (expected.instance_path or "") .. ":" .. expected.error
    if not actual_error_map[key] then
      local actual_str = "[\n"
      for _, err_entry in ipairs(actual_errors) do
        if type(err_entry) == "table" and err_entry.schema_path and err_entry.error then
          actual_str = actual_str .. string.format('  {schema_path="%s", instance_path="%s", error="%s"},\n', 
                                                  err_entry.schema_path, err_entry.instance_path or "", err_entry.error)
        end
      end
      actual_str = actual_str .. "]"
      
      error(string.format(
        "Expected error entry not found:\n  Expected: {schema_path=\"%s\", instance_path=\"%s\", error=\"%s\"}\n  Actual errors: %s",
        expected.schema_path, expected.instance_path or "", expected.error, actual_str
      ))
    end
  end
  
  -- Also check that we have the expected number of errors
  if #actual_errors ~= #expected_entries then
    error(string.format(
      "Expected %d errors but got %d errors",
      #expected_entries, #actual_errors
    ))
  end
end

local options = {
  collect_all_errors = true
}

describe("[collect_all_errors - specialized tests]", function()

  local test_file = 'spec/extra/errors/collect_all_errors.json'
  
  for _, suite in ipairs(readjson(test_file)) do
    describe("["..test_file.."] "..suite.description .. ":", function()
      local schema = suite.schema
      local validator

      lazy_setup(function()
        local val = assert(jsonschema.generate_validator(schema, options))
        assert.is_function(val)
        validator = val
      end)

      for _, case in ipairs(suite.tests) do
        it(case.description, function()
          if case.valid then
            assert.has.no.error(function()
              assert(validator(case.data))
            end)
          else
            local result, errors
            assert.has.no.error(function()
              result, errors = validator(case.data)
            end)
            
            -- Verify that result is false and errors is a table
            assert.is_false(result)
            assert.is_table(errors)
            
            -- Check error entries for collect_all_errors.json tests
            if case.error_entries then
              assert_contains_all_error_entries(errors, case.error_entries)
            end
          end
        end) -- it
      end -- for cases
    end) -- describe
  end -- for suite

end) -- outer describe
