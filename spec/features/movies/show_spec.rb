require 'rails_helper'

RSpec.describe '/movies/:id' do
  before :each do
    @us = Studio.create!(name: 'Universal Studio', location: 'Hollywood')

    @marry = @us.movies.create!(title: 'Marry Me', creation_year: '2022', genre: 'Romance')

    @jenni = Actor.create!(name: 'Jennifer Lopez', age: 54)
    @owen = Actor.create!(name: 'Owen Wilson', age: 55)
    @sarah = Actor.create!(name: 'Sarah Silverman', age: 52)
    @chloe = Actor.create!(name: 'Chloe Coleman', age: 14)
    @john = Actor.create!(name: 'John Bradley', age: 35)

    MovieActor.create!(movie: @marry, actor: @jenni)
    MovieActor.create!(movie: @marry, actor: @owen)
    MovieActor.create!(movie: @marry, actor: @sarah)
    MovieActor.create!(movie: @marry, actor: @chloe)
  end

  describe 'as a visitor' do
    describe 'when I visit /movies/:id' do
      it 'shows movie title, creation year, genre' do
        visit "/movies/#{@marry.id}"

        expect(page).to have_content('Movie Title: Marry Me')
        expect(page).to have_content('Movie Creation Year: 2022')
        expect(page).to have_content('Movie Genre: Romance')
      end
      
      it 'shows list of actors from youngest to oldest' do
        visit "/movies/#{@marry.id}"

        expect(@chloe.name).to appear_before(@sarah.name)
        expect(@sarah.name).to appear_before(@jenni.name)
        expect(@jenni.name).to appear_before(@owen.name)
      end
    
      it 'shows average age of actors' do
        visit "/movies/#{@marry.id}"

        expect(page).to have_content('Average Actors Age: 44')
      end

      it 'add existing actors to movie show page' do
        visit "/movies/#{@marry.id}"
        expect(page).to_not have_content(@john.name)

        fill_in("Actor ID", with: @john.id)

        click_button("Submit")

        expect(current_path).to eq("/movies/#{@marry.id}")
        expect(page).to have_content(@john.name)
      end
    end
  end
end