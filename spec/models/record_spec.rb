require 'rails_helper'

RSpec.describe Record do
  describe '#create_all_his' do
    it 'create many records' do
      start = Date.new(2014, 10, 8)
      days = (Date.today - start).to_i
      rest_days = (Date.today - start).to_i % Record::REPORT_CYCLE
      monthds = ((days - rest_days) / Record::REPORT_CYCLE) + 1
      Record.create_all_his
      expect(Record.all.size).to eq monthds * Record::REPORT_LIST.length
    end
  end

  describe '#create_reports' do
    it 'returns 8 reports' do
      start_day = Date.new(2014, 10, 8)
      Timecop.freeze(start_day + 7) do
        Record.create_all_his
        results = Record.create_reports
        expect(results.size).to eq 1 + Record::REPORT_LIST.length
      end
    end
  end
end
