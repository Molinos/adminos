require 'support/generators'

RSpec.describe Adminos::Generators::CiGenerator, type: :generator do
  set_default_destination('dummy_ci')
  generate_rails(destination_root)
  generate('adminos:ci')

  context 'CI' do
    describe ".gitlab-ci.ym" do
      subject { file(".gitlab-ci.yml") }

      it { is_expected.to exist }
    end
  end

  context 'spec' do
    describe "Gemfile" do
      subject { file("Gemfile") }
      it { is_expected.to contain /gem 'rspec-rails'/ }
    end

    describe "bin/rspec" do
      subject { file("bin/rspec") }
      it { is_expected.to exist }
    end

    describe ".gitlab-ci.ym" do
      subject { file(".gitlab-ci.yml") }

      it { is_expected.to contain  /^spec\:/ }
    end
  end

  context 'audit' do
    describe "Gemfile" do
      subject { file("Gemfile") }
      it { is_expected.to contain /gem 'bundler-audit'/ }
    end

    describe "bin/bundler-audit" do
      subject { file("bin/bundler-audit") }
      it { is_expected.to exist }
    end

    describe "rakelib/audit.rake" do
      subject { file("rakelib/audit.rake") }
      it { is_expected.to exist }
    end

    describe ".gitlab-ci.yml" do
      subject { file(".gitlab-ci.yml") }
      it { is_expected.to contain /^audit\:/ }
    end
  end

  context 'lint' do
    describe "Gemfile" do
      subject { file("Gemfile") }

      it { is_expected.to contain /gem 'rubocop'/ }
    end

    describe "bin/rubocop" do
      subject { file("bin/rubocop") }
      it { is_expected.to exist }
    end

    describe "rakelib/lint.rake" do
      subject { file("rakelib/lint.rake") }
      it { is_expected.to exist }
    end

    describe ".rubocop.yml" do
      subject { file(".rubocop.yml") }
      it { is_expected.to exist }
    end

    describe ".rubocop_todo.yml" do
      subject { file(".rubocop_todo.yml") }
      it { is_expected.to exist }
    end

    describe ".gitlab-ci.yml" do
      subject { file(".gitlab-ci.yml") }
      it { is_expected.to contain /^lint\:/ }
    end
  end
end
