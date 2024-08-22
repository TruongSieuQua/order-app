CREATE DATABASE orderdb;

CREATE TABLE IF NOT EXISTS "users" (
    "id" SERIAL NOT NULL UNIQUE,
    "username" VARCHAR(64) NOT NULL
    "status" VARCHAR(10) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "login_attempt" INTEGER NOT NULL DEFAULT 0,
    "recovery_email" VARCHAR(128) NOT NULL,
    PRIMARY KEY ("id")
);
-- 200
CREATE TABLE IF NOT EXISTS "customers" (
    "id" SERIAL NOT NULL UNIQUE,
    "first_name" VARCHAR(64) NOT NULL,
    "last_name" VARCHAR(64) NOT NULL,
    "phone_number" VARCHAR(20) NOT NULL,
    "email" VARCHAR(128),
    "user_id" BIGINT,
    PRIMARY KEY ("id"),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "categories" (
    "id" SERIAL NOT NULL UNIQUE,
    "name" VARCHAR(64) NOT NULL,
    "description" VARCHAR(256) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
-- 100
CREATE TABLE IF NOT EXISTS "products" (
    "id" SERIAL NOT NULL UNIQUE,
    "name" VARCHAR(256) NOT NULL,
    "image" VARCHAR(256),
    "description" VARCHAR(256) NOT NULL,
    "quantity" BIGINT NOT NULL,
    "unit" VARCHAR(255) NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "tax_rate" DECIMAL(10,2) NOT NULL,
    "available" BOOLEAN NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "products_categories" (
     "id" SERIAL NOT NULL UNIQUE,
     "product_id" BIGINT NOT NULL,
     "category_id" BIGINT NOT NULL,
     PRIMARY KEY ("id")
    CONSTRAINT unique_product_category UNIQUE ("product_id", "category_id")
);

-- 60
CREATE TABLE IF NOT EXISTS "addresses" (
    "id" SERIAL NOT NULL UNIQUE,
    "country" VARCHAR(64) NOT NULL,
    "city" VARCHAR(64) NOT NULL,
    "postal_code" VARCHAR(32),
    "street" VARCHAR(64) NOT NULL,
    "address" VARCHAR(128) NOT NULL,
    PRIMARY KEY ("id")
);

-- 80
CREATE TABLE IF NOT EXISTS "shipment" (
    "id" SERIAL NOT NULL UNIQUE,
    "status" VARCHAR(255) NOT NULL,
    "address_id" BIGINT NOT NULL,
    "receive_date" TIMESTAMP with time zone NOT NULL,
    "ship_cost" DECIMAL(10,2) NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE CASCADE
);

-- 100
CREATE TABLE IF NOT EXISTS "orders" (
    "id" SERIAL NOT NULL UNIQUE,
    "status" VARCHAR(255) NOT NULL,
    "customer_id" BIGINT NOT NULL,
    "shipment_id" BIGINT,
    "total_price" DECIMAL(10,2),
    "messages" VARCHAR(512) NOT NULL DEFAULT '',
    PRIMARY KEY ("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id") ON DELETE SET NULL,
    FOREIGN KEY ("shipment_id") REFERENCES "shipment"("id") ON DELETE SET NULL
);

-- 400
CREATE TABLE IF NOT EXISTS "order_details" (
    "id" SERIAL NOT NULL UNIQUE,
    "order_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "unit" VARCHAR(64) NOT NULL,
    "quantity" BIGINT NOT NULL,
    "tax_rate" DECIMAL(10,2) NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE,
    FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE CASCADE,
    CONSTRAINT order_product_unique UNIQUE ("order_id", "product_id")
);

-- 100
CREATE TABLE IF NOT EXISTS "payments" (
    "id" SERIAL NOT NULL UNIQUE,
    "method" VARCHAR(255) NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "order_id" BIGINT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "created_date" TIMESTAMP,
    "payment_reference" VARCHAR(256) NOT NULL,
    "messages" VARCHAR(512) NOT NULL DEFAULT '',
    PRIMARY KEY ("id"),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
