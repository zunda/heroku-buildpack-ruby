require 'beefcake'

module Kello
  class BuildpackMessage
    include Beefcake::Message

    required :start,      :float,  1
    required :end,        :float,  2
    required :name,       :string, 3
    required :depth,      :uint32, 4
    required :duration,   :float,  5
    required :request_id, :string, 6
  end
end
