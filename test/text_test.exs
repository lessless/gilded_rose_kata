defmodule GildedRose.ReportTest do
  use ExUnit.Case

  test "report" do
    items = [
      %Item{name: "+5 Dexterity Vest", sell_in: 10, quality: 20},
      %Item{name: "Aged Brie", sell_in: 2, quality: 0},
      %Item{name: "Elixir of the Mongoose", sell_in: 5, quality: 7},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49},
      # This Conjured item does not work properly yet
      %Item{name: "Conjured Mana Cake", sell_in: 3, quality: 6}
    ]

    %{report_lines: report_lines} =
      Enum.reduce(0..1, %{items: items, report_lines: []}, fn day,
                                                              %{
                                                                items: items,
                                                                report_lines: report_lines
                                                              } ->
        report_lines = report_lines ++ ["-------- day #{day} --------"]
        report_lines = report_lines ++ ["name, sellIn, quality"]

        report_lines =
          report_lines ++
            [Enum.map(items, fn item -> "#{item.name}, #{item.sell_in}, #{item.quality}" end)]

        report_lines = report_lines ++ [""]

        %{
          items: GildedRose.update_quality(items),
          report_lines: List.flatten(report_lines)
        }
      end)

    assert [
             "-------- day 0 --------",
             "name, sellIn, quality",
             "+5 Dexterity Vest, 10, 20",
             "Aged Brie, 2, 0",
             "Elixir of the Mongoose, 5, 7",
             "Sulfuras, Hand of Ragnaros, 0, 80",
             "Sulfuras, Hand of Ragnaros, -1, 80",
             "Backstage passes to a TAFKAL80ETC concert, 15, 20",
             "Backstage passes to a TAFKAL80ETC concert, 10, 49",
             "Backstage passes to a TAFKAL80ETC concert, 5, 49",
             "Conjured Mana Cake, 3, 6",
             "",
             "-------- day 1 --------",
             "name, sellIn, quality",
             "+5 Dexterity Vest, 9, 19",
             "Aged Brie, 1, 1",
             "Elixir of the Mongoose, 4, 6",
             "Sulfuras, Hand of Ragnaros, 0, 80",
             "Sulfuras, Hand of Ragnaros, -1, 80",
             "Backstage passes to a TAFKAL80ETC concert, 14, 21",
             "Backstage passes to a TAFKAL80ETC concert, 9, 50",
             "Backstage passes to a TAFKAL80ETC concert, 4, 50",
             "Conjured Mana Cake, 2, 5",
             ""
           ] == report_lines
  end
end
