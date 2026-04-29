module FuncSet
	def |(other) # union
		self.class.new(entries + other.entries) { |x, y| cmp(x, y) }
	end
	def &(other) # intersect
		common = self.map { |x| other.find { |y| self.cmp(x, y) == 0 } }
		self.class.new(common) { |x, y| cmp(x, y) }
	end
end

class MySet
  include Enumerable
  include FuncSet
  attr_reader :entries

  def initialize(items = [], &block)
    @comparator = block || lambda { |a, b| a <=> b }
    @entries = []
    items.each { |item| insert(item) }
  end

  def to_s
    "[#{@entries.join(', ')}]"
  end

  def cmp(x, y)
    @comparator.call(x, y)
  end

  def insert(item)
    return if item.nil? || @entries.any? { |e| cmp(e, item) == 0 }
    @entries << item
    @entries.sort! { |a, b| cmp(a, b) }
  end

  def each(&block)
    @entries.each(&block)
  end

end