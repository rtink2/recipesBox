require "test_helper"

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Levi", email: "levi@example.com",
              password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Blood pizza", description: "Great pizza", chef: @chef)
  end

  test "reject invalid recipe  update" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "vampire food"}}
    assert_template 'recipes/edit'
    assert_select 'h2.error-title'
    assert_select 'div.error-body'
  end

  test "successfully edit a recipe" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "updated blood pizza"
    updated_description = "best food for vampires with blood toppings"
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description }}
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end

end
