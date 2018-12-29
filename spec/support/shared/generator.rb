shared_examples 'everything works' do
  it 'should run all tasks in the generator' do
    gen = generator(arguments)
    expect(gen).to receive :bundle_dependencies
    expect(gen).to receive :configure_application
    expect(gen).to receive :localize_russian
    expect(gen).to receive :localize_devise
    expect(gen).to receive :inject_routes
    expect(gen).to receive :localize_pages
    expect(gen).to receive :inject_files
    capture(:stdout) { gen.invoke_all }
  end

  it "generator runs without errors" do
    expect { run_generator(arguments) }.not_to raise_error
  end
end

shared_examples 'Gemfile' do
  describe 'the Gemfile' do
    subject { file('Gemfile') }

    it { is_expected.to exist }
    it { is_expected.to contain(/gem 'globalize'/) }
  end
end

shared_examples 'config/application.rb' do
  describe 'config/application.rb' do
    subject { file('config/application.rb') }

    it { is_expected.to exist }
    it { is_expected.to contain(/config\.i18n/) }
  end
end
