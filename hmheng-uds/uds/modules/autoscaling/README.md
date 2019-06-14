This is a small module to avoid repeating a bunch of terraform configuration for multiple DynamoDB tables and indexes. Using the module is pretty easy. You need to set the following variables:

1. `min_read_capacity` to reflect the minimum read capacity.
2. `min_write_capacity` to reflect the minimum write capacity.
3. `max_read_capacity` to reflect the maximum read capacity.
4. `max_write_capacity` to reflect the maximum write capacity.
5. `resource_id` identifying the table or global secondary index which should undergo the autoscaling.
6. `scalable_dimension_type` should be set to either `"table"` or `"index"` depending on the resource type. (An improved module could possibly detect this based on the `resource_id` but at this time you need to specify explicitly.)

You'll also need to run `terraform get` before you can do a `plan` or `apply`.
