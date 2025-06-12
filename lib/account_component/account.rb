module AccountComponent
  class Account
    include Schema::DataStructure

    attribute :id, String
    attribute :customer_id, String
    attribute :balance, Numeric, default: proc { 0 }
    attribute :opened_time, Time
    attribute :closed_time, Time
    attribute :frozen_time, Time
    attribute :sequence, Integer

    def open?
      !opened_time.nil?
    end

    def closed?
      !closed_time.nil?
    end

    def frozen?
      !frozen_time.nil?
    end

    def unfreeze
      self.frozen_time = nil
    end

    def deposit(amount)
      self.balance += amount
    end

    def withdraw(amount)
      self.balance -= amount
    end

    def sufficient_funds?(amount)
      balance >= amount
    end

    def processed?(message_sequence)
      return false if sequence.nil?

      sequence >= message_sequence
    end
  end
end
