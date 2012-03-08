class Numeric
  @@currencies = {'dollar' => 1.000, 'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}
  def method_missing(method_id, *args)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    conversion_currency = args[0].to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    elsif method_id.to_s == 'in'
      if @@currencies.has_key? conversion_currency
        self / @@currencies[conversion_currency]
      else
        puts 'There is no such currency'
      end
    else
      super
    end
  end
end

#puts 10.euros.in :dollars

class String
  def palindrome?
    string = self.gsub(/[^0-9a-z]/i, '')
    string.downcase == string.downcase.reverse
  end
end

#puts "foo".palindrome?
#puts "naan".palindrome?
#puts 'A man, a plan, a canal -- Panama'.palindrome? 

module Enumerable
  def palindrome?
    new_array = self.collect {|x| x}
    new_array == new_array.reverse
  end
end

{"Hello" => "World"}.palindrome?
