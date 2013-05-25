require_relative 'spec_helper'

describe "JRuby" do
  context "1.9mode" do
    it "should compile assets properly" do
      Hatchet::AnvilApp.new("rails3_jruby_193").deploy do |app|
        expect(app.output).to match("Your bundle is complete!")
        app.run('bash') do |cmd|
          cmd.run('cd public/assets')
          expect(cmd.run('ls')).to include('application.js')
          expect(cmd.run('cat application.js')).not_to include('JAVA_TOOL_OPTIONS: -Djava.rmi.server.useCodebaseOnly')
        end
      end
    end
  end
end
