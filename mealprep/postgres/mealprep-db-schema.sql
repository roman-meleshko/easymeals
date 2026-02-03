/* DB SCHEMA FOR MEAL-PREP DJANGO WEB APP */


/* Recipe related tables */

CREATE TYPE difficulty_type AS ENUM ('Facile', 'Intermédiaire', 'Difficile');

CREATE TABLE recipe (
	recipe_id serial    PRIMARY KEY,
    recipe_id_hash      bigint NOT NULL,
	title		        varchar(200) NOT NULL,
	subtitle	        varchar(200) NOT NULL,
	time_total	        smallint NOT NULL,
	time_prep	        smallint NOT NULL,
	difficulty	        difficulty_type NOT NULL,
	meal_type           varchar(50) NOT NULL,
	recipe_json         varchar(10000) NOT NULL
);


CREATE TABLE ingredient (
	ingredient_id		serial PRIMARY KEY,
    ingredient_id_hash	bigint NOT NULL,
	ingredient_name		varchar(200) NOT NULL,
	ingredient_type		varchar(10) NOT NULL,
	ingredient_class	varchar(200) NOT NULL

);


CREATE TABLE tag (
	tag_id		serial PRIMARY KEY,
	tag_name	varchar(50) NOT NULL		
);


CREATE TABLE tool (
	tool_id		serial PRIMARY KEY,
	tool_name	varchar(100) NOT NULL		
);


CREATE TABLE recipe_ingredient (
	id				serial PRIMARY KEY,
	recipe_id		smallint REFERENCES recipe (recipe_id) ON DELETE RESTRICT,
	ingredient_id	smallint REFERENCES ingredient (ingredient_id) ON DELETE RESTRICT,		
	quantity		real NOT NULL,			
	quantity_unit	varchar(20) NOT NULL
);


CREATE TABLE recipe_nutr_value (
	id					serial PRIMARY KEY,
	recipe_id			smallint REFERENCES recipe (recipe_id) ON DELETE RESTRICT,
	energie_kj			real NOT NULL,
	energie_kcal		real NOT NULL,
	matieres_grasses	real NOT NULL,
	acides_gras_satures real NOT NULL,
	glucides			real NOT NULL,
	sucres				real NOT NULL,
	proteines			real NOT NULL,
	sel					real NOT NULL
);


CREATE TABLE recipe_tag (
	id			serial PRIMARY KEY,
	recipe_id	smallint REFERENCES recipe (recipe_id) ON DELETE RESTRICT,
	tag_id		smallint REFERENCES tag (tag_id) ON DELETE RESTRICT	
	
);


CREATE TABLE recipe_tool (
	id			serial PRIMARY KEY,
	recipe_id	smallint REFERENCES recipe (recipe_id) ON DELETE RESTRICT,
	tool_id		smallint REFERENCES tool (tool_id) ON DELETE RESTRICT	
	
);



/* Load recipe data from CSV files */

\COPY recipe 			FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/recipe.csv' DELIMITER ',' CSV HEADER;
\COPY ingredient			FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/ingredient.csv' DELIMITER ',' CSV HEADER;
\COPY tool 				FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/tool.csv' DELIMITER ',' CSV HEADER;
\COPY tag 				FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/tag.csv' DELIMITER ',' CSV HEADER;
\COPY recipe_tool 		FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/recipe_tool.csv' DELIMITER ',' CSV HEADER;
\COPY recipe_tag 		FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/recipe_tag.csv' DELIMITER ',' CSV HEADER;
\COPY recipe_nutr_value	FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/recipe_nutr_value.csv' DELIMITER ',' CSV HEADER;
\COPY recipe_ingredient	FROM '/Users/salander/projects/mealprep-project/recipes/postgres/csv/recipe_ingredient.csv' DELIMITER ',' CSV HEADER;

