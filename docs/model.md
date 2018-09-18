# model:
> Page/Url/Post

## migrations:
```shell
rails g model Page key:string url:string grabbed:boolean
rails g model Url key:string url:string grabbed:boolean
rails g model Post title:string content:text category_id:integer rate:float cover:string release_date:datetime attachments:string{4000}
```

## primary key use key:
```rb
  create_table :posts, id: false do |t|
    t.string :key, limit: 100, auto_increment: false, primary_key: true
    t.string :title
    t.text :content
    t.integer :category_id
    t.float :rate
    t.string :cover
    t.datetime :release_date
    t.string :attachments, limit: 4000

    t.timestamps
  end
```