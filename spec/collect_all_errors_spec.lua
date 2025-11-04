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

-- Helper function to check if error message contains all expected parts
-- regardless of their order (to handle non-deterministic pairs() iteration)
local function assert_contains_all_parts(actual_error, expected_parts)
  -- Split actual error by semicolon
  local actual_parts = {}
  for part in actual_error:gmatch("[^;]+") do
    part = part:match("^%s*(.-)%s*$")  -- Trim whitespace
    actual_parts[part] = true
  end
  
  -- Check each expected part exists
  for _, expected in ipairs(expected_parts) do
    expected = expected:match("^%s*(.-)%s*$")
    if not actual_parts[expected] then
      error(string.format(
        "Expected error part not found:\n  Expected: %s\n  Actual: %s",
        expected, actual_error
      ))
    end
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
            local result, err
            assert.has.no.error(function()
              result, err = validator(case.data)
            end)
            
            -- Exact error matching for collect_all_errors.json tests
            if case.error then
              if type(case.error) == "string" then
                assert.equal(case.error, err)
              elseif type(case.error) == "table" and case.error.parts then
                assert_contains_all_parts(err, case.error.parts)
              elseif type(case.error) == "table" and case.error.anyOf then
                -- Try each possibility until one matches
                local matched = false
                local errors = {}
                for i, possibility in ipairs(case.error.anyOf) do
                  if possibility.parts then
                    local ok, match_err = pcall(assert_contains_all_parts, err, possibility.parts)
                    if ok then
                      matched = true
                      break
                    else
                      table.insert(errors, string.format("Possibility %d failed: %s", i, match_err))
                    end
                  end
                end
                if not matched then
                  error("No matching error format found:\n" .. table.concat(errors, "\n"))
                end
              end
            end
            
            assert.has.error(function()
              assert(result, err)
            end)
          end
        end) -- it
      end -- for cases
    end) -- describe
  end -- for suite

end) -- outer describe
