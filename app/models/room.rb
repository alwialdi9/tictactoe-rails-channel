class Room < ApplicationRecord
  extend FriendlyId
  include Board

  serialize :players, Array
  serialize :board, Array

  friendly_id :name, use: [:slugged, :finders]

  validates :name, uniqueness: true, presence: true

  before_create :assign_board

  def assign_board
    self.board = [""] * 9
  end

  def update_board(params)
    self.board[params["index"].to_i] = params["current"]
    self.current = params["current"] == "X" ? "O" : "X"

    save
  end

  def player_exist?(uuid)
    players.length > 1 || players.include?(uuid)
  end

  def is_played?(uuid)
    puts players
    (current == "O" && players.first == uuid) || (current == "X" && players.second == uuid)
  end

  def clear
    assign_board
    self.current = "X"
    save
  end
end
