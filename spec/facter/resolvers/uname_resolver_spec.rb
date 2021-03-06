# frozen_string_literal: true

describe 'UnameResolver' do
  before do
    allow(Open3).to receive(:capture2)
      .with('uname -m &&
        uname -n &&
        uname -p &&
        uname -r &&
        uname -s &&
        uname -v')
      .and_return('x86_64
        wifi.tsr.corp.puppet.net
        i386
        18.2.0
        Darwin
        Darwin Kernel Version 18.2.0: Fri Oct  5 19:41:49 PDT 2018; root:xnu-4903.221.2~2/RELEASE_X86_64')
  end
  it 'returns machine' do
    result = UnameResolver.resolve(:machine)

    expect(result).to eq('x86_64')
  end

  it 'returns nodename' do
    result = UnameResolver.resolve(:nodename)

    expect(result).to eq('wifi.tsr.corp.puppet.net')
  end

  it 'returns processor' do
    result = UnameResolver.resolve(:processor)

    expect(result).to eq('i386')
  end

  it 'returns kernelrelease' do
    result = UnameResolver.resolve(:kernelrelease)

    expect(result).to eq('18.2.0')
  end

  it 'returns kernelname' do
    result = UnameResolver.resolve(:kernelname)

    expect(result).to eq('Darwin')
  end

  it 'returns kernelversion' do
    result = UnameResolver.resolve(:kernelversion)

    expect(result).to include('root:xnu-4903.221.2~2/RELEASE_X86_64')
  end
end
