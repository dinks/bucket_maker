# BucketMaker

[![Gem Version](https://badge.fury.io/rb/bucket_maker.png)](http://rubygems.org/gems/bucket_maker)
[![Code Climate](https://codeclimate.com/github/dinks/bucket_maker.png)](https://codeclimate.com/github/dinks/bucket_maker)
[![Build Status](https://travis-ci.org/dinks/bucket_maker.png?branch=master)](https://travis-ci.org/dinks/bucket_maker)
[![Coverage Status](https://coveralls.io/repos/dinks/bucket_maker/badge.png)](https://coveralls.io/r/dinks/bucket_maker)
[![Dependency Status](https://gemnasium.com/dinks/bucket_maker.png)](https://gemnasium.com/dinks/bucket_maker)

A Gem to categorize Objects into buckets. Typical use case is an A/B test for Users

## Installation

Add this line to your application's Gemfile:

    gem 'bucket_maker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bucket_maker

Generate the `initializer` by running

    rails g bucket_maker:install

This will create a file `config/bucket_maker.rb` with the configuration options

The `Series/Bucket/Group` is common for all the `Bucketable` objects

We define the buckets in a yml file and add this to the configuration file
Please look at `spec/dummy/config/buckets.yml`

To create a model (if does not exist) and populate the model with the bucket_maker module inclusion, run

    rails g bucket_maker MODEL

Where `MODEL` could be say `User`

This will add the code to the *top* of the class

    include BucketMaker::Models::Redisable

By default it uses redis to store the keys and groups

To make use of ActiveRecord to hold the key and group, use the generator this way

    rails g bucket_maker user active_record

This will add the code to the *top* of the class

    include BucketMaker::Models::ActiveRecordable

## Usage

Every class which includes `BucketMaker::Models::` should implement 2 methods

    group_for_key(series_key)

and

    set_group_for_key(series_key, group_name)

These methods only define the way to retrieve and store data

Look at `BucketMaker::Models::Bucketable` for more info

### Methods

    in_bucket?(series_name, bucket_name, group_name)

To check if a `Bucketable` object is in the group `group_name` under a bucket `bucket_name`
under a series `series_name`

    not_in_bucket?(series_name, bucket_name, group_name)

Inverse of `in_bucket?`

    force_to_bucket!(series_name, bucket_name, group_name)

Force the `Bucketable` to take the `group_name` under `bucket_name` under `series_name`

    bucketize!

Randomize the `Bucketable` object for all possible combinations

    bucketize_for_series_and_bucket!(series_name, bucket_name)

Randomize the `Bucketable` object for `bucket_name` under `series_name`

### Routes and Controller

There are 3 routes that the Gem tries to add. This is added *ONLY* if the configuration has the
`path_prefix` option set to something other than `nil`. By default the routes are loaded

All the results got are with respect to the `Bucketable` object `User`. The gem assumes that this
request is a part of a A/B Testing procedure and expects `@current_user` to be set accordingly

* GET to `/#{path_prefix}:series_name/:bucket_name/:group_name` is used to see if `@current_user` is
in the group `group_name` under `bucket_name` under `series_name`

* POST to `/#{path_prefix}:series_name/:bucket_name` is used group the `@current_user` into a group which
is under `bucket_name` under `series_name`

* POST to `/#{path_prefix}:series_name/:bucket_name/:group_name` is used force group the `@current_user`
into the group `group_name` under `bucket_name` under `series_name`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
