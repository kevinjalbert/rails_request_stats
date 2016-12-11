# RailsRequestStats

[![Gem Version](https://badge.fury.io/rb/rails_request_stats.svg)](https://badge.fury.io/rb/rails_request_stats)
[![Build Status](https://travis-ci.org/kevinjalbert/rails_request_stats.svg?branch=master)](https://travis-ci.org/kevinjalbert/rails_request_stats)
[![Code Climate](https://codeclimate.com/github/kevinjalbert/rails_request_stats/badges/gpa.svg)](https://codeclimate.com/github/kevinjalbert/rails_request_stats)
[![Test Coverage](https://codeclimate.com/github/kevinjalbert/rails_request_stats/badges/coverage.svg)](https://codeclimate.com/github/kevinjalbert/rails_request_stats/coverage)

During development have you ever:

* Wondered how many SQL queries occurred during a request?
* Been curious on average view and database runtime for a request?
* Wanted a report containing overall statistics of all unique requests?
* Wanted a better way to iteratively optimize requests?

`RailsRequestStats` provides a simple drop-in solution to expose more statistics on requests. New information is presented in your development logs, supplying you with the required information to iteratively optimize requests by noticing subtle changes in the number of queries and average runtimes.

## How this Works

`RailsRequestStats::NotificationSubscribers` when required will subscribe to the `sql.active_record`, `start_processing.action_controller`, and `process_action.action_controller` `ActionSupport::Notifications`.

 * The `sql.active_record` event allow us to count each SQL query that passes though ActiveRecord, which we count internally.
 * The `cache_read.active_support` event allows us to count each read and hit to the Rails cache.
 * The `cache_fetch_hit.active_support` event allows us to count the cache hits to the Rails cache when using *fetch*.
 * The `start_processing.action_controller` event allows us to clear iternal counts, as well as perform a `GC.start` and capturing the count of objects residing in the `ObjectSpace`.
 * The `process_action.action_controller` event provides us runtime information along with identifying controller action details, we even determine the number of generated objects since the start of processing the action. At this point we are able to synthesis the query information and runtime information and store them internally in running collection of `RailsRequestStats::RequestStats` objects.

**Note** the data collection is tracked and stored in class-level instance variables. Thus this is not threadsafe, as no concurrency mechanisms are used (i.e., mutex). For non-threaded and forking application servers this should be fine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_request_stats', group: :development
```

## Example Outputs

Within the console ./log/development.log you should start seeing the following statement appearing at the end of processing a request:

```
[RailsRequestStats] (AVG view_runtime: 163.655ms | AVG db_runtime: 15.465ms | AVG generated_object_count: 14523 | query_count: 9 | cached_query_count: 0 | cache_read_count: 3 | cache_hit_count: 3)
```

Finally when you exit the application's server, you should see a summary report of all the data captured:

```
[RailsRequestStats] INDEX:html "/users" (AVG view_runtime: 128.492ms | AVG db_runtime: 9.186ms | AVG generated_object_count: 25529 | MIN query_count: 8 | MAX query_count: 9) from 4 requests
[RailsRequestStats] SHOW:html "/users/2" (AVG view_runtime: 13.0429ms | AVG db_runtime: 1.69033ms | AVG generated_object_count: 14523 | MIN query_count: 2 | MAX query_count: 2) from 3 requests
[RailsRequestStats] SHOW:html "/users/2?test=1&blah=2" (AVG view_runtime: 17.8252ms | AVG db_runtime: 1.621ms | AVG generated_object_count: 18511 | MIN query_count: 2 | MAX query_count: 2) from 1 requests
```

## Customizing Outputs

### Memory Stats
By setting the following class variable within in an initializer (`./config/initializers/rails_request_stats.rb`):

```ruby
RailsRequestStats::Report.print_memory_stats = true
```

You can see the *generated objects* within the `ObjectSpace` for individual requests:

```
[RailsRequestStats] (AVG view_runtime: 93.7252ms | AVG db_runtime: 8.66075ms | AVG generated_object_count: 125282 | query_count: 8 | cached_query_count: 0 | cache_read_count: 3 | cache_hit_count: 3 | generated_objects: {:total_generated_objects=>111878, :object=>921, :class=>35, :module=>0, :float=>0, :string=>49501, :regexp=>1556, :array=>17855, :hash=>2087, :struct=>103, :bignum=>0, :file=>0, :data=>37682, :match=>373, :complex=>0, :node=>1688, :iclass=>0})
```

### Override Reports

You can manually override the output by monkey-patching in an initializer (`./config/initializers/rails_request_stats.rb`):

```ruby
module RailsRequestStats
  class Report
    # Called after every request
    def report_text
      # Access to @request_stats (instance of RequestStats)
    end
    # Called after the application server is closed (via #at_exit_handler)
    def exit_report_text
      # Access to @request_stats (instance of RequestStats)
    end
  end

  class NotificationSubscribers
    # Called when the application server is closed
    def self.at_exit_handler
      # Access to @requests (hash of { <paths> => RequestStats })
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kevinjalbert/rails_request_stats. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
