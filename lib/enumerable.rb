# encoding: utf-8

module Enumerable
  def collect_with_index(i = -1)
    collect { |elm| yield(elm, i += 1) }
  end
  alias map_with_index collect_with_index
end