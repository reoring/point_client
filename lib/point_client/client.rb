require 'time'

module PointClient
  class Client
    def device(deviceId)
      PointClient.jsonConnection.get "/draft1/devices/#{deviceId}"
    end

    def avg(deviceId)
      result = PointClient.jsonConnection.get "/draft1/devices/#{deviceId}/sound_avg_levels"
      convertValues result.body['values']
    end

    def peak(deviceId)
      result = PointClient.jsonConnection.get "/draft1/devices/#{deviceId}/sound_peak_levels"
      convertValues result.body['values']
    end

    private

    def convertValues(rawValues)
      values = []
      rawValues.each do |x|
        values.push({datetime: Time.parse(x['datetime']).localtime, value: x['value'].to_i})
      end
      return values
    end
  end
end
