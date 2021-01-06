# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = instance_of?(Array) ? self : to_a
    count = 0
    while count < arr.length
      yield(arr[count])
      count += 1
    end
    arr
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = instance_of?(Array) ? self : to_a
    count = 0
    while count < arr.length
      yield(arr[count], count)
      count += 1
    end
    arr
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |element| new_arr << element if yield(element) }
    new_arr
  end

  def my_all?(*args)
    if !args[0].nil?
      my_each { |element| return false unless args[0] === element }
    elsif block_given?
      my_each { |element| return false unless yield(element) }
    else
      my_each { |element| return false unless element }
    end
    true
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each { |element| return true if args[0] === element }
    elsif block_given?
      my_each { |element| return true if yield(element) }
    else
      my_each { |element| return true if element }
    end
    false
  end

  def my_none?(args = nil, &block)
    !my_any?(args, &block)
  end

  def my_count(args = nil)
    count = 0
    my_each do |element|
      if args
        count += 1 if element == args
        count += 1 if args.is_a?(Regexp) && element.match?(args)
      elsif block_given?
        count += 1 if yield(element)
      else
        count += 1
      end
    end
    count
  end

  def my_map(proc_ = nil)
    return to_enum unless block_given? || proc_

    list_arr = []

    if proc_
      my_each { |element| list_arr.push(proc_.call(element)) }
    else
      my_each { |element| list_arr.push(yield(element)) }
    end
    list_arr
  end

  def my_inject(param1 = nil, param2 = nil)
    return raise LocalJumpError, 'Expecting a block or any argument' if !block_given? && param1.nil? && param2.nil?

    if !block_given?
      if param2.nil?
        param2 = param1
        param1 = nil
      end
      opp.to_sym
      my_each { |i| param1 = param1.nil? ? i : param1.send(param2, i) }
    else
      my_each { |i| param1 = param1.nil? ? i : yield(param1, i) }
    end
    acc
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Style/CaseEquality

def multiply_els(arr)
  arr.my_inject(:*)
end
