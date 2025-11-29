class RecipesController < ApplicationController

def home
  require "openai"

  #client = OpenAI::Client.new

  #begin
    #completion = client.chat.completions.create(
      #model: :"gpt-4o-mini",
      #messages: [
        #{ role: "user", content: "Reply with exactly: API OK" }
      #]
    #)

   # @openai_test = completion.choices.first.message.content
  #rescue => e
   # @openai_test = "Error talking to OpenAI: #{e.class} - #{e.message}"
  #end

  render template: "recipe_templates/home"
end





  def index
    matching_recipes = Recipe.all

    @list_of_recipes = matching_recipes.order({ :created_at => :desc })

    render({ :template => "recipe_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_recipes = Recipe.where({ :id => the_id })

    @the_recipe = matching_recipes.at(0)

    render({ :template => "recipe_templates/show" })
  end

  def create
    the_recipe = Recipe.new
    the_recipe.title = params.fetch("query_title")
    the_recipe.description = params.fetch("query_description")
    the_recipe.ingredients = params.fetch("query_ingredients")
    the_recipe.instructions = params.fetch("query_instructions")
    the_recipe.servings = params.fetch("query_servings")
    the_recipe.creator_id = current_user.id
    the_recipe.source_url = params.fetch("query_source_url")

    if the_recipe.valid?
      the_recipe.save
      redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe created successfully." })
    else
      redirect_to("/recipes", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.title = params.fetch("query_title")
    the_recipe.description = params.fetch("query_description")
    the_recipe.ingredients = params.fetch("query_ingredients")
    the_recipe.instructions = params.fetch("query_instructions")
    the_recipe.servings = params.fetch("query_servings")
    the_recipe.creator_id = params.fetch("query_creator_id")
    the_recipe.source_url = params.fetch("query_source_url")

    if the_recipe.valid?
      the_recipe.save
      redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe updated successfully." } )
    else
      redirect_to("/recipes/#{the_recipe.id}", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.destroy

    redirect_to("/recipes", { :notice => "Recipe deleted successfully." } )
  end

  def user_prompt
     user_input = params[:query_prompt]

      # Initialize OpenAI client
      client = OpenAI::Client.new

     begin
       completion = client.chat.completions.create(
         model: "gpt-4o-mini",
         messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: user_input }
         ]
        )

       @answer = completion.choices.first.message.content
     rescue => e
       @answer = "Error talking to OpenAI: #{e.class} - #{e.message}"
     end
      render({ :template => "recipe_templates/response" })
  end

end
