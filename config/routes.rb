Rails.application.routes.draw do
  devise_for :users

  # Routes for the Recipe resource:

  get("/",{:controller => "recipes", :action => "index"})
  # CREATE
  post("/insert_recipe", { :controller => "recipes", :action => "create" })

  # READ
  get("/recipes", { :controller => "recipes", :action => "index" })

  get("/recipes/:path_id", { :controller => "recipes", :action => "show" })

  # UPDATE

  post("/modify_recipe/:path_id", { :controller => "recipes", :action => "update" })

  # DELETE
  get("/delete_recipe/:path_id", { :controller => "recipes", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
