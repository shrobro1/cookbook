desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  User.destroy_all
  user1 = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    user2 = User.create!(
      email: "chef@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

Recipe.destroy_all

    Recipe.create!(
      title: "Garlic Butter Pork Chops",
      description: "Simple seared pork chops cooked in garlic butter.",
      ingredients: <<~INGREDIENTS.strip,
        2 thick-cut pork chops
        2 tbsp butter
        3 cloves garlic, minced
        Salt & pepper, to taste
      INGREDIENTS
      instructions: <<~INSTRUCTIONS.strip,
        Season pork chops with salt and pepper.
        Heat butter in a skillet over medium-high heat.
        Add pork chops and sear 3–4 minutes per side until browned.
        Add minced garlic and baste chops with the garlic butter.
        Cook until pork reaches desired doneness, then serve.
      INSTRUCTIONS
      servings: 2,
      creator_id: user1.id
    )

    Recipe.create!(
      title: "Creamy Lemon Pasta",
      description: "A bright, tangy pasta with lemon zest and parmesan.",
      ingredients: <<~INGREDIENTS.strip,
        8 oz spaghetti
        1/3 cup heavy cream
        1 lemon (zest and juice)
        1/2 cup grated parmesan
        Salt & pepper, to taste
      INGREDIENTS
      instructions: <<~INSTRUCTIONS.strip,
        Cook spaghetti according to package directions.
        In a bowl, whisk together cream, lemon zest, lemon juice, and parmesan.
        Drain pasta, reserving a little pasta water.
        Toss hot pasta with the sauce, adding pasta water as needed to loosen.
        Season with salt and pepper and serve immediately.
      INSTRUCTIONS
      servings: 2,
      creator_id: user2.id
    )

end
