# rails-movie-spider
> Movie spider based on rails.

## reset db:
```sql
TRUNCATE TABLE pages;
TRUNCATE TABLE posts;
TRUNCATE TABLE urls;
```


## reset task:
```ruby
rake spider:reset_pages                 # reset pages
rake spider:reset_urls                  # reset urls
```

## fetch pages/urls/posts:
```ruby
rake example_com:fetch_pages                # Fetch pages
rake example_com:fetch_urls                 # Fetch urls
rake example_com:fetch_posts                # Fetch posts
```