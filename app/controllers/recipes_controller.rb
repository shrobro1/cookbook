class RecipesController < ApplicationController

  def home
    require "openai"

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
    if current_user == nil
      redirect_to("/users/sign_in", { :alert => "You must be signed in to create a recipe." })
      return
    end

    the_recipe = Recipe.new
    the_recipe.title = params.fetch("query_title")
    the_recipe.description = params.fetch("query_description")
    the_recipe.ingredients = params.fetch("query_ingredients")
    the_recipe.instructions = params.fetch("query_instructions")
    the_recipe.servings = params.fetch("query_servings")
    the_recipe.creator_id = current_user.id
   

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
    if current_user == nil
      redirect_to("/users/sign_in", { :alert => "You must be signed in to create a recipe." })
      return
    end

     user_input = params[:query_prompt]

      # Initialize OpenAI client
      client = OpenAI::Client.new
      
      

     begin
       completion = client.chat.completions.create(
         model: "gpt-4o-mini",
         response_format: { type: "json_object" },
         messages: [
            { role: "system", content: "
              You are a recipe extraction engine.
              Given a description or recipe content, you MUST return a JSON object
              with exactly these keys:

              {
                title: string,
                description: string,
                ingredients: string,
                instructions: string,
                servings: integer
              }

              - ingredients should be a multiline string, one ingredient per line.
              - instructions should be a multiline string, one step per line.
              - Do not include any other keys.
              - Do not include any text before or after the JSON." },
            { role: "user", content: user_input }
         ],
          
        )

       json_string = completion.choices.first.message.content
       @data = JSON.parse(json_string)

      

    rescue => e
      @error = "Error talking to OpenAI: #{e.class} - #{e.message}"
      
     end
      render({ :template => "recipe_templates/response" })
  end

  def my_index
    matching_recipes = Recipe.where({ :creator_id => current_user.id})
    @list_of_recipes = matching_recipes.order({ :created_at => :desc })

    render({ :template => "recipe_templates/my_recipes" })
  end

  def user_link
    if current_user == nil
      redirect_to("/users/sign_in", { :alert => "You must be signed in to create a recipe." })
      return
    end

     url = params[:query_link]
     webpage = HTTP.get(url)
     parsed_page = Nokogiri::HTML(webpage.body.to_s)

      # Initialize OpenAI client
      client = OpenAI::Client.new
      
      

     begin
       completion = client.chat.completions.create(
         model: "gpt-4o-mini",
         response_format: { type: "json_object" },
         messages: [
            { role: "system", content: "
              You are a recipe extraction engine.
              Given a link to recipe content, you MUST return a JSON object
              with exactly these keys:

              {
                title: string,
                description: string,
                ingredients: string,
                instructions: string,
                servings: integer
              }

              - ingredients should be a multiline string, one ingredient per line.
              - instructions should be a multiline string, one step per line.
              - Do not include any other keys.
              - Do not include any text before or after the JSON." },
            { role: "user", content: parsed_page.text }
         ],
          
        )

       json_string = completion.choices.first.message.content
       @data = JSON.parse(json_string)

      

    rescue => e
      @error = "Error talking to OpenAI: #{e.class} - #{e.message}"
      
     end
      render({ :template => "recipe_templates/response" })
  end




end
