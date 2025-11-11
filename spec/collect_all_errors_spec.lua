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

-- Helper function to check if error table contains all expected error entries
-- regardless of their order (to handle non-deterministic pairs() iteration)
local function assert_contains_all_error_entries(actual_errors, expected_entries)
  -- Create a map of actual error messages for quick lookup
  local actual_error_map = {}
  for _, err_entry in ipairs(actual_errors) do
    local key = err_entry.schema_path .. ":" .. err_entry.error
    actual_error_map[key] = true
  end
  
  -- Check each expected entry exists
  for _, expected in ipairs(expected_entries) do
    local key = expected.schema_path .. ":" .. expected.error
    if not actual_error_map[key] then
      local actual_str = "[\n"
      for _, err_entry in ipairs(actual_errors) do
        actual_str = actual_str .. string.format('  {schema_path="%s", error="%s"},\n', 
                                                err_entry.schema_path, err_entry.error)
      end
      actual_str = actual_str .. "]"
      
      error(string.format(
        "Expected error entry not found:\n  Expected: {schema_path=\"%s\", error=\"%s\"}\n  Actual errors: %s",
        expected.schema_path, expected.error, actual_str
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
            elseif case.error_entries_anyOf then
              -- Try each possibility until one matches
              local matched = false
              local error_messages = {}
              for i, possibility in ipairs(case.error_entries_anyOf) do
                local ok, match_err = pcall(assert_contains_all_error_entries, errors, possibility)
                if ok then
                  matched = true
                  break
                else
                  table.insert(error_messages, string.format("Possibility %d failed: %s", i, match_err))
                end
              end
              if not matched then
                error("No matching error format found:\n" .. table.concat(error_messages, "\n"))
              end
            end
          end
        end) -- it
      end -- for cases
    end) -- describe
  end -- for suite

end) -- outer describe
