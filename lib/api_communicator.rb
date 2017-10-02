class APICommunicator < ActiveRecord::Base

  def lookup_lat_long(city_num)
    lat_long = []
    lat_long = locations.
  end

  def get_character_movies_from_api(character)
    #make the web request
    # iterate over the character hash to find the collection of `films` for the given
    #   `character`
    # collect those film API urls, make a web request to each URL to get the info
    #  for that film
    # return value of this method should be collection of info about each film.
    #  i.e. an array of hashes in which each hash reps a given film
    # this collection will be the argument given to `parse_character_movies`
    #  and that method will do some nice presentation stuff: puts out a list
    #  of movies by title. play around with puts out other info about a given film.
    url = "https://mobilesvc.sickweather.com/ws/v2.0/sickscore/getSickScoreInRadius.php?lat=#{latitude}&lon=#{longitude}&api_key=bxczslindv3loayvgy8il3ko3tkxk55v"

    while url != nil
      all_characters = RestClient.get(url)
      character_hash = JSON.parse(all_characters)

      character_hash["results"].each do |hash|
        if hash["name"] == character
          return hash["films"]
        end
      end

      url = character_hash["next"]
    end

    return nil
  end

  def parse_character_movies(films_hash)
    # some iteration magic and puts out the movies in a nice list
    count = 1
    films_hash.each do |film_url|
      returned_hash = RestClient.get(film_url)
      parsed_hash = JSON.parse(returned_hash)
      puts count.to_s + " " + parsed_hash["title"]
      count += 1
    end
  end

  def show_character_movies(character)
    films_hash = get_character_movies_from_api(character)
    if films_hash == nil
      puts "Sorry, #{character} was not found."
    else
      parse_character_movies(films_hash)
    end
  end

end
