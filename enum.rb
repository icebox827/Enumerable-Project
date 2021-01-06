# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength

module Enumerable
    def my_each
      return to_enum(:my_each) unless block_given?
  
      arr = to_a
      arr.length.times do |n|
        yield (arr[n])
        self
      end
      arr
    end
  
    def my_each_with_index
      return to_enum(:my_each) unless block_given?
  
      arr = to_a
      counter = 0
      while counter < arr.length
        yield(arr[counter], counter)
        counter += 1
      end
      arr
    end
  
    def my_select
      return to_enum(:my_select) unless block_given?
  
      list = []
  
      arr.my_each | filter |
        if filter != 'accepted'
          list.push(filter)
          yield filter
        end
    end
  
    def my_all?(args = nil)
      if block_given?
        my_each { |element| return false if yield(element) == false }
        return true
      elsif arg.nil?
        my_each { |element| return false if n.nil? || element == false }
      elsif !arg.nil? && (args.is_a? Class)
        my_each { |element| return false if element.class != args }
      elsif !arg.nil? && args.instance_of?(Regexp)
        my_each { |element| return false unless arg.match(element) }
      else
        my_each { |element| return false if element != args }
      end
      true
    end
  
    def my_any?(args = nil)
      if block_given?
        my_each { |element| return true if yield(element) }
        false
      elsif arg.nil?
        my_each { |element| return true if n.nil? || element == true }
      elsif !arg.nil? && (args.is_a? Class)
        my_each { |element| return true if element.instance_of?(args) }
      elsif !arg.nil? && args.instance_of?(Regexp)
        my_each { |element| return true if arg.match(element) }
      else
        my_each { |element| return true if element == args }
      end
      false
    end
  
    def my_none(args = nil)
      if !block_given? && args.nil?
        my_each { |num| return true if num }
        return false
      end
  
      if !block_given? && !args.nil?
  
        if args.is_a?(Class)
          my_each { |num| return false if num.instance_of?(args) }
          return true
        end
  
        if args.instance_of?(Regexp)
          my_each { |num| return false if args.match(num) }
          return true
        end
  
        my_each { |num| return false if num == args }
        return true
      end
  
      my_any? { |num| return false if yield(num) }
      true
    end
  
    def my_count(num)
      arr = instance_of?(Array) ? self : to_a
      return arr.length unless block_given? || num
      return arr.my_select { |item| item == num }.length if num
  
      arr.my_select { |item| yield(item) }.length
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
  