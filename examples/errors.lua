-- This example shows how to collect either the first error or all errors
-- during validation.

local jsonschema = require 'resty.ljsonschema'

local my_schema = {
    type = "object",
    properties = {
        name = {
            type = "string",
            minLength = 3
        },
        age = {
            type = "integer",
            minimum = 0
        },
        email = {
            type = "string",
            pattern = "^[^@]+@[^@]+$"
        }
    },
    required = { "name", "age" }
}

-- Generate two validators: one that stops at the first error, and one that
-- collects all errors.
local validator_single = jsonschema.generate_validator(my_schema)
local validator_all    = jsonschema.generate_validator(my_schema, { collect_all_errors = true })

-- Now define values to validate against our spec:
local my_data = {
  name = 'Al',
  age = -42.1,
  email = 'invalid-email'
}

-- requires Penlight library for pretty printing tables
local pl_pretty = require 'pl.pretty'
print("single: " .. pl_pretty.write({validator_single(my_data)}))  --> false, error message
print("all: " .. pl_pretty.write({validator_all(my_data)}))        --> false, table of all error messages
