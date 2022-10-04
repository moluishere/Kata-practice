class GildedRose

  def initialize(items)
    @items = items
  end


def update_quality()
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        item.quality += 1 if item.quality < 50
        item.sell_in -= 1
        item.quality += 1 if item.quality < 50 && item.sell_in < 0
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.quality += 1 if item.quality < 50
        item.quality += 1 if item.quality < 50 && item.sell_in < 11
        item.quality += 1 if item.quality < 50 && item.sell_in < 6
        item.sell_in -= 1
        item.quality = 0 if item.sell_in < 0
      when 'Sulfuras, Hand of Ragnaros'
      else
        item.quality -= 1 if item.quality > 0
        item.sell_in -= 1
        item.quality -= 1 if item.quality > 0 && item.sell_in < 0
      end
    end
  end
end


class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
