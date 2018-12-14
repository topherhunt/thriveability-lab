module Services
  class BaseService
    def self.call(*args)
      self.new.call(*args)
    end

    def log(sev = :info, message)
      raise "Unknown severity #{sev}!" unless sev.to_s.in?(%w(info warn error))
      Rails.logger.send(sev, "#{self.class}: #{message}")
    end
  end
end
