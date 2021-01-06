# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength

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

  def my_all?(args = nil)
    if block_given?
      my_each { |element| return false if yield(element) == false }
      return true
    elsif args.nil?
      my_each { |element| return false if n.nil? || element == false }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |element| return false if element.class != args }
    elsif !args.nil? && args.instance_of?(Regexp)
      my_each { |element| return false unless args.match(element) }
    else
      my_each { |element| return false if element != args }
    end
    true
  end

  def my_any?(args = nil)
    if block_given?
      my_each { |element| return true if yield(element) }
      false
    elsif args.nil?
      my_each { |element| return true if n.nil? || element == true }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |element| return true if element.instance_of?(args) }
    elsif !args.nil? && args.instance_of?(Regexp)
      my_each { |element| return true if args.match(element) }
    else
      my_each { |element| return true if element == args }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(arg = nil)
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

  def my_inject(num = nil, sym = nil)
    if block_given?
      acc = num
      my_each do |element|
        acc = acc.nil? ? element : yield(acc, element)
      end
      acc
    elsif !num.nil? && (num.is_a?(Symbol) || num.is_a?(String))
      acc = nil
      my_each do |element|
        acc = acc.nil? ? element : acc.send(num, element)
      end
      acc
    elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
      acc = num
      my_each do |element|
        acc = acc.nil? ? element : acc.send(sym, element)
      end
      acc
    end
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject(:*)
end
