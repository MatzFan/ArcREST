notification :gntp

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^lib/(.+).rb$}) do |m| # watch /lib/ files
    "spec/#{m[1]}_spec.rb"
  end

  watch(%r{^spec/(.+).rb$}) do |m| # watch /spec/ files
    "spec/#{m[1]}.rb"
  end

  watch('spec/spec_helper.rb') { 'spec' }
end
