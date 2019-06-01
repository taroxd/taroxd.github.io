---
title: 用 ruby 实现简单的并行处理
---

```ruby
num_threads = 4

arg_list = ["foo", "bar"] # and probably more
Thread.abort_on_exception = true

queue = arg_list.each_with_object(Queue.new) { |f, q| q << f }

threads = Array.new(num_threads) do
  Thread.new do
    until queue.empty?
      arg = queue.shift
      do_something_with(arg)
    end
  end
end

threads.each(&:join)
```
