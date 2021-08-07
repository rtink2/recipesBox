require "test_helper"

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Levi", email: "levi@example.com",
              password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Maggie", email: "maggie@example.com",
            password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "Maggie1", email: "maggie1@example.com",
          password: "password", password_confirmation: "password",admin: true)
end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "levi@example.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "levi1", email: "levi1@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "levi1", @chef.chefname
    assert_match "levi1@example.com", @chef.email
  end

  test "accept edit of another user by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "levi1", email: "levi1@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "levi1", @chef.chefname
    assert_match "levi1@example.com", @chef.email
  end    
  

  test "reject edit by another user by a non-admin user" do
    sign_in_as(@chef2, "password")       
    patch chef_path(@chef), params: { chef: { chefname: "jack2", email: "jack2@example.com"}}
    assert_redirected_to chefs_path  
    assert_not flash.empty?
    @chef.reload 
    assert_match "Levi", @chef.chefname
    assert_match "levi@example.com", @chef.email    
  end

end
