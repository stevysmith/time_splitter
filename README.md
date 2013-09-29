TimeSplitter
============
[![Build Status](https://travis-ci.org/shekibobo/time_splitter.png)](https://travis-ci.org/shekibobo/time_splitter)

Setting DateTimes can be a difficult or ugly thing, especially through a web form. Finding a good DatePicker or TimePicker is easy, but getting them to work on both can be difficult. TimeSplitter automatically generates accessors for `date`, `time`, `hour`, and `min` on any datetime or time attribute, making it trivial to use different form inputs to set different parts of a datetime field.

This gem is based on [SplitDatetime](https://github.com/michihuber/split_datetime) by [Michi Huber](https://github.com/michihuber). TimeSplitter improves on the gem, updating for Rails 4, adding `time` accessors, and providing a safer and more consistent default setting.

## Example Usage
In your `Gemfile`:

```ruby
gem "time_splitter"
```

After bundling, assuming you have an Event model with a starts_at attribute, add this to your model:

```ruby
class Event < ActiveRecord::Base
  extend TimeSplitter::Accessors
  split_accessor :starts_at
end
```

In your view:

```erb
<%= simple_form_for @event do |f| %>
  <%= f.input :starts_at_date, as: :string, input_html: { class: 'datepicker' } %>
  <%= f.input :starts_at_hour, collection: 0..24 %>
  <%= f.input :starts_at_min, collection: [0, 15, 30, 45] %>
  <%= f.input :starts_at_time, as: :time_select
  <%= ... %>
<% end %>
```

Add your js datepicker and you're good to go. (Of course, this also works with standard Rails form helpers).

## Options

You can specify the date format for the view:

```ruby
split_accessor :starts_at, format: "%D"
```

See `Time#strftime` for formats. Default is `"%F"`.

You can specify multiple datetime fields to split:

```ruby
split_accessor :starts_at, :ends_at, :expires_at, format: "%D"
```
