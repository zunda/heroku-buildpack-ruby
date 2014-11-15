require_relative 'spec_helper'

describe "Ruby apps" do
  describe "Rake detection" do
    context "default" do
      it "adds default process types" do
        Hatchet::Runner.new('empty-procfile').deploy do |app|
          app.run("console") do |console|
            console.run("'hello' + 'world'") {|result| expect(result).to match('helloworld')}
          end
        end
      end
    end

    context "Ruby 1.9+" do
      it "runs rake tasks if no rake gem" do
        Hatchet::Runner.new('mri_200_no_rake').deploy do |app, heroku|
          expect(app.output).to include("foo")
        end
      end

      it "runs a rake task if the gem exists" do
        Hatchet::Runner.new('mri_200_rake').deploy do |app, heroku|
          expect(app.output).to include("foo")
        end
      end
    end
  end
end
