# EasyMeals - Meal Prep Planning Application

A full-stack web application for meal planning inspired by HelloFresh. Users can browse vegetarian recipes, select meals for the week, and generate a smart shopping list organized by grocery store categories.

## Features

- 🍽️ Browse 450+ vegetarian recipes with filtering by meal type and prep time
- ⭐ Save favorite recipes for quick access
- 📋 Smart shopping list that aggregates ingredients across multiple recipes
- ✅ Mark ingredients as purchased while shopping
- 🔐 User authentication with Google reCAPTCHA
- 📱 Responsive design with Bootstrap 5

## Tech Stack

- **Backend**: Django 4.1, Django REST Framework, Gunicorn
- **Database**: PostgreSQL 15
- **Frontend**: Django Templates, Bootstrap 5, jQuery
- **Infrastructure**: Docker, Docker Compose, Nginx
- **Cloud**: AWS (EC2, ALB, Route 53, ACM)

## Architecture

```
User → Nginx (reverse proxy) → Gunicorn (WSGI) → Django → PostgreSQL
```

Three-container Docker Compose setup:
- `db`: PostgreSQL with pre-loaded recipe data
- `web`: Django application with Gunicorn
- `nginx`: Reverse proxy and static file server

## Local Development Setup

### Prerequisites

- Docker Desktop for Mac
- Git

### Quick Start

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/easymeals.git
cd easymeals/easymeals
```

2. **Create environment files**

Create `.env`:
```bash
SECRET_KEY_DJANGO=your-secret-key-here
DEBUG=1
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1
CSRF_TRUSTED_ORIGINS=http://localhost http://127.0.0.1
POSTGRES_NAME=easymeals
POSTGRES_USER=easymeals_user
POSTGRES_PASSWORD=local_dev_password
ADMIN_ROUTE=admin
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=admin123
RECAPTCHA_PUBLIC_KEY=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
RECAPTCHA_PRIVATE_KEY=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
```

Create `.prod-env`:
```bash
POSTGRES_NAME=easymeals
POSTGRES_USER=easymeals_user
POSTGRES_PASSWORD=local_dev_password
```

3. **Add database dump and images**

⚠️ **Important**: This repository does NOT include scraped recipe data or images due to copyright considerations.

To run locally, you need:
- `easymeals-db-dump.sql` (PostgreSQL dump with recipe data)
- Recipe images in `mealprep/recipes/static/recipes/`

Place these files in the appropriate directories before building.

4. **Build and run**
```bash
docker-compose build
docker-compose up
```

5. **Access the application**
- Open http://localhost
- Login with: `admin` / `admin123`

## Project Structure

```
easymeals/
├── docker-compose.yml          # Multi-container orchestration
├── Dockerfile                  # Django app container
├── Dockerfile.db              # PostgreSQL container
├── nginx/                     # Nginx configuration
├── mealprep/                  # Django project
│   ├── mealprep/             # Settings, URLs, WSGI
│   ├── recipes/              # Main app (models, views, templates)
│   ├── accounts/             # Authentication app
│   └── requirements.txt      # Python dependencies
└── docs/                      # Documentation
```

## Key Features Implementation

### Smart Shopping List
Aggregates ingredients across all active recipes using database-level operations:
```python
ingredients = RecipeIngredient.objects.filter(recipe_id__in=recipes_list)
    .values('ingredient_id', 'ingredient__ingredient_class', ...)
    .annotate(quantity=Sum("quantity"))
```

### Recipe State Management
- Users can mark recipes as "active" (this week) or "favorite" (saved)
- AJAX endpoints for seamless state updates
- Shopping list auto-resets when active recipes change

## Deployment

See `docs/DEPLOYMENT-RULEBOOK.md` for comprehensive deployment instructions covering:
- Local Mac testing
- AWS EC2 deployment
- Domain setup (Route 53)
- SSL certificates (ACM)
- Load balancer configuration (ALB)

## Security Features

- ✅ CSRF protection on all forms
- ✅ Session cookies with Secure and HttpOnly flags
- ✅ Google reCAPTCHA on login
- ✅ Environment variables for all secrets
- ✅ Non-standard admin URL path
- ✅ HTTPS-only in production

## Development Notes

### Data Pipeline (Historical)
The recipe data was collected via:
1. Web scraping with Selenium (HelloFresh France)
2. HTML parsing and JSON extraction
3. Data cleaning and categorization
4. PostgreSQL import


### Database Schema
- 12 tables with normalized design
- Recipe metadata (title, time, difficulty, nutrition)
- Ingredient categorization for shopping list grouping
- User state (active recipes, favorites, shopping list)

## Contributing

This is a personal portfolio project. Feel free to fork and adapt for your own use.

## License

**Code**: This project's source code is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

This means:
- ✅ You can use, modify, and distribute this code
- ✅ You must disclose your source code when distributing
- ✅ You must license derivative works under GPL-3.0
- ✅ You must state changes made to the code

See [LICENSE](LICENSE) for full terms.

**Data**: Recipe data and images are NOT included in this repository and are not covered by this license. They remain the property of their original copyright holders.

## Contact

For questions about this project, please open an issue on GitHub.

---

