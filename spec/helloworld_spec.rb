require_relative "../helloworld.rb"
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

describe Helloworld do
  it "displays a name." do
    # helloworld = Helloworld.new
    # expect()
  end

  context '#west_of' do
    it "shows location is west of another" do
      VCR.use_cassette("west_of_shows_location_is_west_of_another") do
        helloworld = Helloworld.new
        helloworld.say_hello("@alterisian", "Málaga, Spain")
        helloworld.say_hello("@bsilva96", "Machalí, Chile")    

        expect( helloworld.west_of("@alterisian") ).to eq(["@bsilva96, Machalí, Chile"])  
      end
    end

    it 'returns three people west of a given person' do
      VCR.use_cassette("west_of_returns_three_people_west_of_a_given_person") do
        helloworld = Helloworld.new
        helloworld.say_hello("@theOnlyMaDDogx", "New Delhi, India")
        helloworld.say_hello("@alterisian", "Málaga, Spain")
        helloworld.say_hello("@bsilva96", "Machalí, Chile")
        helloworld.say_hello("@lucianghinda", "Bucharest, Romania")

        expect( helloworld.west_of("@theOnlyMaDDogx") ).to eq(["@alterisian, Málaga, Spain", "@bsilva96, Machalí, Chile", "@lucianghinda, Bucharest, Romania"])
      end
    end

    it 'generates tweetable output' do
      VCR.use_cassette("west_of_generates_tweetable_output") do
        helloworld = Helloworld.new
        helloworld.say_hello("@theOnlyMaDDogx", "New Delhi, India")
        helloworld.say_hello("@alterisian", "Málaga, Spain")
        helloworld.say_hello("@bsilva96", "Machalí, Chile")
        helloworld.say_hello("@lucianghinda", "Bucharest, Romania")
        people_west_of = helloworld.west_of("@theOnlyMaDDogx")
        location = "New Delhi, India"

        expect( helloworld.generate_tweet(people_west_of, location) ).to eq(<<~TWEET
          Hey @alterisian, @bsilva96, @lucianghinda, #helloworld_rb is almost finished in New Delhi, India.
          Can we hand over the mob to you?
          Join https://meet.jit.si/TodayMálagaTomorrowWeMake
          Please fill out the following form to share your availability: https://forms.gle/BxVGGFqCxJd1i9w88
        TWEET
        )
      end
    end
  end
end
