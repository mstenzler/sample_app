require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submition" do
      	before { click_button submit }

      	it { should have_title('Sign up') }
      	it { should have_content('error') }
      end

      describe "after submit with bad email" do
      	before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Email is invalid') }
      end

      describe "after submit with blank password" do
      	before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: ""
          fill_in "Confirmation", with: ""
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password can\'t be blank') }
      end

      describe "after submit with blank name" do
      	before do
          fill_in "Name",         with: ""
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Name can\'t be blank') }
      end

      describe "after submit with blank email" do
      	before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: ""
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Email can\'t be blank') }
      end

    	describe "after submit with mismatched password confirmation" do
      	before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foo"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password confirmation doesn\'t match Password') }
      end

     	describe "after submit with password too short" do
      	before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foo"
          fill_in "Confirmation", with: "foo"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password is too short ') }
      end
     
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end
end


