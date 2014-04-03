require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "side bar content" do

  	describe "should contain the micropost sidebar (with elements)" do
  		before { create_valid_micropost_and_submit("Lorem ipsum") }

  		it { should have_selector("img.gravatar") }
  		it { should have_selector("span.user_name") }
  		it { should have_selector("span.microposts") }
  	end

  	describe "should conatin a single miropost with correct pluralization" do
  		before { create_valid_micropost_and_submit("Lorem ipsum") }

  		it { should_not have_selector("span.microposts", text: "microposts") } #plural
  		it { should have_selector("span.microposts", exact: "1 micropost")   } #singular  
  	end

  	describe "should contain 2 microposts with correct pluralization" do
  		before do
  			create_valid_micropost_and_submit("Lorem ipsum")
  			create_valid_micropost_and_submit("Lorem ipsum two")
  		end

  		it { should_not have_selector("span.microposts", text: /micropost$/) } #singular
  		it { should have_selector("span.microposts", exact: "2 microposts")  }  #plural
  	end
  end

  describe "pagination" do
  	#after(:all) { user.microposts.delete_all unless user.microposts.nil? }
  	before do
  		40.times { FactoryGirl.create(:micropost, user: user) }
  		visit root_path
  	end

  	it { should have_selector('div.pagination') }
  end

  describe "should not have delete links in microposts from other users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
    before do
    	sign_in other_user
    	create_valid_micropost_and_submit('Lorem ipsum')
    	sign_in user
    	visit user_path(user)
    end

    it { should_not have_selector("a", text: 'delete') }
  end

  def create_valid_micropost_and_submit(string)
  	visit root_path
  	fill_in 'micropost_content', with: string
  	click_button "Post"
  end

end
