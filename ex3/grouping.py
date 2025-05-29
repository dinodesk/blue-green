import requests
from typing import List, Dict
from pydantic import BaseModel
from datetime import datetime, date
from collections import defaultdict
import os
import json

class Transaction(BaseModel):
    userId: str
    AcctId: str
    Date: datetime
    TransactionId: str
    TransactionAmount: float
    TransactionDetails: str

def fetch_transactions_from_api(url: str) -> List[Transaction]:
    response = requests.get(url)
    response.raise_for_status()
    raw_data = response.json()
    return [Transaction(**item) for item in raw_data]

def group_transactions_by_date(transactions: List[Transaction]) -> Dict[date, List[Transaction]]:
    grouped = defaultdict(list)
    for tx in transactions:
        grouped[tx.Date.date()].append(tx)
    return dict(grouped)

def save_transactions_by_date(grouped_data: Dict[date, List[Transaction]], output_dir: str):
    os.makedirs(output_dir, exist_ok=True)
    for date_key, tx_list in grouped_data.items():
        filename = os.path.join(output_dir, f"{date_key.isoformat()}.json")
        with open(filename, 'w') as f:
            json.dump([tx.dict() for tx in tx_list], f, indent=2, default=str)

# Usage
if __name__ == "__main__":
    api_url = "https://example.com/api/transactions"  # Replace with your API endpoint
    try:
        transactions = fetch_transactions_from_api(api_url)
        grouped = group_transactions_by_date(transactions)
        save_transactions_by_date(grouped, output_dir="transactions_by_date")
        print("Transactions processed and saved.")
    except requests.RequestException as e:
        print(f"API request failed: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
