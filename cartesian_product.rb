class CartesianProduct
  include Enumerable
  
  attr_accessor :final_array
  
  def each
    @final_array.each {|elt| yield elt}
  end

  def initialize(first, second)
    @final_array = []
    first.each do |firstElement|
      second.each do |secondElement|
        @final_array.push [firstElement, secondElement]
      end
    end
  end
end

c = CartesianProduct.new([:a,:b], [4,5])
c.each { |elt| puts elt.inspect }
# [:a, 4]
# [:a, 5]
# [:b, 4]
# [:b, 5]

c = CartesianProduct.new([:a,:b], [6, 2, 6, :eran])
c.each { |elt| puts elt.inspect }
# (nothing printed since Cartesian product
# of anything with an empty collection is empty)