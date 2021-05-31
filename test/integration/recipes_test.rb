require "test_helper"

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "levi", email: "levi@example.com")
    @recipe = Recipe.create(name: "italian pizza", description: "great pizza", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "breakfast burrito", description: "great breakfast")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipe listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end

end
