# Task 5.1: Normalization Analysis

## Given Denormalized Table

| order_id | customer_name | customer_email | product_name | product_price | quantity | order_date |
|---------|---------------|---------------|--------------|--------------|----------|-----------|
| 1 | Alice Smith | alice@mail.com | Laptop | 999.99 | 1 | 2024-01-15 |
| 2 | Alice Smith | alice@mail.com | Mouse | 29.99 | 2 | 2024-01-16 |
| 3 | Bob Johnson | bob@mail.com | Laptop | 999.99 | 1 | 2024-01-17 |

---

# 1. What normal form is this table in? Why?

The table is in **First Normal Form (1NF)**.

### Reason
A table is in **1NF** if:
- Each column contains **atomic (indivisible) values**
- Each record (row) is **uniquely identifiable**
- There are **no repeating groups or arrays**

In this table:
- Each column stores a single value (e.g., `product_name`, `quantity`)
- No column contains multiple values

However, the table **does not satisfy 2NF or 3NF** because several attributes depend on non-key attributes rather than the primary key.

---

# 2. Problems With This Design

## 1. Data Redundancy
Customer and product information is repeated multiple times.

Example:

| customer_name | customer_email |
|---------------|---------------|
| Alice Smith | alice@mail.com |
| Alice Smith | alice@mail.com |

| product_name | product_price |
|--------------|--------------|
| Laptop | 999.99 |
| Laptop | 999.99 |

This wastes storage and increases maintenance complexity.

---

## 2. Update Anomaly
If a product price changes, multiple rows must be updated.

Example:
If the **Laptop price changes**, every row containing `Laptop` must be updated.

---

## 3. Insert Anomaly
You cannot insert a **new customer or product** unless an order exists.

Example:
You cannot add a new product to the system without creating an order.

---

## 4. Delete Anomaly
Deleting an order may remove important data.

Example:
If Bob's only order is deleted, all information about **Bob Johnson** disappears.

---

# 3. Normalized Schema (3NF)

To remove redundancy and anomalies, the table should be split into **four related tables**.

## Customers

| Column | Description |
|------|-------------|
| id | Primary Key |
| name | Customer name |
| email | Customer email (unique) |

---

## Products

| Column | Description |
|------|-------------|
| id | Primary Key |
| name | Product name |
| price | Product price |

---

## Orders

| Column | Description |
|------|-------------|
| id | Primary Key |
| customer_id | References customers(id) |
| order_date | Date order was created |

---

## Order_Items

| Column | Description |
|------|-------------|
| id | Primary Key |
| order_id | References orders(id) |
| product_id | References products(id) |
| quantity | Quantity ordered |

---

# Relationships
Customers (1) ---- (Many) Orders
Orders (1) ---- (Many) Order_Items
Products (1) ---- (Many) Order_Items

This design eliminates duplicated customer and product data.

---

# 4. SQL to Create Normalized Tables

## Customers Table

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
```

## Products Table
```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
```
## Orders Table
```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE NOT NULL
);
```

## Order Items Table
```sql
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL
);
```

# Task 5.2: Entity Relationship Design – Blog Platform

## 1. Tables to Create

To satisfy the requirements, the following tables are needed:

- users
- posts
- comments
- tags
- categories
- post_tags (junction table)
- follows (self-referencing many-to-many)
- post_views

---

# 2. Table Definitions (Columns + Data Types)

## Users

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| username | VARCHAR(50) | Unique username |
| email | VARCHAR(100) | User email |
| created_at | TIMESTAMP | Account creation date |

---

## Posts

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| user_id | INTEGER | FK → users(id) |
| title | VARCHAR(200) | Post title |
| content | TEXT | Post content |
| category_id | INTEGER | FK → categories(id) |
| created_at | TIMESTAMP | Created date |

---

## Comments

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| post_id | INTEGER | FK → posts(id) |
| user_id | INTEGER | FK → users(id) |
| content | TEXT | Comment text |
| created_at | TIMESTAMP | Comment date |

---

## Tags

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| name | VARCHAR(50) | Tag name (unique) |

---

## Categories

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| name | VARCHAR(100) | Category name |

---

## Post_Tags (Junction Table)

| Column | Type | Description |
|--------|------|-------------|
| post_id | INTEGER | FK → posts(id) |
| tag_id | INTEGER | FK → tags(id) |

Primary Key: (post_id, tag_id)

---

## Follows (Self-referencing many-to-many)

| Column | Type | Description |
|--------|------|-------------|
| follower_id | INTEGER | FK → users(id) |
| following_id | INTEGER | FK → users(id) |

Primary Key: (follower_id, following_id)

---

## Post_Views

| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary Key |
| post_id | INTEGER | FK → posts(id) |
| user_id | INTEGER | FK → users(id), nullable |
| viewed_at | TIMESTAMP | View timestamp |

---

# 3. Primary Keys and Foreign Keys

## Primary Keys
- users.id
- posts.id
- comments.id
- tags.id
- categories.id
- post_views.id
- Composite:
  - post_tags (post_id, tag_id)
  - follows (follower_id, following_id)

## Foreign Keys
- posts.user_id → users.id
- posts.category_id → categories.id
- comments.post_id → posts.id
- comments.user_id → users.id
- post_tags.post_id → posts.id
- post_tags.tag_id → tags.id
- follows.follower_id → users.id
- follows.following_id → users.id
- post_views.post_id → posts.id
- post_views.user_id → users.id

---

# 4. Junction Tables

Junction tables are required for many-to-many relationships:

1. post_tags → connects posts and tags  
2. follows → connects users to other users  

---

# 5. CREATE TABLE Statements

## Users

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Categories

```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
```

## Posts

```sql
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    category_id INTEGER REFERENCES categories(id),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Comments
```sql
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Tags
```sql
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
```

## Post tags
```sql
CREATE TABLE post_tags (
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);
```

## Follows
```sql
CREATE TABLE follows (
    follower_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (follower_id, following_id)
);
```

## Post Views
```sql
CREATE TABLE post_views (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```