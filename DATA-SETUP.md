# Data Setup Instructions

This file explains how to obtain the recipe data and images needed to run EasyMeals locally or deploy to production.

## ⚠️ Important Legal Notice

The recipe data and images in this project were scraped from HelloFresh France for **educational and personal use only**. They are NOT included in this public repository due to copyright considerations.

**Do NOT**:
- Redistribute the scraped data
- Use it for commercial purposes
- Run the scraping scripts against HelloFresh without permission

## For Local Development

### Option 1: Use Your Own Data (Recommended)

Replace the HelloFresh data with your own recipes:

1. **Create your own database dump**:
   - Populate PostgreSQL with your own recipe data
   - Export: `pg_dump -U postgres easymeals > easymeals-db-dump.sql`

2. **Add your own images**:
   - Place recipe images in `mealprep/recipes/static/recipes/images/`
   - Update recipe JSON to reference your image paths

### Option 2: Request Data from Project Owner

If you're a recruiter or interviewer evaluating this project:

1. Contact the project owner
2. Request access to a sanitized demo dataset
3. Owner will provide:
   - `easymeals-db-dump.sql` (anonymized/sample data)
   - Sample recipe images

### Option 3: Mock Data for Testing

Create minimal test data:

```sql
-- Create test database
CREATE DATABASE easymeals;
\c easymeals

-- Create minimal schema (see mealprep/postgres/schema.sql for full schema)
CREATE TABLE recipe (
    recipe_id SERIAL PRIMARY KEY,
    recipe_id_hash BIGINT,
    title VARCHAR(200),
    subtitle VARCHAR(200),
    time_total SMALLINT,
    time_prep SMALLINT,
    difficulty VARCHAR(20),
    meal_type VARCHAR(50),
    recipe_json VARCHAR(10000)
);

-- Insert test recipe
INSERT INTO recipe VALUES (
    1, 123456, 'Test Recipe', 'A simple test', 30, 15, 'Facile', 'Plat principal',
    '{"title": {"main": "Test Recipe", "secondary": "A simple test"}, "ingredients": {"buy": [["Tomato", "2", "pieces"]], "have": []}, "instructions": ["Step 1"], "nutritional_val": [100, 50, 10, 5, 20, 5, 15, 1]}'
);

-- Export
pg_dump -U postgres easymeals > easymeals-db-dump.sql
```

## File Locations

When you have the data, place files here:

```
easymeals/
├── easymeals-db-dump.sql                    # PostgreSQL dump (NOT in git)
└── mealprep/
    └── recipes/
        └── static/
            └── recipes/
                └── images/                   # Recipe images (NOT in git)
                    ├── recipe_1.jpg
                    ├── recipe_2.jpg
                    └── ...
```

## Verification

After placing files, verify:

```bash
# Check database dump exists
ls -lh easymeals-db-dump.sql

# Check images directory
ls mealprep/recipes/static/recipes/images/ | head -5

# Build and run
docker-compose build
docker-compose up
```

## For Deployment (AWS EC2)

### Transfer Data Securely

**Do NOT commit data to GitHub.** Instead:

1. **Upload via SCP**:
```bash
# From your local machine
scp -i ~/.ssh/easymeals-key.pem \
    easymeals-db-dump.sql \
    ec2-user@YOUR_EC2_IP:~/easymeals/easymeals/

scp -i ~/.ssh/easymeals-key.pem -r \
    mealprep/recipes/static/recipes/images/ \
    ec2-user@YOUR_EC2_IP:~/easymeals/easymeals/mealprep/recipes/static/recipes/
```

2. **Or use S3 for images** (recommended for production):
```bash
# Upload images to private S3 bucket
aws s3 sync mealprep/recipes/static/recipes/images/ \
    s3://your-bucket-name/recipe-images/ \
    --acl private

# Configure Django to serve from S3 (requires django-storages)
```

## Alternative: Use Public Domain Recipes

To make this project fully open-source, consider:

1. **Replace with public domain recipes**:
   - Use recipes from Wikimedia Commons
   - Scrape from sites with permissive licenses
   - Create original recipes

2. **Use placeholder images**:
   - Generate with AI (Stable Diffusion, DALL-E)
   - Use stock photos with proper licenses
   - Create simple placeholder graphics

## Questions?

If you're evaluating this project for a job interview and need access to demo data, please contact the project owner directly.
