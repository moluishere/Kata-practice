require 'spec_helper'

# NOTE uncomment one of the lines to run tests for proper GildedRose class
require File.join(File.dirname(__FILE__) + '/..', 'gilded_rose')
#require File.join(File.dirname(__FILE__) + '/..', 'gilded_rose_refactored_1')
# require File.join(File.dirname(__FILE__) + '/..', 'gilded_rose_refactored_2')

describe GildedRose do

  describe '#update_quality' do
    # ######################################################################
    # Shared examples
    # ######################################################################
    shared_examples 'default item sell in' do |item_name|
      it 'lowers sell in value by 1 at the end of the day' do
        item = Item.new(item_name, sell_in=1, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.sell_in).to eq 0
      end

      it 'lowers sell in value by N after N days' do
        n = 10
        item = Item.new(item_name, sell_in=n, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)

        n.times do |i|
          gilded_rose.update_quality
          expect(item.sell_in).to eq (n - (i + 1))
        end

        expect(item.sell_in).to eq 0
      end

      it 'sell in value can be negative' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.sell_in).to eq -1
      end
    end

    shared_examples 'quality value' do |item_name|
      it 'quality value is never negative' do
        item = Item.new(item_name, sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to eq 0
      end

      it 'quality value is never more than 50' do
        item = Item.new(item_name, sell_in=20, quality=50)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.quality).to be <= 50
      end
    end

    # ######################################################################
    # Default item
    # ######################################################################
    context 'item name' do
      it 'does not change the name' do
        item = Item.new('foo', sell_in=0, quality=0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.name).to eq 'foo'
      end
    end

    it_behaves_like 'default item sell in', item_name='foo'

    context 'item quality' do
      it_behaves_like 'quality value', item_name='foo'

      context 'when sell in date not passed yet' do
        it 'lowers quality value by 1 at the end of the day' do
          item = Item.new('foo', sell_in=1, quality=1)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eq 0
        end

        it 'lowers quality value by N after N days' do
          n = 10
          item = Item.new('foo', sell_in=n, quality=n)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do |i|
            gilded_rose.update_quality
            expect(item.quality).to eq (n - (i + 1))
          end

          expect(item.quality).to eq 0
        end
      end

      context 'when sell in date has passed' do
        it 'lowers quality value by 2 at the end of the day' do
          item = Item.new('foo', sell_in=0, quality=4)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eq 2
        end

        it 'lowers quality value twice as fast after N days' do
          n = 5
          quality = 15
          item = Item.new('foo', sell_in=0, quality=quality)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do |i|
            gilded_rose.update_quality
            expect(item.quality).to eq (quality - (2 * (i+1)))
          end

          expect(item.quality).to eq (quality - (2 * n))
        end
      end
    end

    # ######################################################################
    # Item: Aged Brie
    # ######################################################################
    context 'when item is Aged Brie' do
      it_behaves_like 'default item sell in', item_name='Aged Brie'

      context 'item quality' do
        context 'when sell in date not passed yet' do
          it 'increases by 1 the older it gets' do
            n = 5
            item = Item.new('Aged Brie', sell_in=n, quality=0)
            items = [item]
            gilded_rose = described_class.new(items)

            n.times do |i|
              gilded_rose.update_quality
              expect(item.quality).to eq (i + 1)
            end

            expect(item.quality).to eq n
          end
        end

        context 'when sell in date has passed' do
          it 'increases twice as fast the older it gets' do
            n = 5
            item = Item.new('Aged Brie', sell_in=0, quality=0)
            items = [item]
            gilded_rose = described_class.new(items)

            n.times do |i|
              gilded_rose.update_quality
              expect(item.quality).to eq (2 * (i + 1))
            end

            expect(item.quality).to eq (2 * n)
          end
        end

        it 'is never more than 50' do
          n = 2
          item = Item.new('Aged Brie', sell_in=n, quality=49)
          items = [item]
          gilded_rose = described_class.new(items)

          n.times do
            gilded_rose.update_quality
          end

          expect(item.quality).to eq 50
        end
      end
    end

    # ######################################################################
    # Sulfuras, Hand of Ragnaros
    # ######################################################################
    context 'when item is Sulfuras, Hand of Ragnaros' do
      context 'item sell in' do
        it 'does not change the sell in' do
          item = Item.new('Sulfuras, Hand of Ragnaros', sell_in=0, quality=0)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.sell_in).to eql 0
        end
      end

      context 'item quality' do
        it_behaves_like 'quality value', item_name='Sulfuras, Hand of Ragnaros'

        it 'does not change the quality' do
          item = Item.new('Sulfuras, Hand of Ragnaros', sell_in=0, quality=0)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eql 0
        end
      end
    end

    # ######################################################################
    # Backstage passes to a TAFKAL80ETC concert
    # ######################################################################
    context 'when item is Backstage passes to a TAFKAL80ETC concert' do
      it_behaves_like 'default item sell in', item_name='Backstage passes to a TAFKAL80ETC concert'

      context 'item quality' do
        it_behaves_like 'quality value', item_name='Backstage passes to a TAFKAL80ETC concert'

        context 'when sell in date not passed yet' do
          context 'when sell in above 10 days' do
            it 'increases by 1 the older it gets' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + i + 1)
              end

              expect(item.quality).to eq (quality + n)
            end

            it 'increases to 50 when sell_in above 10 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end

            it 'increases to 50 instead of 51 when sell_in at least 5 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=5, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end

          context 'when sell in 10 days or less and above 5 days' do
            it 'increases by 2 the older it gets' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=10, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + 2 * (i + 1))
              end

              expect(item.quality).to eq (quality + (2 * n))
            end

            it 'increases to 50 instead of 52 when sell_in at least 1 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=1, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end

          context 'when sell in 5 days or less' do
            it 'increases by 3 the older it gets' do
              n = 5
              quality = 1
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=5, quality=quality)
              items = [item]
              gilded_rose = described_class.new(items)

              n.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality + 3 * (i + 1))
              end

              expect(item.quality).to eq (quality + (3 * n))
            end

            it 'increases to 50 instead of 52 when sell_in at least 1 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=1, quality=49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality

              expect(item.quality).to eq 50
            end
          end
        end

        context 'when sell in date has passed' do
          it 'drops to 0 after the concert' do
            item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in=0, quality=5)
            items = [item]
            gilded_rose = described_class.new(items)
            gilded_rose.update_quality

            expect(item.quality).to eq 0
          end
        end
      end
    end

    # ######################################################################
    # Conjured Mana Cake
    # ######################################################################
    #
    # This is a new feature not yet implemented in GildedRose
    # use :skip tag to skip those tests
    # use :xskip or remove tag to run those tests
    #
    # context 'when item is Conjured Mana Cake', :skip do
    #   it_behaves_like 'default item sell in', 'Conjured Mana Cake'
    #
    #   context 'item quality' do
    #     it_behaves_like 'quality value', item_name='Conjured Mana Cake'
    #
    #     it 'lowers quality value by 2 at the end of the day' do
    #       item = Item.new('Conjured Mana Cake', sell_in=1, quality=2)
    #       items = [item]
    #       gilded_rose = described_class.new(items)
    #       gilded_rose.update_quality
    #
    #       expect(item.quality).to eq 0
    #     end
    #
    #     it 'lowers quality value twice as fast after N days' do
    #       quality = 15
    #       item = Item.new('Conjured Mana Cake', sell_in=1, quality=quality)
    #       items = [item]
    #       gilded_rose = described_class.new(items)
    #
    #       gilded_rose.update_quality
    #       expect(item.quality).to eq (13)
    #
    #       gilded_rose.update_quality
    #       expect(item.quality).to eq (9)
    #
    #       gilded_rose.update_quality
    #       expect(item.quality).to eq (5)
    #
    #       gilded_rose.update_quality
    #       expect(item.quality).to eq (1)
    #
    #       gilded_rose.update_quality
    #       expect(item.quality).to eq (0)
    #     end
    #   end
    # end

  end

end
