
import csv
import random
from pathlib import Path
from datetime import datetime, timedelta

random.seed(42)

# Save CSV files in the same folder as this Python script
OUTPUT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def write_csv(filename, rows):
    """Write a list of dictionaries into a CSV file."""
    if not rows:
        return

    filepath = OUTPUT_DIR / filename

    with open(filepath, "w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

    print(f"Created {filename}: {len(rows)} records")


# -------------------------------------------------
# 1. CUSTOMERS
# -------------------------------------------------

first_names = [
    "Aarav", "Priya", "Rahul", "Ananya", "Arjun",
    "Sneha", "Kiran", "Meera", "Rohan", "Divya"
]

last_names = [
    "Sharma", "Reddy", "Patel", "Kumar", "Verma",
    "Rao", "Singh", "Gupta", "Nair", "Iyer"
]

cities = [
    "Hyderabad", "Bangalore", "Chennai",
    "Mumbai", "Delhi", "Pune"
]

customers = []

for customer_id in range(1, 101):
    first = random.choice(first_names)
    last = random.choice(last_names)

    email = f"{first.lower()}.{last.lower()}{customer_id}@example.com"

    # Introduce missing emails for data-quality testing
    if customer_id in [12, 35, 78]:
        email = None

    signup_date = datetime(2024, 1, 1) + timedelta(
        days=random.randint(0, 700)
    )

    customers.append({
        "customer_id": customer_id,
        "customer_name": f"{first} {last}",
        "email": email,
        "city": random.choice(cities),
        "signup_date": signup_date.strftime("%Y-%m-%d"),
        "updated_at": (
            signup_date + timedelta(days=random.randint(0, 100))
        ).strftime("%Y-%m-%d %H:%M:%S")
    })

# Introduce a duplicate customer record
duplicate_customer = customers[10].copy()
duplicate_customer["city"] = "Mumbai"
duplicate_customer["updated_at"] = "2026-10-15 10:30:00"
customers.append(duplicate_customer)

write_csv("customers.csv", customers)


# -------------------------------------------------
# 2. PRODUCTS
# -------------------------------------------------

categories = [
    "Electronics", "Fashion", "Home",
    "Beauty", "Sports", "Books"
]

products = []

for product_id in range(1, 31):
    products.append({
        "product_id": product_id,
        "product_name": f"Product_{product_id}",
        "category": random.choice(categories),
        "price": round(random.uniform(199, 25000), 2)
    })

write_csv("products.csv", products)


# -------------------------------------------------
# 3. ORDERS
# -------------------------------------------------

order_statuses = [
    "Delivered", "Shipped", "Processing",
    "Cancelled", "Pending"
]

orders = []

for order_id in range(1, 301):
    order_date = datetime(2025, 1, 1) + timedelta(
        days=random.randint(0, 650)
    )

    orders.append({
        "order_id": order_id,
        "customer_id": random.randint(1, 100),
        "order_date": order_date.strftime("%Y-%m-%d"),
        "status": random.choice(order_statuses)
    })

write_csv("orders.csv", orders)


# -------------------------------------------------
# 4. ORDER ITEMS
# -------------------------------------------------

order_items = []
order_item_id = 1

product_prices = {
    product["product_id"]: product["price"]
    for product in products
}

for order in orders:
    number_of_items = random.randint(1, 4)

    selected_products = random.sample(
        products, number_of_items
    )

    for product in selected_products:
        order_items.append({
            "order_item_id": order_item_id,
            "order_id": order["order_id"],
            "product_id": product["product_id"],
            "quantity": random.randint(1, 3),
            "unit_price": product_prices[product["product_id"]]
        })

        order_item_id += 1

write_csv("order_items.csv", order_items)


# -------------------------------------------------
# 5. PAYMENTS
# -------------------------------------------------

payment_statuses = [
    "SUCCESS", "SUCCESS", "SUCCESS",
    "FAILED", "PENDING", "REFUNDED"
]

order_totals = {}

for item in order_items:
    order_id = item["order_id"]

    item_total = item["quantity"] * item["unit_price"]

    order_totals[order_id] = (
        order_totals.get(order_id, 0) + item_total
    )

payments = []

for order in orders:
    order_id = order["order_id"]

    payment_date = datetime.strptime(
        order["order_date"], "%Y-%m-%d"
    ) + timedelta(days=random.randint(0, 5))

    payments.append({
        "payment_id": order_id,
        "order_id": order_id,
        "payment_date": payment_date.strftime("%Y-%m-%d"),
        "amount": round(order_totals[order_id], 2),
        "payment_status": random.choice(payment_statuses)
    })

write_csv("payments.csv", payments)


# -------------------------------------------------
# 6. SHIPMENTS
# -------------------------------------------------

shipment_statuses = [
    "DELIVERED", "IN_TRANSIT", "RETURNED"
]

shipments = []
shipment_id = 1

for order in orders:

    # Cancelled and pending orders are not necessarily shipped
    if order["status"] in ["Cancelled", "Pending"]:
        continue

    # Some eligible orders have no shipment record
    if random.random() < 0.15:
        continue

    order_date = datetime.strptime(
        order["order_date"], "%Y-%m-%d"
    )

    ship_date = order_date + timedelta(
        days=random.randint(1, 4)
    )

    shipping_status = random.choice(shipment_statuses)

    delivery_date = None

    if shipping_status in ["DELIVERED", "RETURNED"]:
        delivery_date = (
            ship_date + timedelta(days=random.randint(1, 10))
        ).strftime("%Y-%m-%d")

    shipments.append({
        "shipment_id": shipment_id,
        "order_id": order["order_id"],
        "ship_date": ship_date.strftime("%Y-%m-%d"),
        "delivery_date": delivery_date,
        "shipping_status": shipping_status
    })

    shipment_id += 1

write_csv("shipments.csv", shipments)


# -------------------------------------------------
# COMPLETION
# -------------------------------------------------

print("\nAll e-commerce datasets generated successfully!")
print(f"Output folder: {OUTPUT_DIR}")
