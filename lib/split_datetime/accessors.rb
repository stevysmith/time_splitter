module SplitDatetime
  module Accessors
    def accepts_split_datetime_for(*attrs)
      opts = { format: "%F" }.merge!(attrs.extract_options!)

      attrs.each do |attr|
        attr_accessible "#{attr}_date", "#{attr}_hour", "#{attr}_min", "#{attr}_time" if needs_attr_accessible?

        define_method("#{attr}_or_new") do
          self.send(attr) || Time.new
        end

        define_method("#{attr}_date=") do |date|
          return unless date.present?
          date = Date.parse(date.to_s)
          self.send("#{attr}=", self.send("#{attr}_or_new").change(year: date.year, month: date.month, day: date.day))
        end

        define_method("#{attr}_hour=") do |hour|
          return unless hour.present?
          self.send("#{attr}=", self.send("#{attr}_or_new").change(hour: hour))
        end

        define_method("#{attr}_min=") do |min|
          return unless min.present?
          self.send("#{attr}=", self.send("#{attr}_or_new").change(min: min))
        end
        
        composed_of "#{attr}_time".to_sym, class_name: 'DateTime'
        
        define_method("#{attr}_time=") do |time|
          return unless time.present?
          time = DateTime.parse(time) unless time.is_a?(Date) || time.is_a?(Time)
          self.send("#{attr}=", self.send("#{attr}_or_new").change(hour: time.hour, min: time.min))
        end

        define_method("#{attr}_date") do
          self.send(attr).strftime(opts[:format])
        end

        define_method("#{attr}_hour") do
          self.send(attr).hour
        end

        define_method("#{attr}_min") do
          self.send(attr).min
        end
        
        define_method("#{attr}_time") do
          self.send(attr).to_time
        end
      end
    end
    
    private
    
      def needs_attr_accessible?
        rails_3? && !strong_parameters_enabled?
      end
  
      def rails_3?
        Rails::VERSION::MAJOR == 3
      end
  
      def strong_parameters_enabled?
        defined?(ActionController::StrongParameters)
      end
      
  end
end
