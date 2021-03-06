# frozen_string_literal: true

describe 'PathResolver' do
  context '#resolve path' do
    it 'detects path' do
      expect(PathResolver.resolve(:path)).to eql(ENV['PATH'])
    end
  end
end
